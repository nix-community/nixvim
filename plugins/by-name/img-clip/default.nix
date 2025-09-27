{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "img-clip";
  package = "img-clip-nvim";
  description = "Embed images into any markup language, like LaTeX, Markdown or Typst";
  maintainers = [ lib.maintainers.saygo-png ];

  settingsExample = {
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
}
