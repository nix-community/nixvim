{
  lib,
	helpers,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "cord-nvim";
  packPathName = "cord.nvim";
  moduleName = "cord";
  package = "cord-nvim";
  maintainers = [ lib.maintainers.eveeifyeve ];

  settingsOptions = {
    usercmds = defaultNullOpts.mkBool false ''
      Enables user commands
    '';

    log_level = lib.nixvim.defaultNullOpts.mkLogLevel "error" ''
      Log messages at or above this level.
    '';

		buttons = defaultNullOpts.mkListOf (
			with types;
			submodule {
				options = {
					label = helpers.mkNullOrStr "";
					url = helpers.mkNullOrStr "";
				};
			}
		)
		[ ]
		''
			
		'';

  };

  settingsExample = {
    usercmds = false;
    log_level = null;
  };
}
