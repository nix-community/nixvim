{ lib }:
{
  empty = {
    plugins.dbee.enable = true;
  };

  defaults = {
    plugins.dbee = {
      enable = true;
      settings = {
        default_connection.__raw = "nil";
        sources = [
          (lib.nixvim.mkRaw "require('dbee.sources').EnvSource:new('DBEE_CONNECTIONS')")
          (lib.nixvim.mkRaw "require('dbee.sources').FileSource:new(vim.fn.stdpath('state') .. '/dbee/persistence.json')")
        ];
        extra_helpers.__empty = { };
        float_options.__empty = { };
        drawer = {
          window_options.__empty = { };
          buffer_options.__empty = { };
          disable_help = false;
          mappings = [
            {
              key = "r";
              mode = "n";
              action = "refresh";
            }
            {
              key = "<CR>";
              mode = "n";
              action = "action_1";
            }
            {
              key = "cw";
              mode = "n";
              action = "action_2";
            }
            {
              key = "dd";
              mode = "n";
              action = "action_3";
            }
            {
              key = "o";
              mode = "n";
              action = "toggle";
            }
            {
              key = "<CR>";
              mode = "n";
              action = "menu_confirm";
            }
            {
              key = "y";
              mode = "n";
              action = "menu_yank";
            }
            {
              key = "<Esc>";
              mode = "n";
              action = "menu_close";
            }
            {
              key = "q";
              mode = "n";
              action = "menu_close";
            }
          ];
          disable_candies = false;
          candies = {
            history = {
              icon = "";
              icon_highlight = "Constant";
              text_highlight = "";
            };
            note = {
              icon = "";
              icon_highlight = "Character";
              text_highlight = "";
            };
            connection = {
              icon = "󱘖";
              icon_highlight = "SpecialChar";
              text_highlight = "";
            };
            database_switch = {
              icon = "";
              icon_highlight = "Character";
              text_highlight = "";
            };
            schema = {
              icon = "";
              icon_highlight = "Removed";
              text_highlight = "";
            };
            table = {
              icon = "";
              icon_highlight = "Conditional";
              text_highlight = "";
            };
            streaming_table = {
              icon = "";
              icon_highlight = "Conditional";
              text_highlight = "";
            };
            managed = {
              icon = "";
              icon_highlight = "Conditional";
              text_highlight = "";
            };
            view = {
              icon = "";
              icon_highlight = "Debug";
              text_highlight = "";
            };
            materialized_view = {
              icon = "";
              icon_highlight = "Type";
              text_highlight = "";
            };
            sink = {
              icon = "";
              icon_highlight = "String";
              text_highlight = "";
            };
            column = {
              icon = "󰠵";
              icon_highlight = "WarningMsg";
              text_highlight = "";
            };
            add = {
              icon = "";
              icon_highlight = "String";
              text_highlight = "String";
            };
            edit = {
              icon = "󰏫";
              icon_highlight = "Directory";
              text_highlight = "Directory";
            };
            remove = {
              icon = "󰆴";
              icon_highlight = "SpellBad";
              text_highlight = "SpellBad";
            };
            help = {
              icon = "󰋖";
              icon_highlight = "Title";
              text_highlight = "Title";
            };
            source = {
              icon = "󰃖";
              icon_highlight = "MoreMsg";
              text_highlight = "MoreMsg";
            };
            none = {
              icon = " ";
              icon_highlight = "";
              text_highlight = "";
            };
            none_dir = {
              icon = "";
              icon_highlight = "NonText";
              text_highlight = "";
            };
            node_expanded = {
              icon = "";
              icon_highlight = "NonText";
              text_highlight = "";
            };
            node_closed = {
              icon = "";
              icon_highlight = "NonText";
              text_highlight = "";
            };
          };
        };
        result = {
          window_options.__empty = { };
          buffer_options.__empty = { };
          page_size = 100;
          focus_result = true;
          progress = {
            spinner = [
              "⠋"
              "⠙"
              "⠹"
              "⠸"
              "⠼"
              "⠴"
              "⠦"
              "⠧"
              "⠇"
              "⠏"
            ];
            text_prefix = "Executing...";
          };
          mappings = [
            {
              key = "L";
              mode = "";
              action = "page_next";
            }
            {
              key = "H";
              mode = "";
              action = "page_prev";
            }
            {
              key = "E";
              mode = "";
              action = "page_last";
            }
            {
              key = "F";
              mode = "";
              action = "page_first";
            }
            {
              key = "yaj";
              mode = "n";
              action = "yank_current_json";
            }
            {
              key = "yaj";
              mode = "v";
              action = "yank_selection_json";
            }
            {
              key = "yaJ";
              mode = "";
              action = "yank_all_json";
            }
            {
              key = "yac";
              mode = "n";
              action = "yank_current_csv";
            }
            {
              key = "yac";
              mode = "v";
              action = "yank_selection_csv";
            }
            {
              key = "yaC";
              mode = "";
              action = "yank_all_csv";
            }
            {
              key = "<C-c>";
              mode = "";
              action = "cancel_call";
            }
          ];
        };
        editor = {
          window_options.__empty = { };
          buffer_options.__empty = { };
          mappings = [
            {
              key = "BB";
              mode = "v";
              action = "run_selection";
            }
            {
              key = "BB";
              mode = "n";
              action = "run_file";
            }
          ];
        };
        call_log = {
          window_options.__empty = { };
          buffer_options.__empty = { };
          mappings = [
            {
              key = "<CR>";
              mode = "";
              action = "show_result";
            }
            {
              key = "<C-c>";
              mode = "";
              action = "cancel_call";
            }
          ];
          disable_candies = false;
          candies = {
            unknown = {
              icon = "";
              icon_highlight = "NonText";
              text_highlight = "";
            };
            executing = {
              icon = "󰑐";
              icon_highlight = "Constant";
              text_highlight = "Constant";
            };
            executing_failed = {
              icon = "󰑐";
              icon_highlight = "Error";
              text_highlight = "";
            };
            retrieving = {
              icon = "";
              icon_highlight = "String";
              text_highlight = "String";
            };
            retrieving_failed = {
              icon = "";
              icon_highlight = "Error";
              text_highlight = "";
            };
            archived = {
              icon = "";
              icon_highlight = "Title";
              text_highlight = "";
            };
            archive_failed = {
              icon = "";
              icon_highlight = "Error";
              text_highlight = "";
            };
            canceled = {
              icon = "";
              icon_highlight = "Error";
              text_highlight = "";
            };
          };
        };

        window_layout = lib.nixvim.mkRaw "require('dbee.layouts').Default:new()";
      };
    };
  };
}
