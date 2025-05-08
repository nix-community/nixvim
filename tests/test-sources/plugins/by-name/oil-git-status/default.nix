{
  # empty test case is not needed since having it would make the warning throw an error
  combine-plugins = {
    performance.combinePlugins.enable = true;
    plugins.oil = {
      enable = true;
      settings = {
        win_options = {
          signcolumn = "yes:2";
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
          signcolumn = "yes:2";
        };
      };
    };
    plugins.oil-git-status.enable = true;
  };

  bad-signcolumn_yes = {
    test.buildNixvim = false;
    test.warnings = expect: [
      (expect "count" 1)
      (expect "any" "Nixvim (plugins.oil-git-status): This plugin requires `plugins.oil` is configured to allow at least 2 sign columns.")
      (expect "any" "`plugins.oil.settings.win_options.signcolumn` is currently set to \"yes\".")
    ];

    plugins.oil = {
      enable = true;
      # Should trigger the warning
      settings.win_options.signcolumn = "yes";
    };
    plugins.oil-git-status.enable = true;
  };
}
