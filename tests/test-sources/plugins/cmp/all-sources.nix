{
  all-sources =
    {
      config,
      options,
      lib,
      pkgs,
      ...
    }:
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
    in
    {
      config = lib.mkMerge [
        {
          plugins.cmp = {
            enable = true;
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
          plugins = lib.pipe options.plugins [
            # First, a manual blacklist
            (lib.flip builtins.removeAttrs disabledSources)
            # Filter for non-options (all plugins are plain attrsets, not options)
            # i.e. remove rename aliases
            (lib.filterAttrs (name: opt: !lib.isOption opt))
            # Collect the plugin names
            builtins.attrNames
            # Filter for plugins that have a `cmp` option
            (builtins.filter (name: config.plugins.${name} ? cmp))
            (lib.flip lib.genAttrs (name: {
              enable = true;
              cmp.enable = true;
            }))
          ];
        }
      ];
    };

  bad-source-defs = {
    plugins = {
      cmp = {
        enable = true;
        settings.sources = [
          { name = "emoji"; }
        ];
      };
      cmp-git.enable = true;
    };
    test = {
      buildNixvim = false;
      warnings = expect: [
        (expect "count" 1)
        (expect "any" "Nixvim (plugins.cmp-emoji): The \"emoji\" nvim-cmp source has been defined via `plugins.cmp`, howevew `plugins.cmp-emoji.enable` is not enabled.")
        (expect "any" "1. Manually enable `plugins.cmp-emoji.enable`")
        (expect "any" "2. Remove \"emoji\" from: plugins.cmp.settings.sources")
        (expect "any" "3. Instead define: plugins.cmp-emoji.cmp.default = true;")
        (expect "any" "You can suppress this warning by explicitly setting `plugins.cmp-emoji.enable = false`.")
      ];
    };
  };
}
