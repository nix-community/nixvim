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

  withAllDependencies = {
    plugins = {
      telescope = {
        enable = true;

        extensions.media-files.enable = true;
      };
      web-devicons.enable = true;
    };

    dependencies = {
      chafa.enable = true;
      epub-thumbnailer.enable = true;
      ffmpegthumbnailer.enable = true;
      fontpreview.enable = true;
      imagemagick.enable = true;
      poppler-utils.enable = true;
    };
  };
}
