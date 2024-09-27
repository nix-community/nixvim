{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "firenvim";

  maintainers = with lib.maintainers; [ GaetanLepage ];

  settingsOptions = {
    globalSettings = defaultNullOpts.mkAttrsOf' {
      type = types.anything;
      pluginDefault = { };
      example = {
        alt = "all";
      };
      description = "Default settings that apply to all URLs.";
    };

    localSettings = defaultNullOpts.mkAttrsOf' {
      type = with types; attrsOf anything;
      pluginDefault = { };
      example = {
        ".*" = {
          cmdline = "neovim";
          content = "text";
          priority = 0;
          selector = "textarea";
          takeover = "always";
        };
        "https?://[^/]+\\.co\\.uk/" = {
          takeover = "never";
          priority = 1;
        };
      };
      description = ''
        Map regular expressions that are tested against the full URL to settings that are used for
        all URLs matched by that pattern.

        When multiple patterns match a URL, the pattern with the highest "priority" value is used.

        Note: regular expressions use the [JavaScript flavor](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_expressions).
      '';
    };
  };

  settingsExample = {
    globalSettings.alt = "all";
    localSettings = {
      ".*" = {
        cmdline = "neovim";
        content = "text";
        priority = 0;
        selector = "textarea";
        takeover = "always";
      };
      "https?://[^/]+\\.co\\.uk/" = {
        takeover = "never";
        priority = 1;
      };
    };
  };

  settingsDescription = ''
    Options fed to the `vim.g.firenvim_config` table.
  '';

  callSetup = false;
  extraConfig =
    let
      opt = options.plugins.firenvim;
    in
    cfg: {
      warnings =
        lib.optional
          (
            config.performance.combinePlugins.enable
            && !(lib.elem "firenvim" config.performance.combinePlugins.standalonePlugins)
          )
          ''
            Nixvim (plugins.firenvim): Using `performance.combinePlugins` breaks `firenvim`.
            Add this plugin to `performance.combinePlugins.standalonePlugins` to prevent any issue.
          '';
      globals.firenvim_config = lib.modules.mkAliasAndWrapDefsWithPriority lib.id opt.settings;
    };
}
