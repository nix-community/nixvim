{ lib, pkgs, ... }:
{
  empty = {
    plugins.gitgutter.enable = true;
  };

  defaults = {
    plugins.gitgutter = {
      enable = true;

      settings = {
        preview_win_location = "bo";
        git_executable = "git";
        git_args = "";
        diff_args = "";
        diff_relative_to = "index";
        diff_base = "";
        grep = "grep";
        signs = true;
        highlight_lines = false;
        highlight_linenrs = false;
        max_signs = -1;
        signs_priority = 10;
        sign_allow_clobber = true;
        sign_added = "+";
        sign_modified = "~";
        sign_removed = "_";
        sign_removed_first_line = "‾";
        sign_removed_above_and_below = "_¯";
        sign_modified_removed = "~_";
        set_sign_backgrounds = false;
        preview_win_floating = true;
        floating_window_options = {
          relative = "cursor";
          row = 1;
          col = 0;
          width = 42;
          height = "&previewheight";
          style = "minimal";
        };
        close_preview_on_escape = false;
        terminal_reports_focus = true;
        enabled = true;
        map_keys = true;
        async = true;
        log = false;
        use_location_list = false;
        show_msg_on_hunk_jumping = true;
      };
    };
  };

  example = {
    plugins.gitgutter = {
      enable = true;

      settings = {
        set_sign_backgrounds = true;
        sign_modified_removed = "*";
        sign_priority = 20;
        preview_win_floating = true;
      };
    };
  };

  grep-command =
    { config, ... }:
    {
      plugins.gitgutter = {
        enable = true;
        grepPackage = pkgs.gnugrep;
      };
      assertions = [
        {
          assertion =
            config.extraPackages != [ ] && lib.any (x: x.pname or null == "gnugrep") config.extraPackages;
          message = "gnugrep wasn't found when it was expected";
        }
      ];
    };

  no-packages =
    { config, ... }:
    {
      plugins.gitgutter = {
        enable = true;
        grepPackage = null;
        settings = {
          git_executable = lib.getExe pkgs.git;
          grep = lib.getExe pkgs.gnugrep;
        };
      };

      dependencies.git.enable = false;

      assertions = [
        {
          assertion = lib.all (x: x.pname or null != "git") config.extraPackages;
          message = "A `git` package found in `extraPackages` when it wasn't expected";
        }
      ];
    };
}
