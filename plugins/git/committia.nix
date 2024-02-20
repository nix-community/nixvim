{
  config,
  helpers,
  pkgs,
  ...
}:
helpers.vim-plugin.mkVimPlugin config {
  name = "committia";
  originalName = "committia.vim";
  defaultPackage = pkgs.vimPlugins.committia-vim;
  globalPrefix = "committia_";
  extraPackages = [pkgs.git];

  maintainers = [helpers.maintainers.alisonjenkins];

  settingsOptions = {
    open_only_vim_starting = helpers.defaultNullOpts.mkBool true ''
      If `false`, committia.vim always attempts to open committia's buffer when `COMMIT_EDITMSG` buffer is opened.
      If you use `vim-fugitive`, I recommend to set this value to `true`.
    '';

    use_singlecolumn = helpers.defaultNullOpts.mkStr "always" ''
      If the value is 'always', `committia.vim` always employs single column mode.
    '';

    min_window_width = helpers.defaultNullOpts.mkUnsignedInt 160 ''
      If the width of window is narrower than the value, `committia.vim` employs single column mode.
    '';

    status_window_opencmd = helpers.defaultNullOpts.mkStr "belowright split" ''
      Vim command which opens a status window in multi-columns mode.
    '';

    diff_window_opencmd = helpers.defaultNullOpts.mkStr "botright vsplit" ''
      Vim command which opens a diff window in multi-columns mode.
    '';

    singlecolumn_diff_window_opencmd = helpers.defaultNullOpts.mkStr "belowright split" ''
      Vim command which opens a diff window in single-column mode.
    '';

    edit_window_width = helpers.defaultNullOpts.mkUnsignedInt 80 ''
      If `committia.vim` is in multi-columns mode, specifies the width of the edit window.
    '';

    status_window_min_height = helpers.defaultNullOpts.mkUnsignedInt 0 ''
      Minimum height of a status window.
    '';
  };
}
