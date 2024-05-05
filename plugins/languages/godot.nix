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
    godotPackage = mkOption {
      type = with types; nullOr package;
      default = pkgs.godot_4;
      description = ''
        Which package to use for `godot`.
        Set to `null` to prevent the installation.
      '';
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
