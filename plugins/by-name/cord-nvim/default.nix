{
  lib,
  ...
}:
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "cord-nvim";
  originalName = "cord.nvim";
  luaName = "cord";
  package = "cord-nvim";
  maintainers = [ lib.maintainers.eveeifyeve ];

  settingsOptions = {
    usercmds = lib.nixvim.defaultNullOpts.mkBool false ''
      Enables user commands
    '';

    log_level = lib.nixvim.defaultNullOpts.mkLogLevel "error" ''
      Log messages at or above this level.
    '';
  };

  settingsExample = {
    usercmds = false;
    log_level = null;
  };
}
