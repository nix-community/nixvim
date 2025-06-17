{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "peek";
  packPathName = "peek.nvim";
  package = "peek-nvim";
  description = "Markdown preview plugin for Neovim.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    auto_load = false;
    close_on_bdelete = false;
    app = "google-chrome-stable";
  };

  extraOptions = {
    createUserCommands = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = ''
        Whether to create the `PeekOpen` and `PeekClose` user commands.
      '';
    };
  };

  extraConfig = cfg: {
    plugins.peek.luaConfig.post = lib.mkIf cfg.createUserCommands ''
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    '';
  };
}
