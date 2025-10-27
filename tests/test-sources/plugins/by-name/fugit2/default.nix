{
  empty = {
    plugins.fugit2.enable = true;
  };

  defaults = {
    plugins.fugit2 = {
      enable = true;

      settings = {
        width = 100;
        max_width = "80%";
        min_width = 50;
        content_width = 60;
        height = "60%";
        show_patch = false;
        libgit2_path.__raw = "nil";
        gpgme_path = "gpgme";
        external_diffview = false;
        blame_priority = 1;
        blame_info_width = 60;
        blame_info_height = 10;
        colorscheme.__raw = "nil";
      };
    };
  };

  example = {
    plugins.fugit2 = {
      enable = true;

      settings = {
        width = "62%";
        height = "90%";
        external_diffview = true;
      };
    };
  };
}
