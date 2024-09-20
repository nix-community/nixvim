{ pkgs, ... }:
{
  empty = {
    plugins.telescope = {
      enable = true;
      extensions.media-files.enable = true;
    };
    plugins.web-devicons.enable = true;
  };

  defaults = {
    plugins.telescope = {
      enable = true;

      extensions.media-files = {
        enable = true;

        settings = {
          filetypes = [
            "png"
            "jpg"
            "gif"
            "mp4"
            "webm"
            "pdf"
          ];

          find_cmd = "fd";
        };
      };
    };
    plugins.web-devicons.enable = true;
  };

  dependencies = {
    plugins.telescope = {
      enable = true;

      extensions.media-files = {
        enable = true;

        dependencies = {
          chafa.enable = true;
          imageMagick.enable = true;
          ffmpegthumbnailer.enable = true;
          pdftoppm.enable = true;
          epub-thumbnailer.enable = pkgs.stdenv.isLinux;
          fontpreview.enable = pkgs.stdenv.isLinux;
        };
      };
    };
    plugins.web-devicons.enable = true;
  };
}
