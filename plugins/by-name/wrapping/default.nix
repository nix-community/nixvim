{
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "wrapping";
  originalName = "wrapping.nvim";
  package = "wrapping-nvim";

  maintainers = [ lib.maintainers.ZainKergaye ];

  settingsOptions = {
    notify_on_switch = defaultNullOpts.mkBool true ''
      By default, wrapping.nvim will output a message to the
      command line when the hard or soft mode is set.
    '';
  };

  settingsExample = {
    notify_on_switch = false;
  };
}
