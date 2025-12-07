{ lib, pkgs, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "vimtex";
  globalPrefix = "vimtex_";
  description = "A modern Vim and Neovim plugin for writing LaTeX documents.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    view_method = lib.mkOption {
      type = lib.types.str;
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

    xdotoolPackage = lib.mkPackageOption pkgs "xdotool" {
      nullable = true;
    };

    zathuraPackage = lib.mkPackageOption pkgs "zathura" {
      nullable = true;
    };

    mupdfPackage = lib.mkPackageOption pkgs "mupdf" {
      nullable = true;
    };

    pstreePackage = lib.mkPackageOption pkgs "pstree" {
      nullable = true;
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
        xdotool = lib.optional pkgs.stdenv.isLinux cfg.xdotoolPackage;
        viewerPackages =
          {
            general = xdotool;
            zathura = xdotool ++ [ cfg.zathuraPackage ];
            zathura_simple = [ cfg.zathuraPackage ];
            mupdf = xdotool ++ [ cfg.mupdfPackage ];
          }
          .${cfg.settings.view_method} or [ ];
      in
      [
        cfg.pstreePackage
        cfg.texlivePackage
      ]
      ++ viewerPackages;
  };
}
