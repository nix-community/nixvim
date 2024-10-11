{
  lib,
  helpers,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin {
  name = "cord-nvim";
  originalName = "cord.nvim";
  package = "cord-nvim";
  maintainers = [ ];

  settingsOptions = {
    usercmds = helpers.defaultNullOpts.mkBool false ''
      	Enables user commands
    '';
    log_level =
      helpers.defaultNullOpts.mkEnum
        [
          "trace"
          "debug"
          "info"
          "warn"
          "off"
        ]
        null
        ''
          	Log messages at or above this level.
        '';
  };

  settingsExample = {
    usercmds = false;
    log_level = null;
  };
}
