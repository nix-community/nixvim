{
  empty = {
    plugins.img-clip.enable = true;
  };

  example = {
    plugins.img-clip = {
      enable = true;
      settings = {
        default = {
          dir_path = "assets";
          file_name = "%y-%m-%d-%h-%m-%s";
          use_absolute_path = false;
          relative_to_current_file = false;
          template = "$file_path";
        };
        filetypes = {
          markdown = {
            download_images = true;
          };
        };
      };
    };
  };
}
