{
  example = {
    plugins = {
      cmp.enable = true;
      cmp-async-path = {
        enable = true;
        cmp.default = {
          option = {
            label_trailing_slash = true;
            trailing_slash = false;
          };
        };
      };
    };
  };
}
