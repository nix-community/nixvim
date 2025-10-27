{
  empty = {
    plugins.web-devicons.enable = true;
    plugins.trouble.enable = true;
  };

  lsp = {
    plugins.web-devicons.enable = true;
    plugins.lsp = {
      enable = true;
      servers.clangd.enable = true;
    };

    plugins.trouble.enable = true;
  };

  defaults = {
    plugins.web-devicons.enable = true;
    plugins.trouble = {
      enable = true;

      settings = {
        debug = false;
        auto_close = false;
        auto_open = false;
        auto_preview = true;
        auto_refresh = true;
        auto_jump = false;
        focus = false;
        restore = true;
        follow = true;
        indent_guides = true;
        max_items = 200;
        multiline = true;
        pinned = false;
        warn_no_results = true;
        open_no_results = false;
        win.__empty = { };
        preview = {
          type = "main";
          scratch = true;
        };
        throttle = {
          refresh = 20;
          update = 10;
          render = 10;
          follow = 100;
          preview = {
            ms = 100;
            debounce = true;
          };
        };
        keys = {
          "?" = "help";
          r = "refresh";
          R = "toggle_refresh";
          q = "close";
          o = "jump_close";
          "<esc>" = "cancel";
          "<cr>" = "jump";
          "<2-leftmouse>" = "jump";
          "<c-s>" = "jump_split";
          "<c-v>" = "jump_vsplit";
          "}" = "next";
          "]]" = "next";
          "{" = "prev";
          "[[" = "prev";
          dd = "delete";
          d = {
            action = "delete";
            mode = "v";
          };
          i = "inspect";
          p = "preview";
          P = "toggle_preview";
          zo = "fold_open";
          zO = "fold_open_recursive";
          zc = "fold_close";
          zC = "fold_close_recursive";
          za = "fold_toggle";
          zA = "fold_toggle_recursive";
          zm = "fold_more";
          zM = "fold_close_all";
          zr = "fold_reduce";
          zR = "fold_open_all";
          zx = "fold_update";
          zX = "fold_update_all";
          zn = "fold_disable";
          zN = "fold_enable";
          zi = "fold_toggle_enable";
          gb = {
            action.__raw = ''
              function(view)
                view:filter({ buf = 0 }, { toggle = true })
              end
            '';
            desc = "Toggle Current Buffer Filter";
          };
          s = {
            action.__raw = ''
              function(view)
                 local f = view:get_filter("severity")
                 local severity = ((f and f.filter.severity or 0) + 1) % 5
                 view:filter({ severity = severity }, {
                   id = "severity",
                   template = "{hl:Title}Filter:{hl} {severity}",
                   del = severity == 0,
                 })
              end
            '';
            desc = "Toggle Severity Filter";
          };
        };
        modes = {
          lsp_references = {
            params = {
              include_declaration = true;
            };
          };
          lsp_base = {
            params = {
              include_current = false;
            };
          };
          symbols = {
            desc = "document symbols";
            mode = "lsp_document_symbols";
            focus = false;
            win = {
              position = "right";
            };
            filter = {
              "not" = {
                ft = "lua";
                kind = "Package";
              };
              any = {
                ft = [
                  "help"
                  "markdown"
                ];
                kind = [
                  "Class"
                  "Constructor"
                  "Enum"
                  "Field"
                  "Function"
                  "Interface"
                  "Method"
                  "Module"
                  "Namespace"
                  "Package"
                  "Property"
                  "Struct"
                  "Trait"
                ];
              };
            };
          };
        };
        icons = {
          indent = {
            top = "│ ";
            middle = "├╴";
            last = "└╴";
            fold_open = " ";
            fold_closed = " ";
            ws = "  ";
          };
          folder_closed = " ";
          folder_open = " ";
          kinds = {
            Array = " ";
            Boolean = "󰨙 ";
            Class = " ";
            Constant = "󰏿 ";
            Constructor = " ";
            Enum = " ";
            EnumMember = " ";
            Event = " ";
            Field = " ";
            File = " ";
            Function = "󰊕 ";
            Interface = " ";
            Key = " ";
            Method = "󰊕 ";
            Module = " ";
            Namespace = "󰦮 ";
            Null = " ";
            Number = "󰎠 ";
            Object = " ";
            Operator = " ";
            Package = " ";
            Property = " ";
            String = " ";
            Struct = "󰆼 ";
            TypeParameter = " ";
            Variable = "󰀫 ";
          };
        };
      };
    };
  };

  split-right-preview = {
    plugins.web-devicons.enable = true;
    plugins.trouble = {
      enable = true;

      settings = {
        modes = {
          test = {
            mode = "diagnostics";
            preview = {
              type = "split";
              relative = "win";
              position = "right";
              size = 0.3;
            };
          };
        };
      };
    };
  };

  top-right-preview = {
    plugins.web-devicons.enable = true;
    plugins.trouble = {
      enable = true;

      settings = {
        modes = {
          preview_float = {
            mode = "diagnostics";
            preview = {
              type = "float";
              relative = "editor";
              border = "rounded";
              title = "Preview";
              title_pos = "center";
              position = [
                0
                (-2)
              ];
              size = {
                width = 0.3;
                height = 0.3;
              };
              zindex = 200;
            };
          };
        };
      };
    };
  };

  no-icons = {
    plugins.web-devicons.enable = false;
    plugins.trouble = {
      enable = true;
    };
  };
}
