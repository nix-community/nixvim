{
  default = {
    plugins.showkeys.enable = true;
  };

  example = {
    plugins.showkeys = {
      enable = true;
      settings = {
        timeout = 5;
        position = "bottom-center";
        keyformat."<CR>" = "Enter";
      };
    };
  };
}
