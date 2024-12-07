{
  empty = {
    plugins.snacks.enable = true;
  };

  example = {
    plugins.snacks = {
      enable = true;

      settings = {
        bigfile = {
          enabled = true;
        };
        statuscolumn = {
          enabled = false;
        };
        words = {
          enabled = true;
          debounce = 100;
        };
        quickfile = {
          enabled = false;
        };
        notifier = {
          enabled = true;
          timeout = 3000;
        };
      };
    };
  };

  default = {
    plugins.snacks = {
      enable = true;

      settings = {
        bigfile = {
          enabled = true;
          notify = true;
          size.__raw = "1.5 * 1024 * 1024";
          setup.__raw = ''
            function(ctx)
              vim.b.minianimate_disable = true
              vim.schedule(function()
                vim.bo[ctx.buf].syntax = ctx.ft
              end)
            end
          '';
        };
        notifier = {
          enabled = true;
          timeout = 3000;
          width = {
            min = 40;
            max = 0.4;
          };
          height = {
            min = 1;
            max = 0.6;
          };
          margin = {
            top = 0;
            right = 1;
            bottom = 0;
          };
          padding = true;
          sort = [
            "level"
            "added"
          ];
          icons = {
            error = " ";
            warn = " ";
            info = " ";
            debug = " ";
            trace = " ";
          };
          style = "compact";
          top_down = true;
          date_format = "%R";
          refresh = 50;
        };
        quickfile = {
          enabled = true;
          exclude = [ "latex" ];
        };
        statuscolumn = {
          left = [
            "mark"
            "sign"
          ];
          right = [
            "fold"
            "git"
          ];
          folds = {
            open = false;
            git_hl = false;
          };
          git = {
            patterns = [
              "GitSign"
              "MiniDiffSign"
            ];
          };
          refresh = 50;
        };
        words = {
          enabled = true;
          debounce = 200;
          notify_jump = false;
          notify_end = true;
          foldopen = true;
          jumplist = true;
          modes = [
            "n"
            "i"
            "c"
          ];
        };
      };
    };
  };

  all-plugins = {
    plugins.snacks = {
      enable = true;

      settings = {
        bigfile = {
          enabled = true;
          notify = true;
          size.__raw = "1.5 * 1024 * 1024";
        };
        notifier = {
          enabled = true;
          timeout = 5000;
          width = {
            min = 50;
            max = 0.5;
          };
          padding = false;
          sort = [
            "added"
            "level"
          ];
          style = "fancy";
          refresh = 100;
          date_format = "%R";
          top_down = false;
        };
        quickfile = {
          enabled = true;
          exclude = [ "latex" ];
        };
        statuscolumn = {
          enabled = true;
          left = [
            "sign"
            "mark"
          ];
          folds.open = true;
          refresh = 100;
        };
        words = {
          enabled = true;
          debounce = 300;
          notify_jump = true;
          notify_end = false;
          foldopen = false;
          jumplist = true;
          modes = [
            "n"
            "i"
          ];
        };
      };
    };
  };
}
