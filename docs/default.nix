{
  lib,
  modules,
  pkgs,
}: let
  nixvimPath = toString ./..;

  gitHubDeclaration = user: repo: subpath: {
    url = "https://github.com/${user}/${repo}/blob/master/${subpath}";
    name = "<${repo}/${subpath}>";
  };

  transformOptions = opt:
    opt
    // {
      declarations =
        map (
          decl:
            if pkgs.lib.hasPrefix nixvimPath (toString decl)
            then
              gitHubDeclaration "nix-community" "nixvim"
              (pkgs.lib.removePrefix "/" (pkgs.lib.removePrefix nixvimPath (toString decl)))
            else if decl == "lib/modules.nix"
            then gitHubDeclaration "NixOS" "nixpkgs" decl
            else decl
        )
        opt.declarations;
    };

  getSubOptions' = type: loc: let
    types =
      # Composite types
      {
        either =
          (getSubOptions' type.nestedTypes.left loc)
          // (getSubOptions' type.nestedTypes.right loc);
        nullOr = getSubOptions' type.nestedTypes.elemType loc;
        lazyAttrsOf = getSubOptions' type.nestedTypes.elemType (loc ++ ["<name>"]);
        attrsOf = getSubOptions' type.nestedTypes.elemType (loc ++ ["<name>"]);
        listOf = getSubOptions' type.nestedTypes.elemType (loc ++ ["*"]);
        functionTo = getSubOptions' type.nestedTypes.elemType (loc ++ ["<function body>"]);

        # Taken from lib/types.nix
        submodule = let
          base = lib.evalModules {
            modules =
              [
                {
                  _module.args.name = lib.mkOptionDefault "‹name›";
                }
              ]
              ++ type.getSubModules;
          };
          inherit (base._module) freeformType;
        in
          (base.extendModules
            {prefix = loc;})
          .options
          // lib.optionalAttrs (freeformType != null) {
            _freeformOptions = getSubOptions' freeformType loc;
          };
      }
      # Leaf types
      // lib.genAttrs [
        "raw"
        "bool"
        "optionType"
        "unspecified"
        "str"
        "attrs"
        "rawLua"
        "int"
        "package"
        "numberBetween"
        "enum"
        "anything"
        "separatedString"
        "path"
        "maintainer"
        "unsignedInt"
        "float"
        "positiveInt"
        "intBetween"
        "nullType"
        "nonEmptyStr"
        "nixvim-configuration"
      ] (_: {});
  in
    # For recursive types avoid calculating sub options, else this
    # will end up in an unbounded recursion
    if loc == ["plugins" "packer" "plugins" "*" "requires"]
    then {}
    else if builtins.hasAttr type.name types
    then types.${type.name}
    else throw "unhandled type in documentation: ${type.name}";

  mkOptionsJSON = options: let
    # Mainly present to patch the type.getSubOptions of `either`, but we need to patch all
    # the options in order to correctly handle other composite options
    # The code that follows is taken almost exactly from nixpkgs,
    # by changing type.getSubOptions to getSubOptions'
    # lib/options.nix
    optionAttrSetToDocList' = _: options:
      lib.concatMap (opt: let
        name = lib.showOption opt.loc;
        docOption =
          {
            inherit (opt) loc;
            inherit name;
            description = opt.description or null;
            declarations = builtins.filter (x: x != lib.unknownModule) opt.declarations;
            internal = opt.internal or false;
            visible =
              if (opt ? visible && opt.visible == "shallow")
              then true
              else opt.visible or true;
            readOnly = opt.readOnly or false;
            type = opt.type.description or "unspecified";
          }
          // lib.optionalAttrs (opt ? example) {
            example = builtins.addErrorContext "while evaluating the example of option `${name}`" (
              lib.options.renderOptionValue opt.example
            );
          }
          // lib.optionalAttrs (opt ? defaultText || opt ? default) {
            default =
              builtins.addErrorContext "while evaluating the ${
                if opt ? defaultText
                then "defaultText"
                else "default value"
              } of option `${name}`" (
                lib.options.renderOptionValue (opt.defaultText or opt.default)
              );
          }
          // lib.optionalAttrs (opt ? relatedPackages && opt.relatedPackages != null) {inherit (opt) relatedPackages;};

        subOptions = let
          ss = getSubOptions' opt.type opt.loc;
        in
          if ss != {}
          then optionAttrSetToDocList' opt.loc ss
          else [];
        subOptionsVisible = docOption.visible && opt.visible or null != "shallow";
      in
        # To find infinite recursion in NixOS option docs:
        # builtins.trace opt.loc
        [docOption] ++ lib.optionals subOptionsVisible subOptions) (lib.collect lib.isOption options);

    # Generate documentation template from the list of option declaration like
    # the set generated with filterOptionSets.
    optionAttrSetToDocList = optionAttrSetToDocList' [];

    # nixos/lib/make-options-doc/default.nix

    rawOpts = optionAttrSetToDocList options;
    transformedOpts = map transformOptions rawOpts;
    filteredOpts = lib.filter (opt: opt.visible && !opt.internal) transformedOpts;

    # Generate DocBook documentation for a list of packages. This is
    # what `relatedPackages` option of `mkOption` from
    # ../../../lib/options.nix influences.
    #
    # Each element of `relatedPackages` can be either
    # - a string:  that will be interpreted as an attribute name from `pkgs` and turned into a link
    #              to search.nixos.org,
    # - a list:    that will be interpreted as an attribute path from `pkgs` and turned into a link
    #              to search.nixos.org,
    # - an attrset: that can specify `name`, `path`, `comment`
    #   (either of `name`, `path` is required, the rest are optional).
    #
    # NOTE: No checks against `pkgs` are made to ensure that the referenced package actually exists.
    # Such checks are not compatible with option docs caching.
    genRelatedPackages = packages: optName: let
      unpack = p:
        if lib.isString p
        then {name = p;}
        else if lib.isList p
        then {path = p;}
        else p;
      describe = args: let
        title = args.title or null;
        name = args.name or (lib.concatStringsSep "." args.path);
      in ''
        - [${lib.optionalString (title != null) "${title} aka "}`pkgs.${name}`](
            https://search.nixos.org/packages?show=${name}&sort=relevance&query=${name}
          )${
          lib.optionalString (args ? comment) "\n\n  ${args.comment}"
        }
      '';
    in
      lib.concatMapStrings (p: describe (unpack p)) packages;

    nixvimOptionsList =
      lib.flip map filteredOpts
      (
        opt:
          opt
          // lib.optionalAttrs (opt ? relatedPackages && opt.relatedPackages != []) {
            relatedPackages = genRelatedPackages opt.relatedPackages opt.name;
          }
      );

    nixvimOptionsNix = builtins.listToAttrs (map (o: {
        inherit (o) name;
        value = removeAttrs o ["name" "visible" "internal"];
      })
      nixvimOptionsList);
  in
    pkgs.runCommand "options.json"
    {
      meta.description = "List of NixOS options in JSON format";
      nativeBuildInputs = [
        pkgs.brotli
        pkgs.python3Minimal
      ];
      options =
        builtins.toFile "options.json"
        (builtins.unsafeDiscardStringContext (builtins.toJSON nixvimOptionsNix));
      baseJSON = builtins.toFile "base.json" "{}";
    }
    ''
        # Export list of options in different format.
        dst=$out/share/doc/nixos
        mkdir -p $dst

        TOUCH_IF_DB=$dst/.used-docbook \
        python ${pkgs.path}/nixos/lib/make-options-doc/mergeJSON.py \
          $baseJSON $options \
          > $dst/options.json

      if grep /nixpkgs/nixos/modules $dst/options.json; then
        echo "The manual appears to depend on the location of Nixpkgs, which is bad"
        echo "since this prevents sharing via the NixOS channel.  This is typically"
        echo "caused by an option default that refers to a relative path (see above"
        echo "for hints about the offending path)."
        exit 1
      fi

        brotli -9 < $dst/options.json > $dst/options.json.br

        mkdir -p $out/nix-support
        echo "file json $dst/options.json" >> $out/nix-support/hydra-build-products
        echo "file json-br $dst/options.json.br" >> $out/nix-support/hydra-build-products
    '';

  nixvmConfigType = lib.mkOptionType {
    name = "nixvim-configuration";
    description = "nixvim configuration options";
    descriptionClass = "noun";
    # Evaluation is irrelevant, only used for documentation.
  };

  topLevelModules =
    [
      ../wrappers/modules/output.nix
      # Fake module to avoid a duplicated documentation
      (lib.setDefaultModuleLocation "${nixvimPath}/wrappers/modules/files.nix" {
        options.files = lib.mkOption {
          type = lib.types.attrsOf nixvmConfigType;
          description = "Extra files to add to the runtimepath";
          example = {
            "ftplugin/nix.lua" = {
              options = {
                tabstop = 2;
                shiftwidth = 2;
                expandtab = true;
              };
            };
          };
        };
      })
    ]
    ++ modules;
in
  rec {
    options-json = mkOptionsJSON (lib.evalModules {modules = topLevelModules;}).options;
    man-docs = pkgs.callPackage ./man {inherit options-json;};
  }
  # Do not check if documentation builds fine on darwin as it fails:
  # > sandbox-exec: pattern serialization length 69298 exceeds maximum (65535)
  // lib.optionalAttrs (!pkgs.stdenv.isDarwin) {
    docs = pkgs.callPackage ./mdbook {
      inherit mkOptionsJSON getSubOptions';
      modules = topLevelModules;
    };
  }
