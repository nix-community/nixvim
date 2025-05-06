{
  # empty test case is not needed since having it would make the warning throw an error
  combine-plugins = {
    performance.combinePlugins.enable = true;
    plugins.oil = {
      enable = true;
      settings = {
        win_options = {
          signcolumn = "yes:2,";
        };
      };
    };
    plugins.oil-git-status = {
      enable = true;
      settings = {
        show_ignored = false;
      };
    };
  };

  with-oil = {
    # set settings.win_options.signcolumn since oil-git-status relies on that particular setting in order to function
    plugins.oil = {
      enable = true;
      settings = {
        win_options = {
          signcolumn = "yes:2,";
        };
      };
    };
    plugins.oil-git-status.enable = true;
  };

}
