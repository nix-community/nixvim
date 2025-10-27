{
  empty = {
    plugins.overseer.enable = true;
  };

  default = {
    plugins.overseer = {
      settings = {
        strategy = "terminal";
        templates = [ "builtin" ];
        auto_detect_success_color = true;
        dap = true;
        task_list = {
          default_detail = 1;
          max_width = [
            100
            0.2
          ];
          min_width = [
            40
            0.1
          ];
          width.__raw = "nil";
          max_height = [
            20
            0.1
          ];
          min_height = 8;
          height.__raw = "nil";
          separator = "────────────────────────────────────────";
          direction = "bottom";
          bindings = {
            "?" = "ShowHelp";
            "g?" = "ShowHelp";
            "<CR>" = "RunAction";
            "<C-e>" = "Edit";
            "o" = "Open";
            "<C-v>" = "OpenVsplit";
            "<C-s>" = "OpenSplit";
            "<C-f>" = "OpenFloat";
            "<C-q>" = "OpenQuickFix";
            "p" = "TogglePreview";
            "<C-l>" = "IncreaseDetail";
            "<C-h>" = "DecreaseDetail";
            "L" = "IncreaseAllDetail";
            "H" = "DecreaseAllDetail";
            "[" = "DecreaseWidth";
            "]" = "IncreaseWidth";
            "{" = "PrevTask";
            "}" = "NextTask";
            "<C-k>" = "ScrollOutputUp";
            "<C-j>" = "ScrollOutputDown";
            "q" = "Close";
          };
        };
        actions.__empty = { };
        form = {
          border = "rounded";
          zindex = 40;
          min_width = 80;
          max_width = 0.9;
          width.__raw = "nil";
          min_height = 10;
          max_height = 0.9;
          height.__raw = "nil";
          win_opts = {
            winblend = 0;
          };
        };
        task_launcher = {
          bindings = {
            i = {
              "<C-s>" = "Submit";
              "<C-c>" = "Cancel";
            };
            n = {
              "<CR>" = "Submit";
              "<C-s>" = "Submit";
              "q" = "Cancel";
              "?" = "ShowHelp";
            };
          };
        };
        task_editor = {
          bindings = {
            i = {
              "<CR>" = "NextOrSubmit";
              "<C-s>" = "Submit";
              "<Tab>" = "Next";
              "<S-Tab>" = "Prev";
              "<C-c>" = "Cancel";
            };
            n = {
              "<CR>" = "NextOrSubmit";
              "<C-s>" = "Submit";
              "<Tab>" = "Next";
              "<S-Tab>" = "Prev";
              "q" = "Cancel";
              "?" = "ShowHelp";
            };
          };
        };
        confirm = {
          border = "rounded";
          zindex = 40;
          min_width = 20;
          max_width = 0.5;
          width.__raw = "nil";
          min_height = 6;
          max_height = 0.9;
          height.__raw = "nil";
          win_opts = {
            winblend = 0;
          };
        };
        task_win = {
          padding = 2;
          border = "rounded";
          win_opts = {
            winblend = 0;
          };
        };
        help_win = {
          border = "rounded";
          win_opts.__empty = { };
        };
        component_aliases = {
          default = [
            {
              __unkeyed-1 = "display_duration";
              detail_level = 2;
            }
            "on_output_summarize"
            "on_exit_set_status"
            "on_complete_notify"
            {
              __unkeyed-2 = "on_complete_dispose";
              require_view = [
                "SUCCESS"
                "FAILURE"
              ];
            }
          ];
          default_vscode = [
            "default"
            "on_result_diagnostics"
          ];
        };
        bundles = {
          save_task_opts = {
            bundleable = true;
          };
          autostart_on_load = true;
        };
        preload_components.__empty = { };
        default_template_prompt = "allow";
        template_timeout = 3000;
        template_cache_threshold = 100;
      };
    };
  };

  keymaps = {
    plugins.overseer = {
      enable = true;
      settings = {
        task_launcher = {
          "<C-s>" = false;
          "<C-m>" = {
            action = "<cmd>make<CR>";
            options.silent = true;
          };
        };
      };
    };
  };

  example = {
    plugins.overseer = {
      enable = true;

      settings = {
        strategy = {
          __unkeyed-1 = "toggleterm";
          use_shell = false;
          close_on_exit = false;
          quit_on_exit = "never";
          open_on_start = true;
          hidden = false;
        };
      };
    };
  };
}
