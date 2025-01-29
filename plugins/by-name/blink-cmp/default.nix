{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "blink-cmp";
  packPathName = "blink.cmp";
  package = "blink-cmp";

  maintainers = with lib.maintainers; [
    balssh
    khaneliman
  ];

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
    warnings = lib.nixvim.mkWarnings "plugins.blink" {
      when = cfg.settings ? documentation;
      message = ''
        `settings.documentation` does not correspond to a known setting, use `settings.windows.documentation` instead.
      '';
    };
  };
}
