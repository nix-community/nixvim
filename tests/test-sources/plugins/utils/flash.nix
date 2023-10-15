{helpers, ...}: {
  empty = {
    plugins.flash.enable = true;
  };

  defaults = {
    plugins.flash = {
      enable = true;

      labels = "asdfghjklqwertyuiopzxcvbnm";
      search = {
        multiWindow = true;
        forward = true;
        wrap = true;
        mode = "exact";
        incremental = false;
        exclude = [
          "notify"
          "cmp_menu"
          "noice"
          "flash_prompt"
          {
            __raw = ''
              function(win)
                -- exclude non-focusable windows
                return not vim.api.nvim_win_get_config(win).focusable
              end
            '';
          }
        ];
        trigger = "";
        maxLength = false;
      };
      jump = {
        jumplist = true;
        pos = "start";
        history = false;
        register = false;
        nohlsearch = false;
        autojump = false;
        inclusive = null;
        offset = null;
      };
      label = {
        uppercase = true;
        exclude = "";
        current = true;
        after = true;
        before = false;
        style = "overlay";
        reuse = "lowercase";
        distance = true;
        minPatternLength = 0;
        rainbow = {
          enabled = false;
          shade = 5;
        };
        format = ''
          function(opts)
            return { { opts.match.label, opts.hl_group } }
          end
        '';
      };
      highlight = {
        backdrop = true;
        matches = true;
        priority = 5000;
        groups = {
          match = "FlashMatch";
          current = "FlashCurrent";
          backdrop = "FlashBackdrop";
          label = "FlashLabel";
        };
      };
      action = null;
      pattern = "";
      continue = false;
      config = null;
      prompt = {
        enabled = true;
        prefix = [["⚡" "FlashPromptIcon"]];
        winConfig = {
          relative = "editor";
          width = 1;
          height = 1;
          row = -1;
          col = 0;
          zindex = 1000;
        };
      };
      remoteOp = {
        restore = false;
        motion = false;
      };
      modes = {
        search = {
          enabled = true;
          highlight = {backdrop = false;};
          jump = {
            history = true;
            register = true;
            nohlsearch = true;
          };
          search.automatic = true;
        };
        char = {
          enabled = true;
          config = ''
            function(opts)
              -- autohide flash when in operator-pending mode
              opts.autohide = vim.fn.mode(true):find("no") and vim.v.operator == "y"

              -- disable jump labels when not enabled, when using a count,
              -- or when recording/executing registers
              opts.jump_labels = opts.jump_labels
                and vim.v.count == 0
                and vim.fn.reg_executing() == ""
                and vim.fn.reg_recording() == ""

              -- Show jump labels only in operator-pending mode
              -- opts.jump_labels = vim.v.count == 0 and vim.fn.mode(true):find("o")
            end
          '';
          autohide = false;
          jumpLabels = false;
          multiLine = true;
          label = {exclude = "hjkliardc";};
          keys = helpers.listToUnkeyedAttrs ["f" "F" "t" "T" ";" ","];
          charActions = ''
            function(motion)
              return {
                [";"] = "next", -- set to `right` to always go right
                [","] = "prev", -- set to `left` to always go left
                -- clever-f style
                [motion:lower()] = "next",
                [motion:upper()] = "prev",
                -- jump2d style: same case goes next, opposite case goes prev
                -- [motion] = "next",
                -- [motion:match("%l") and motion:upper() or motion:lower()] = "prev",
              }
            end
          '';
          search = {wrap = false;};
          highlight = {backdrop = true;};
          jump = {register = false;};
        };
        treesitter = {
          labels = "abcdefghijklmnopqrstuvwxyz";
          jump = {pos = "range";};
          search = {incremental = false;};
          label = {
            before = true;
            after = true;
            style = "inline";
          };
          highlight = {
            backdrop = false;
            matches = false;
          };
        };
        treesitterSearch = {
          jump = {pos = "range";};
          search = {
            multiWindow = true;
            wrap = true;
            incremental = false;
          };
          remoteOp = {restore = true;};
          label = {
            before = true;
            after = true;
            style = "inline";
          };
        };
        remote = {
          remoteOp = {
            restore = true;
            motion = true;
          };
        };
      };
    };
  };
}
