{
  lib,
  config,
  options,
  pkgs,
  ...
}:
let
  inherit (config.docs._utils)
    docsPageModule
    mkOptionList
    ;

  # Gets the page that owns this option.
  # We can use `findFirst` because `pageScopes` is a sorted list.
  getPageFor =
    loc: (lib.findFirst (pair: lib.lists.hasPrefix pair.scope loc) null pageScopePairs).page or null;

  optionsLists = builtins.groupBy (opt: getPageFor opt.loc) (mkOptionList options);

  # A list of { page, scope } pairs, sorted by scope length (longest first)
  pageScopePairs = lib.pipe config.docs.options [
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
      imports = [
        docsPageModule
      ];
      options = {
        enable = lib.mkOption {
          defaultText = lib.literalExpression ''required || optionsList != [ ]'';
        };
        title = lib.mkOption {
          type = lib.types.str;
          description = ''
            The page title. Also used as text for the menu item link.
          '';
          default = lib.last config.menu.location;
          defaultText = lib.literalMD "The last element in `menu.location`";
        };
        description = lib.mkOption {
          type = lib.types.lines;
          description = ''
            An optional description included at the start of the index page.
          '';
          default = "";
        };
        required = lib.mkOption {
          type = lib.types.bool;
          description = "Whether a page should be rendered, even when there are no visible options.";
          default = config.description != "";
          defaultText = lib.literalMD ''
            true when `description` is not empty
          '';
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
      };

      config =
        let
          drvName = lib.replaceStrings [ "/" ] [ "-" ] name;
          markdown = pkgs.callPackage ./render-page.nix {
            inherit (config) title description optionsJSON;
            name = drvName;
          };
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
          enable = lib.mkDefault (config.required || config.optionsList != [ ]);
          source = if config.required || config.optionsList != [ ] then markdown else null;
          optionsJSON = builtins.toFile "options-${drvName}.json" (
            builtins.unsafeDiscardStringContext (builtins.toJSON optionsSet)
          );
        };
    };

  optionsPageType = lib.types.submodule (
    { name, ... }:
    {
      imports = [
        optionsPageModule
      ];
      options = {
        optionScopes = lib.mkOption {
          type = with lib.types; coercedTo optionLocType lib.singleton (nonEmptyListOf optionLocType);
          description = ''
            A list of option-locations to be included in this page.
          '';
        };
        menu.section = lib.mkOption {
          default = "options";
        };
      };
      config.optionsList = optionsLists.${name} or [ ];
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
    options = lib.mkOption {
      type = with lib.types; lazyAttrsOf optionsPageType;
      description = ''
        A set of option scopes to include in the docs.
      '';
      default = { };
      apply = checkDocs;
    };
  };
  config.docs = {
    # Register for inclusion in `all`
    _allInputs = [ "options" ];
    _utils = {
      inherit optionsPageModule;
    };
  };
}
