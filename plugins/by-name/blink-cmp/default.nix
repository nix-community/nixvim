{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "blink-cmp";
  packPathName = "blink.cmp";
  package = "blink-cmp";

  maintainers = [ lib.maintainers.balssh ];

  description = ''
    Performant, batteries-included completion plugin for Neovim.
  '';

  settingsOptions = import ./settings-options.nix lib;

  settingsExample = {
    keymap.preset = "super-tab";
    sources = {
      providers = {
        buffer.score_offset = -7;
        lsp.fallbacks = [ ];
      };
      cmdline = [ ];
    };
    completion = {
      accept = {
        auto_brackets = {
          enabled = true;
          semantic_token_resolution.enabled = false;
        };
      };
      documentation.auto_show = true;
    };
    appearance = {
      use_nvim_cmp_as_default = true;
      nerd_font_variant = "normal";
    };
    signature.enabled = true;
  };

  extraConfig = cfg: {
    warnings = lib.optional (cfg.settings ? documentation) ''
      Nixvim(plugins.blink): `settings.documentation` does not correspond to a known setting, use `settings.windows.documentation` instead.
    '';

    # After version 0.8.2, if we don't force the version, the plugin return an error after being loaded.
    # This happens because when we use nix to install the plugin, blink.cmp can't find the git hash or git tag that was used to build the plugin.
    plugins.blink-cmp.settings.fuzzy.prebuilt_binaries.force_version = lib.mkIf (
      builtins.compareVersions cfg.package.version "0.8.2" >= 0
    ) (lib.mkDefault "v${cfg.package.version}");
  };
}
