{
  lib,
  helpers,
  config,
  ...
}:
with lib;
let
  cfg = config.plugins.cmp;

  extractSources = { sources, ... }: if isList sources then sources else [ ];

  # Collect the names of the sources provided by the user
  # ["foo" "bar"]
  enabledSources =
    pipe
      [
        # cfg.setup.sources
        (extractSources cfg.settings)
        # cfg.filetype.<name>.sources
        (mapAttrsToList (_: extractSources) cfg.filetype)
        # cfg.cmdline.<name>.sources
        (mapAttrsToList (_: extractSources) cfg.cmdline)
      ]
      [
        flatten
        (map (getAttr "name"))
        unique
      ];
in
{
  options = {
    # Note: this option must be outside of `plugins` to avoid infinite recursion
    cmpSourcePlugins = mkOption {
      type = with types; attrsOf str;
      default = { };
      description = ''
        Internal option used to associate nvim-cmp source names with nixvim plugin module names.

        Maps `<source-name> = <plugin-name>` where _plugin-name_ is the module name: `plugins.<plugin-name>.enable`.
      '';
      example = {
        foo = "cmp-foo";
        bar = "cmp-bar";
      };
      internal = true;
      visible = false;
    };

    plugins.cmp.autoEnableSources = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = ''
        Scans the sources array and enable the corresponding plugins if they are known to nixvim.
      '';
    };
  };

  config = mkIf (cfg.enable && cfg.autoEnableSources) (mkMerge [
    {
      warnings =
        # TODO: expand this warning to ft & cmd sources lists and `showDefs` the offending definitions
        optional (lib.types.isRawType cfg.settings.sources) ''
          Nixvim (plugins.cmp): You have enabled `autoEnableSources` that tells Nixvim to automatically
          enable the source plugins with respect to the list of sources provided in `settings.sources`.
          However, the latter is proveded as a raw lua string which is not parseable by Nixvim.

          If you want to keep using raw lua for defining your sources:
          - Ensure you enable the relevant plugins manually in your configuration;
          - Dismiss this warning by explicitly setting `autoEnableSources` to `false`;
        ''
        # TODO: Added 2024-09-22; remove after 24.11
        ++ optional (elem "otter" enabledSources) ''
          Nixvim (plugins.cmp): "otter" is listed in `settings.sources`, however it is no longer a cmp source.
          Instead, you should enable `plugins.otter` and use the "cmp-nvim-lsp" completion source.
        '';

      # If the user has enabled the `foo` and `bar` sources, then `plugins` will look like:
      # {
      #   cmp-foo.enable = true;
      #   cmp-bar.enable = true;
      # }
      plugins = mapAttrs' (source: name: {
        inherit name;
        value.enable = mkIf (elem source enabledSources) true;
      }) config.cmpSourcePlugins;
    }
    {
      plugins.lsp.capabilities = mkIf (elem "nvim_lsp" enabledSources) ''
        capabilities = vim.tbl_deep_extend("force", capabilities, require('cmp_nvim_lsp').default_capabilities())
      '';
    }
  ]);
}
