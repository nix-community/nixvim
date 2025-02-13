{
  empty = {
    plugins.bullets.enable = true;
  };

  example = {
    plugins.bullets = {
      enable = true;

      settings = {
        enabled_file_types = [
          "markdown"
          "text"
          "gitcommit"
          "scratch"
        ];
        nested_checkboxes = 0;
        enable_in_empty_buffers = 0;
      };
    };
  };
}
