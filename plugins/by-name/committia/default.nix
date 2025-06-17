{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkVimPlugin {
  name = "committia";
  packPathName = "committia.vim";
  package = "committia-vim";
  globalPrefix = "committia_";
  description = "A Vim plugin for more pleasant editing on commit messages.";

  maintainers = [ lib.maintainers.alisonjenkins ];

  dependencies = [ "git" ];

  imports = [
    # TODO: added 2025-04-06, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "committia";
      packageName = "git";
    })
  ];

  settingsOptions = {
    open_only_vim_starting = defaultNullOpts.mkFlagInt 1 ''
      If `0`, committia.vim always attempts to open committia's buffer when `COMMIT_EDITMSG` buffer is opened.
      If you use `vim-fugitive`, I recommend to set this value to `1`.
    '';

    use_singlecolumn = defaultNullOpts.mkStr "always" ''
      If the value is 'always', `committia.vim` always employs single column mode.
    '';

    min_window_width = defaultNullOpts.mkUnsignedInt 160 ''
      If the width of window is narrower than the value, `committia.vim` employs single column mode.
    '';

    status_window_opencmd = defaultNullOpts.mkStr "belowright split" ''
      Vim command which opens a status window in multi-columns mode.
    '';

    diff_window_opencmd = defaultNullOpts.mkStr "botright vsplit" ''
      Vim command which opens a diff window in multi-columns mode.
    '';

    singlecolumn_diff_window_opencmd = defaultNullOpts.mkStr "belowright split" ''
      Vim command which opens a diff window in single-column mode.
    '';

    edit_window_width = defaultNullOpts.mkUnsignedInt 80 ''
      If `committia.vim` is in multi-columns mode, specifies the width of the edit window.
    '';

    status_window_min_height = defaultNullOpts.mkUnsignedInt 0 ''
      Minimum height of a status window.
    '';
  };
}
