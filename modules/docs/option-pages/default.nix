{
  lib,
  config,
  options,
  pkgs,
  ...
}:
let
  inherit (config.docs._utils)
    mkOptionList
    ;

  # Gets the page that owns this option.
  # We can use `findFirst` because `pageScopes` is a sorted list.
  getPageFor =
    loc: (lib.findFirst (pair: lib.lists.hasPrefix pair.scope loc) null pageScopePairs).page or null;

  optionsLists = builtins.groupBy (opt: getPageFor opt.loc) (mkOptionList options);

  # A list of { page, scope } pairs, sorted by scope length (longest first)
  pageScopePairs = lib.pipe config.docs.optionPages [
    (lib.mapAttrsToList (
      name: page: {
        page = name;
        scopes = page.optionScopes;
      }
    ))
    (builtins.concatMap ({ page, scopes }: builtins.map (scope: { inherit page scope; }) scopes))
    (lib.sortOn (pair: 0 - builtins.length pair.scope))
  ];

  # Custom type to simplify type checking & merging.
  # `listOf str` is overkill and problematic for our use-case.
  optionLocType = lib.mkOptionType {
    name = "option-loc";
    description = "option location";
    descriptionClass = "noun";
    check = v: lib.isList v && lib.all lib.isString v;
  };

  optionsPageModule =
    { name, config, ... }:
    {
      options = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = config.optionsList != [ ];
          defaultText = lib.literalExpression ''optionsList != [ ]'';
          example = true;
          description = "Whether to define a page derived from this optionsPage.";
        };
        optionsList = lib.mkOption {
          type = with lib.types; listOf raw;
          description = ''
            List of options matching `scopes`.
          '';
          readOnly = true;
        };
        optionsJSON = lib.mkOption {
          type = lib.types.package;
          description = ''
            `options.json` file, as expected by `nixos-render-docs`.
          '';
          readOnly = true;
        };
        page = lib.mkOption {
          type = lib.types.deferredModule;
          description = ''
            The `page` module, to be assigned to `docs.pages.<name>`.
          '';
          defaultText = lib.literalMD ''
            Options derived from the outer options-page
          '';
        };
      };

      config =
        let
          cfg = config;
          drvName = lib.replaceStrings [ "/" ] [ "-" ] name;
          # Convert the doc-options list into the structure required for options.json
          # See https://github.com/NixOS/nixpkgs/blob/e2078ef3/nixos/lib/make-options-doc/default.nix#L167-L176
          optionsSet = builtins.listToAttrs (
            builtins.map (opt: {
              inherit (opt) name;
              value = builtins.removeAttrs opt [
                "name"
                "visible"
                "internal"
              ];
            }) config.optionsList
          );
        in
        {
          optionsJSON = builtins.toFile "options-${drvName}.json" (
            builtins.unsafeDiscardStringContext (builtins.toJSON optionsSet)
          );

          page =
            { config, ... }:
            {
              # TODO: should this be conditional on something?
              text = lib.mkMerge [
                # TODO: title
                # TODO: description
              ];
              # NOTE: use a _really_ high override priority because there will
              # be another definition with the same prio as `text`
              source = lib.mkIf (cfg.optionsList != [ ]) (
                lib.mkOverride 1 (
                  pkgs.callPackage ./render-page.nix {
                    inherit (config) text;
                    inherit (cfg) optionsJSON;
                    name = drvName;
                  }
                )
              );
            };
        };
    };

  optionsPageType = lib.types.submodule (
    { name, ... }:
    {
      imports = [
        optionsPageModule
      ];
      options.optionScopes = lib.mkOption {
        type = with lib.types; coercedTo optionLocType lib.singleton (nonEmptyListOf optionLocType);
        description = ''
          A list of option-locations to be included in this page.
        '';
      };
      config = {
        optionsList = optionsLists.${name} or [ ];
        page.menu.section = lib.mkDefault "options";
      };
    }
  );

  checkDocs =
    value:
    let
      duplicates = lib.pipe value [
        builtins.attrValues
        (builtins.concatMap (doc: doc.optionScopes))
        (builtins.groupBy lib.showOption)
        (lib.mapAttrs (_: builtins.length))
        (lib.filterAttrs (_: count: count > 1))
      ];
    in
    assert lib.assertMsg (duplicates == { }) ''
      `docs.options` has conflicting `optionScopes` definitions:
      ${lib.concatMapAttrsStringSep "\n" (
        name: count: "- `${name}' defined ${toString count} times"
      ) duplicates}
      Definitions:${lib.options.showDefs options.docs.options.definitionsWithLocations}
    '';
    value;
in
{
  options.docs = {
    optionPages = lib.mkOption {
      type = with lib.types; lazyAttrsOf optionsPageType;
      description = ''
        A set of option scopes to include in the docs.

        Each enabled options page will produce a corresponding `pages` page.
      '';
      default = { };
      apply = checkDocs;
    };
  };
  config.docs = {
    # Define pages for each "optionPages" attr
    pages = lib.pipe config.docs.optionPages [
      (lib.filterAttrs (_: v: v.enable))
      (builtins.mapAttrs (_: cfg: cfg.page))
    ];
  };
}
