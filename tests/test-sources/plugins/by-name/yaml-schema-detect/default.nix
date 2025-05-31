{
  empty = {
    plugins.yaml-schema-detect.enable = true;
  };

  default = {
    plugins.yaml-schema-detect = {
      enable = true;

      settings = {
        disable_keymaps = false;
        keymaps = {
          refresh = "<leader>xr";
          cleanup = "<leader>xyc";
          info = "<leader>xyi";
        };
      };
    };
  };
}
