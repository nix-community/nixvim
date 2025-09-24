{
  empty = {
    plugins.chadtree.enable = true;
  };

  example = {
    plugins = {
      web-devicons.enable = true;

      chadtree = {
        enable = true;

        settings = {
          view.window_options.relativenumber = true;
          theme = {
            icon_glyph_set = "devicons";
            text_colour_set = "nerdtree_syntax_dark";
          };
        };
      };
    };
  };

  bigExample = {
    plugins = {
      web-devicons.enable = true;
      chadtree = {
        enable = true;

        settings = {
          options = {
            follow = true;
            mimetypes = {
              warn = [
                "audio"
                "font"
                "image"
                "video"
              ];
              allowExts = [ ".ts" ];
            };
            page_increment = 5;
            polling_rate = 2.0;
            session = true;
            show_hidden = false;
            version_control = true;
            ignore = {
              name_exact = [
                ".DS_Store"
                ".directory"
                "thumbs.db"
                ".git"
              ];
              name_glob = [ ];
              path_glob = [ ];
            };
          };
          view = {
            open_direction = "left";
            sort_by = [
              "is_folder"
              "ext"
              "file_name"
            ];
            width = 40;
            window_options = {
              cursorline = true;
              number = false;
              relativenumber = false;
              signcolumn = "no";
              winfixwidth = true;
              wrap = false;
            };
          };
          theme = {
            highlights = {
              ignored = "Comment";
              bookmarks = "Title";
              quickfix = "Label";
              versionControl = "Comment";
            };
            icon_glyph_set = "devicons";
            text_colour_set = "env";
            icon_colour_set = "github";
          };
          keymap = {
            window_management = {
              quit = [ "q" ];
              bigger = [
                "+"
                "="
              ];
              smaller = [
                "-"
                "_"
              ];
              refresh = [ "<c-r>" ];
            };
            rerooting = {
              change_dir = [ "b" ];
              change_focus = [ "c" ];
              change_focus_up = [ "C" ];
            };
            open_file_folder = {
              primary = [ "<enter>" ];
              secondary = [
                "<tab>"
                "<2-leftmouse>"
              ];
              tertiary = [
                "<m-enter>"
                "<middlemouse>"
              ];
              v_split = [ "w" ];
              h_split = [ "W" ];
              open_sys = [ "o" ];
              collapse = [ "o" ];
            };
            cursor = {
              refocus = [ "~" ];
              jump_to_current = [ "J" ];
              stat = [ "K" ];
              copy_name = [ "y" ];
              copy_basename = [ "Y" ];
              copy_relname = [ "<c-y>" ];
            };
            filtering = {
              filter = [ "f" ];
              clear_filter = [ "F" ];
            };
            bookmarks = {
              bookmark_goto = [ "m" ];
            };
            selecting = {
              select = [ "s" ];
              clear_selection = [ "S" ];
            };
            file_operations = {
              new = [ "a" ];
              link = [ "A" ];
              rename = [ "r" ];
              toggle_exec = [ "X" ];
              copy = [ "p" ];
              cut = [ "x" ];
              delete = [ "d" ];
              trash = [ "t" ];
            };
            toggles = {
              toggle_hidden = [ "." ];
              toggle_follow = [ "u" ];
              toggle_version_control = [ "i" ];
            };
          };
        };
      };
    };
  };

  no-icons = {
    plugins.web-devicons.enable = false;
    plugins.chadtree = {
      enable = true;
    };
  };
}
