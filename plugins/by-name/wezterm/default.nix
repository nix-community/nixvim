{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.neovim.mkNeovimPlugin {
  name = "wezterm";
  packPathName = "wezterm.nvim";
  package = "wezterm-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  extraOptions = {
    weztermPackage = lib.mkPackageOption pkgs "wezterm" {
      nullable = true;
    };
  };

  settingsOptions = {
    create_commands = defaultNullOpts.mkBool true ''
      Whether to create plugin commands.
    '';
  };

  settingsExample = {
    create_commands = false;
  };

  extraConfig = cfg: {
    extraPackages = [
      cfg.weztermPackage
    ];
  };
}
