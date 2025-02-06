{
  lib,
  config,
  options,
  ...
}:
let
  cfg = config.plugins.cmp;

  extractSources = { sources, ... }: if lib.isList sources then sources else [ ];

  # Collect the names of the sources provided by the user
  # ["foo" "bar"]
  enabledSources =
    lib.pipe
      [
        # cfg.setup.sources
        (extractSources cfg.settings)
        # cfg.filetype.<name>.sources
        (lib.mapAttrsToList (_: extractSources) cfg.filetype)
        # cfg.cmdline.<name>.sources
        (lib.mapAttrsToList (_: extractSources) cfg.cmdline)
      ]
      [
        lib.flatten
        (map (lib.getAttr "name"))
        lib.unique
      ];

  newStylePlugins = lib.pipe options.plugins [
    # First, a manual blacklist
    (lib.flip builtins.removeAttrs [
      # lspkind has its own `cmp` options, but isn't a nvim-cmp source
      "lspkind"
    ])
    builtins.attrValues
    # Filter for non-options (all plugins are plain attrsets, not options)
    # i.e. remove rename aliases
    (builtins.filter (opt: !lib.isOption opt))
    # Filter for plugins that have `cmp` enabled
    (builtins.filter (opt: opt.cmp.enable.value or false))
    # Collect the enable options' `loc`s
    (builtins.catAttrs "enable")
    (builtins.catAttrs "loc")
    # Drop the `"enable"` part of the option-loc
    (builtins.map (lib.lists.dropEnd 1))
    # Render each plugin loc as an option string
    (builtins.map lib.showOption)
  ];
in
{
  options = {
    # Note: this option must be outside of `plugins` to avoid infinite recursion
    cmpSourcePlugins = lib.mkOption {
      type = with lib.types; attrsOf str;
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

    plugins.cmp.autoEnableSources = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = ''
        Scans the sources array and enable the corresponding plugins if they are known to nixvim.
      '';
    };
  };

  config = lib.mkMerge (
    [
      (lib.mkIf (cfg.enable && cfg.autoEnableSources && newStylePlugins != [ ]) {
        # Warn when the new and old systems are used together.
        # `autoEnableSources` is incompatible with the new `plugins.*.cmp` options
        # TODO:
        # - Have `autoEnableSources` default to no `plugins.*.cmp` options being enabled?
        # - Maybe warn when `autoEnableSources` has highestPrio 1500?
        # - I'm not sure how best to migrate to having `plugins.*.cmp.enable` default to true...
        warnings = lib.nixvim.mkWarnings "plugins.cmp" ''
          You have enabled `autoEnableSources` that tells Nixvim to automatically enable the source plugins with respect to the list of sources provided in `settings.sources`.
          However, ${builtins.toString (builtins.length newStylePlugins)} plugins have cmp integration configured via `plugins.*.cmp`:${
            lib.concatMapStrings (opt: "\n- `${opt}`") newStylePlugins
          }
        '';
      })
      (lib.mkIf (cfg.enable && cfg.autoEnableSources) {
        warnings = lib.nixvim.mkWarnings "plugins.cmp" [
          # TODO: expand this warning to ft & cmd sources lists and `showDefs` the offending definitions
          {
            when = lib.types.isRawType cfg.settings.sources;
            message = ''
              You have enabled `autoEnableSources` that tells Nixvim to automatically
              enable the source plugins with respect to the list of sources provided in `settings.sources`.
              However, the latter is proveded as a raw lua string which is not parseable by Nixvim.

              If you want to keep using raw lua for defining your sources:
              - Ensure you enable the relevant plugins manually in your configuration;
              - Dismiss this warning by explicitly setting `autoEnableSources` to `false`;
            '';
          }
          # TODO: Added 2024-09-22; remove after 24.11
          {
            when = lib.elem "otter" enabledSources;
            message = ''
              "otter" is listed in `settings.sources`, however it is no longer a cmp source.
              Instead, you should enable `plugins.otter` and use the "cmp-nvim-lsp" completion source.
            '';
          }
        ];

        plugins.lsp.capabilities = lib.mkIf (lib.elem "nvim_lsp" enabledSources) ''
          capabilities = vim.tbl_deep_extend("force", capabilities, require('cmp_nvim_lsp').default_capabilities())
        '';
      })
    ]
    # If the user has enabled the `foo` and `bar` sources, then `plugins` will look like:
    # {
    #   cmp-foo.enable = true;
    #   cmp-bar.enable = true;
    # }
    #
    # To avoid inf-rec, we have to define _all_ declared plugins,
    # outside of any conditional that depends on config.plugins.
    # We can use mkIf _within_ definitions though.
    ++ lib.pipe options.plugins [
      (lib.flip builtins.removeAttrs [
        # lspkind has its own `cmp` options, but isn't a nvim-cmp source
        "lspkind"
      ])
      # Actual options are probably aliases, not plugins
      (lib.filterAttrs (_: opt: !lib.isOption opt))
      (lib.filterAttrs (_: opt: opt ? cmp))
      builtins.attrNames
      (builtins.map (
        name:
        let
          inherit (config.plugins.${name}) cmp;
        in
        lib.mkIf (
          cfg.enable
          && cfg.autoEnableSources
          # Avoid inf-rec by not auto-enabling sources that add themselves to sources
          && !cmp.enable or false
          && builtins.elem cmp.name enabledSources
        ) { plugins.${name}.enable = true; }
      ))
    ]
  );
}
