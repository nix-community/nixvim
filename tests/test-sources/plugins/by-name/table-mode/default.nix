{
  empty = {
    plugins.table-mode.enable = true;
  };

  example = {
    plugins.table-mode = {
      enable = true;
      settings = {
        auto_align = true;
        always_active = false;
        disable_mappings = false;
        delimiter = ",";
      };
    };
  };
}
