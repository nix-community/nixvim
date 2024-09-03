{
  lib,
  helpers,
  pkgs,
  ...
}:
with lib;
helpers.vim-plugin.mkVimPlugin {
  name = "vimtex";
  globalPrefix = "vimtex_";

  maintainers = [ maintainers.GaetanLepage ];

  extraPackages = [ pkgs.pstree ];

  # TODO introduced 2024-02-20: remove 2024-04-20
  deprecateExtraConfig = true;
  optionsRenamedToSettings = [ "viewMethod" ];
  imports =
    let
      basePluginPath = [
        "plugins"
        "vimtex"
      ];
    in
    [
      (mkRemovedOptionModule (
        basePluginPath ++ [ "installTexLive" ]
      ) "If you don't want `texlive` to be installed, set `plugins.vimtex.texlivePackage` to `null`.")
      (mkRenamedOptionModule (basePluginPath ++ [ "texLivePackage" ]) (
        basePluginPath ++ [ "texlivePackage" ]
      ))
    ];

  settingsOptions = {
    view_method = mkOption {
      type = types.str;
      default = "general";
      example = "zathura";
      description = ''
        Set the viewer method.
        By default, a generic viewer is used through the general view method (e.g. `xdg-open` on Linux).
      '';
    };
  };

  settingsExample = {
    view_method = "zathura";
    compiler_method = "latexrun";
    toc_config = {
      split_pos = "vert topleft";
      split_width = 40;
    };
  };

  extraOptions = {
    texlivePackage = lib.mkPackageOption pkgs "texlive" {
      nullable = true;
      default = [
        "texlive"
        "combined"
        "scheme-medium"
      ];
    };
  };

  extraConfig = cfg: {
    plugins.vimtex.settings = {
      enabled = true;
      callback_progpath = "nvim";
    };

    extraPackages =
      let
        # xdotool does not exist on darwin
        xdotool = optional pkgs.stdenv.isLinux pkgs.xdotool;
        viewerPackages =
          {
            general = xdotool;
            zathura = xdotool ++ [ pkgs.zathura ];
            zathura_simple = [ pkgs.zathura ];
            mupdf = xdotool ++ [ pkgs.mupdf ];
          }
          .${cfg.settings.view_method} or [ ];
      in
      [ cfg.texlivePackage ] ++ viewerPackages;
  };
}
