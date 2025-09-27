{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "blink-cmp";
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

  extraOptions = {
    setupLspCapabilities = lib.nixvim.options.mkEnabledOption "LSP capabilities for blink-cmp";
  };

  extraConfig = cfg: {
    # TODO: On Neovim 0.11+ and Blink.cmp 0.10+ with vim.lsp.config, you may skip this step.
    # This is still required when using nvim-lspconfig, until this issue is completed:
    # https://github.com/neovim/nvim-lspconfig/issues/3494
    plugins.lsp.capabilities =
      lib.mkIf cfg.setupLspCapabilities # lua
        ''
          -- Capabilities configuration for blink-cmp
          capabilities = require("blink-cmp").get_lsp_capabilities(capabilities)
        '';
  };
}
