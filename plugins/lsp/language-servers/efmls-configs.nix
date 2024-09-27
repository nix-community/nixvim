{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
let
  tools = import ../../../generated/efmls-configs.nix;
  inherit (import ./efmls-configs-pkgs.nix lib) packaged;
in
{
  options.plugins.efmls-configs = {
    enable = lib.mkEnableOption "efmls-configs, premade configurations for efm-langserver";

    package = lib.mkPackageOption pkgs "efmls-configs-nvim" {
      default = [
        "vimPlugins"
        "efmls-configs-nvim"
      ];
    };

    efmLangServerPackage = lib.mkPackageOption pkgs "efm-langserver" {
      nullable = true;
    };

    externallyManagedPackages = lib.mkOption {
      type = with lib.types; either (enum [ "all" ]) (listOf str);
      description = ''
        Linters/Formatters to skip installing with nixvim. Set to `all` to install no packages
      '';
      default = [ ];
    };

    toolPackages = lib.pipe packaged [
      # Produce package a option for each tool
      (lib.attrsets.mapAttrs (
        name: loc:
        lib.mkPackageOption pkgs name {
          nullable = true;
          default = loc;
        }
      ))
      # Filter package defaults that are not compatible with the current platform
      (lib.attrsets.mapAttrs (
        _: opt:
        if lib.meta.availableOn pkgs.stdenv.hostPlatform opt.default then
          opt
        else
          builtins.removeAttrs opt [ "defaultText" ] // { default = null; }
      ))
    ];

    /*
      Users can set the options as follows:

      {
        c = {
          linter = "cppcheck";
          formatter = ["clang-format" "uncrustify"];
        };
        go = {
          linter = ["djlint" "golangci_lint"];
        };
      }
    */
    setup = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf lib.types.anything;

        options = lib.mapAttrs (
          _:
          lib.mapAttrs (
            kind:
            { lang, possible }:
            let
              toolType = lib.types.maybeRaw (lib.types.enum possible);
            in
            lib.mkOption {
              type = lib.types.either toolType (lib.types.listOf toolType);
              default = [ ];
              description = "${kind} tools for ${lang}";
            }
          )
        ) tools;
      };
      description = "Configuration for each filetype. Use `all` to match any filetype.";
      default = { };
    };
  };
  config =
    let
      cfg = config.plugins.efmls-configs;

      # Tools that have been selected by the user
      tools = lib.lists.unique (
        lib.filter lib.isString (
          lib.concatMap (
            {
              linter ? [ ],
              formatter ? [ ],
            }:
            (lib.toList linter) ++ (lib.toList formatter)
          ) (lib.attrValues cfg.setup)
        )
      );

      pkgsForTools =
        let
          partitionFn =
            if cfg.externallyManagedPackages == "all" then
              _: false
            else
              toolName: !(lib.elem toolName cfg.externallyManagedPackages);
          partition = lib.lists.partition partitionFn tools;
        in
        {
          nixvim = partition.right;
          external = partition.wrong;
        };

      nixvimPkgs = lib.lists.partition (v: lib.hasAttr v cfg.toolPackages) pkgsForTools.nixvim;

      mkToolValue =
        kind: opt:
        map (
          tool: if lib.isString tool then helpers.mkRaw "require 'efmls-configs.${kind}.${tool}'" else tool
        ) (lib.toList opt);

      setupOptions =
        (lib.mapAttrs (
          _:
          {
            linter ? [ ],
            formatter ? [ ],
          }:
          (mkToolValue "linters" linter) ++ (mkToolValue "formatters" formatter)
        ) (lib.attrsets.filterAttrs (v: _: v != "all") cfg.setup))
        // {
          "=" =
            (mkToolValue "linters" cfg.setup.all.linter) ++ (mkToolValue "formatters" cfg.setup.all.formatter);
        };
    in
    lib.mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      # TODO: print the location of the offending options
      warnings = lib.optional (nixvimPkgs.wrong != [ ]) ''
        Nixvim (plugins.efmls-configs): Following tools are not handled by nixvim, please add them to `externallyManagedPackages` to silence this:
        ${lib.concatMapStringsSep "\n" (tool: "  - ${tool}") nixvimPkgs.wrong}
      '';

      plugins.lsp.servers.efm = {
        enable = true;
        extraOptions.settings.languages = setupOptions;
      };

      extraPackages = [ cfg.efmLangServerPackage ] ++ (map (v: cfg.toolPackages.${v}) nixvimPkgs.right);
    };
}
