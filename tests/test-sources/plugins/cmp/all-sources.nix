{ pkgs, ... }:
{
  all-sources =
    {
      config,
      options,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkMerge [
        {
          plugins.cmp = {
            enable = true;
            autoEnableSources = false;
          };

          plugins.copilot-lua = {
            enable = true;

            settings = {
              panel.enabled = false;
              suggestion.enabled = false;
            };
          };
        }
        {
          plugins =
            let
              disabledSources =
                [
                  # We do not provide the required HF_API_KEY environment variable.
                  "cmp-ai"
                  # Triggers the warning complaining about treesitter highlighting being disabled
                  "otter"
                  # Invokes the `nix` command at startup which is not available in the sandbox
                  "cmp-nixpkgs-maintainers"
                  # lspkind has its own `cmp` options, but isn't a nvim-cmp source
                  "lspkind"
                ]
                # TODO: why is this disabled?
                ++ lib.optionals (pkgs.stdenv.hostPlatform.system == "aarch64-linux") [
                  "cmp-tabnine"
                ];
              cmpPluginNames = lib.pipe options.plugins [
                # First, a manual blacklist
                (lib.flip builtins.removeAttrs disabledSources)
                # Filter for non-options (all plugins are plain attrsets, not options)
                # i.e. remove rename aliases
                (lib.filterAttrs (name: opt: !lib.isOption opt))
                # Collect the plugin names
                builtins.attrNames
                # Filter for plugins that have a `cmp` option
                (builtins.filter (name: config.plugins.${name} ? cmp))
              ];
            in
            lib.genAttrs cmpPluginNames (name: {
              enable = true;
              cmp.enable = true;
            });
        }
      ];
    };

  auto-enable-sources =
    { config, ... }:
    {
      plugins = {
        copilot-lua = {
          enable = true;

          settings = {
            panel.enabled = false;
            suggestion.enabled = false;
          };
        };

        cmp = {
          enable = true;
          settings.sources =
            with pkgs.lib;
            let
              disabledSources = [
                # We do not provide the required HF_API_KEY environment variable.
                "cmp_ai"
                # Triggers the warning complaining about treesitter highlighting being disabled
                "otter"
                # Invokes the `nix` command at startup which is not available in the sandbox
                "nixpkgs_maintainers"
              ] ++ optional (pkgs.stdenv.hostPlatform.system == "aarch64-linux") "cmp_tabnine";
            in
            pipe config.cmpSourcePlugins [
              # All known source names
              attrNames
              # Filter out disabled sources
              (filter (name: !(elem name disabledSources)))
              # Convert names to source attributes
              (map (name: {
                inherit name;
              }))
            ];
        };
      };
    };

  both-impl-used = {
    plugins = {
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings.sources = [
          { name = "cmp-emoji"; }
        ];
      };
      cmp-git = {
        enable = true;
        cmp.enable = true;
      };
    };
    test = {
      buildNixvim = false;
      warnings = expect: [
        (expect "count" 1)
        (expect "any" "Nixvim (plugins.cmp): You have enabled `autoEnableSources`")
        (expect "any" "However, 1 plugins have cmp integration configured via `plugins.*.cmp`:")
        (expect "any" "- `plugins.cmp-git`")
      ];
    };
  };
}
