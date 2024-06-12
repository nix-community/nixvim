{
  config,
  lib,
  helpers,
  pkgs,
  ...
}:
with lib;
helpers.vim-plugin.mkVimPlugin config {
  name = "godot";
  originalName = "vim-godot";
  defaultPackage = pkgs.vimPlugins.vim-godot;
  globalPrefix = "godot_";

  maintainers = [ maintainers.GaetanLepage ];

  extraOptions = {
    godotPackage = helpers.mkPackageOption {
      name = "godot";
      default = pkgs.godot_4;
    };
  };

  settingsOptions = {
    executable = helpers.defaultNullOpts.mkStr "godot" ''
      Path to the `godot` executable.
    '';
  };

  settingsExample = {
    executable = "godot";
  };

  extraConfig = cfg: { extraPackages = [ cfg.godotPackage ]; };
}
