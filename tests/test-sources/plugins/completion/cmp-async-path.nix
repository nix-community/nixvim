{
  example = {
    plugins.cmp = {
      enable = true;
      settings.sources = [
        {
          name = "async_path";
          option = {
            trailing_slash = false;
            label_trailing_slash = true;
          };
        }
      ];
    };
  };
}
