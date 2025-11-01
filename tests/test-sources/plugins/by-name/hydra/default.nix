{
  empty = {
    plugins.hydra.enable = true;
  };

  defaults = {
    plugins.hydra = {
      enable = false;

      settings = {
        debug = false;
        exit = false;
        foreign_keys.__raw = "nil";
        color = "red";
        buffer.__raw = "nil";
        invoke_on_body = false;
        desc.__raw = "nil";
        on_enter.__raw = "nil";
        on_exit.__raw = "nil";
        on_key.__raw = "nil";
        timeout = false;
        hint = {
          show_name = true;
          position = "bottom";
          offset = 0;
        };
      };
    };
  };

  example = {
    plugins = {
      # This example turns out to use gitsigns
      gitsigns.enable = true;

      hydra = {
        enable = false;

        settings = {
          exit = false;
          foreign_keys = "run";
          color = "red";
          buffer = true;
          invoke_on_body = false;
          desc.__raw = "nil";
          on_enter = ''
            function()
              print('hello')
            end
          '';
          timeout = 5000;
          hint = false;
        };

        hydras = [
          {
            name = "git";
            hint.__raw = ''
              [[
                 _J_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
                 _K_: prev hunk   _u_: undo stage hunk   _p_: preview hunk   _B_: blame show full
                 ^ ^              _S_: stage buffer      ^ ^                 _/_: show base file
                 ^
                 ^ ^              _<Enter>_: Neogit              _q_: exit
              ]]
            '';
            config = {
              color = "pink";
              invoke_on_body = true;
              hint = {
                position = "bottom";
              };
              on_enter = ''
                function()
                  vim.bo.modifiable = false
                  gitsigns.toggle_signs(true)
                  gitsigns.toggle_linehl(true)
                end
              '';
              on_exit = ''
                function()
                	gitsigns.toggle_signs(false)
                	gitsigns.toggle_linehl(false)
                	gitsigns.toggle_deleted(false)
                	vim.cmd("echo") -- clear the echo area
                end
              '';
            };
            mode = [
              "n"
              "x"
            ];
            body = "<leader>g";
            heads = [
              [
                "J"
                {
                  __raw = ''
                    function()
                      if vim.wo.diff then
                        return "]c"
                      end
                      vim.schedule(function()
                        gitsigns.next_hunk()
                      end)
                      return "<Ignore>"
                    end
                  '';
                }
                { expr = true; }
              ]
              [
                "K"
                {
                  __raw = ''
                    function()
                      if vim.wo.diff then
                        return "[c"
                      end
                      vim.schedule(function()
                        gitsigns.prev_hunk()
                      end)
                      return "<Ignore>"
                    end
                  '';
                }
                { expr = true; }
              ]
              [
                "s"
                ":Gitsigns stage_hunk<CR>"
                { silent = true; }
              ]
              [
                "u"
                { __raw = "require('gitsigns').undo_stage_hunk"; }
              ]
              [
                "S"
                { __raw = "require('gitsigns').stage_buffer"; }
              ]
              [
                "p"
                { __raw = "require('gitsigns').preview_hunk"; }
              ]
              [
                "d"
                { __raw = "require('gitsigns').toggle_deleted"; }
                { nowait = true; }
              ]
              [
                "b"
                { __raw = "require('gitsigns').blame_line"; }
              ]
              [
                "B"
                {
                  __raw = ''
                    function()
                      gitsigns.blame_line({ full = true })
                    end,
                  '';
                }
              ]
              [
                "/"
                { __raw = "require('gitsigns').show"; }
                { exit = true; }
              ]
              [
                "<Enter>"
                "<cmd>Neogit<CR>"
                { exit = true; }
              ]
              [
                "q"
                null
                {
                  exit = true;
                  nowait = true;
                }
              ]
            ];
          }
        ];
      };
    };
  };
}
