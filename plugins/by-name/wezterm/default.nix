{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "wezterm";
  originalName = "wezterm.nvim";
  package = "wezterm-nvim";

  maintainers = [ lib.maintainers.samos667 ];

  extraOptions = {
    weztermPackage = lib.mkPackageOption pkgs "wezterm" {
      nullable = true;
      default = null;
      example = [ "wezterm" ];
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
