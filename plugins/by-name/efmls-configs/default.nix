{
  lib,
  config,
  options,
  pkgs,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "efmls-configs";
  package = "efmls-configs-nvim";
  description = "Premade configurations for efm-langserver.";
  maintainers = [ ];

  dependencies = [
    "efm-langserver"
  ];
  imports = [
    # TODO: added 2025-10-23, remove after 26.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "efmls-configs";
      oldPackageName = "efmLangServer";
      packageName = "efm-langserver";
    })

    (
      let
        basePluginPath = [
          "plugins"
          "efmls-configs"
        ];
      in
      lib.mkRenamedOptionModule (basePluginPath ++ [ "setup" ]) (basePluginPath ++ [ "languages" ])
    )

    # Propagate setup warnings
    { inherit (config.plugins.efmls-configs.languages) warnings; }
  ];

  hasSettings = false;
  callSetup = false;

  extraOptions =
    let
      inherit (import ./packages.nix lib) packaged;
      tools = lib.importJSON ../../../generated/efmls-configs-sources.json;
    in
    {
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
          opt
          // {
            default = if lib.meta.availableOn pkgs.stdenv.hostPlatform opt.default then opt.default else null;
            defaultText = lib.literalMD ''
              `${opt.defaultText.text}` if available on the current system, otherwise null
            '';
          }
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
      languages = lib.mkOption {
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

          # Added 2025-06-25 in https://github.com/nix-community/nixvim/pull/3503
          imports =
            map (name: lib.mkRenamedOptionModule [ name ] [ (lib.toLower name) ]) [
              "HTML"
              "JSON"
            ]
            ++ lib.singleton {
              # NOTE: we need a warnings option for `mkRenamedOptionModule` to warn about unexpected definitions
              # This can be removed when all rename aliases are gone
              options.warnings = lib.mkOption {
                type = with lib.types; listOf str;
                description = "Warnings to propagate to nixvim's `warnings` option.";
                default = [ ];
                internal = true;
                visible = false;
              };
            };
        };
        description = ''
          Configuration for each filetype. Use `all` to match any filetype.

          This option is used to populate `${options.lsp.servers}.efm.config.settings.languages`.
        '';
        default = { };
      };
    };

  extraConfig =
    cfg:
    let
      # Tools that have been selected by the user
      tools = lib.lists.unique (
        lib.filter lib.isString (
          lib.concatMap
            (
              {
                linter ? [ ],
                formatter ? [ ],
              }:
              (lib.toList linter) ++ (lib.toList formatter)
            )
            (
              lib.attrValues (
                # Rename aliases added 2025-06-25 in https://github.com/nix-community/nixvim/pull/3503
                removeAttrs cfg.languages [
                  "warnings"
                  "HTML"
                  "JSON"
                ]
              )
            )
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
          tool: if lib.isString tool then lib.nixvim.mkRaw "require 'efmls-configs.${kind}.${tool}'" else tool
        ) (lib.toList opt);
    in
    {
      # TODO: print the location of the offending options
      warnings = lib.nixvim.mkWarnings "plugins.efmls-configs" {
        when = nixvimPkgs.wrong != [ ];

        message = ''
          Following tools are not handled by nixvim, please add them to `externallyManagedPackages` to silence this:
          ${lib.concatMapStringsSep "\n" (tool: "  - ${tool}") nixvimPkgs.wrong}
        '';
      };

      lsp.servers.efm = {
        enable = true;
        config.settings.languages =
          (lib.mapAttrs
            (
              _:
              {
                linter ? [ ],
                formatter ? [ ],
              }:
              (mkToolValue "linters" linter) ++ (mkToolValue "formatters" formatter)
            )
            (
              removeAttrs cfg.languages [
                "all"
                # Rename aliases added 2025-06-25 in https://github.com/nix-community/nixvim/pull/3503
                "warnings"
                "HTML"
                "JSON"
              ]
            )
          )
          // {
            "=" =
              (mkToolValue "linters" cfg.languages.all.linter)
              ++ (mkToolValue "formatters" cfg.languages.all.formatter);
          };
      };

      extraPackages = map (name: cfg.toolPackages.${name}) nixvimPkgs.right;
    };
}
