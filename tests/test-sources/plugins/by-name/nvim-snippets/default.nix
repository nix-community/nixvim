{
  empty = {
    plugins = {
      cmp.enable = true;
      nvim-snippets.enable = true;
    };
  };

  defaults = {
    plugins = {
      cmp.enable = true;

      nvim-snippets = {
        enable = true;
        settings = {
          create_autocmd = false;
          create_cmp_source = true;
          friendly_snippets = false;
          ignored_filetypes.__raw = "nil";
          extended_filetypes.__empty = { };
          global_snippets = [ "all" ];
          search_paths = [ { __raw = "vim.fn.stdpath('config') .. '/snippets'"; } ];
        };
      };
    };
  };

  example = {
    plugins = {
      friendly-snippets.enable = true;

      cmp = {
        enable = true;
        settings = {
          sources = [ { name = "snippets"; } ];
          mapping.__raw = "require('cmp').mapping.preset.insert()";
        };
      };

      nvim-snippets = {
        enable = true;
        settings = {
          create_autocmd = false;
          create_cmp_source = true;
          friendly_snippets = true;
          ignored_filetypes = [ "html" ];
          extended_filetypes = {
            typescript = [ "javascript" ];
            tex = [ "latex" ];
          };
          global_snippets = [ "global_snippets" ];
          search_paths = [
            { __raw = "vim.fn.stdpath('config') .. '/snippets'"; }
            { __raw = "vim.fn.stdpath('config') .. '/extra-snippets'"; }
          ];
        };
      };
    };

    keymaps = [
      {
        mode = "i";
        key = "<Tab>";
        action.__raw = ''
          function()
                if vim.snippet.active({ direction = 1 }) then
                  vim.schedule(function()
                    vim.snippet.jump(1)
                  end)
                  return
                end
                return "<Tab>"
              end
        '';
        options = {
          expr = true;
          silent = true;
        };
      }
      {
        mode = "s";
        key = "<Tab>";
        action.__raw = ''
            function()
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          end
        '';
        options = {
          expr = true;
          silent = true;
        };
      }
      {
        mode = [
          "i"
          "s"
        ];
        key = "<S-Tab>";
        action.__raw = ''
          function()
                if vim.snippet.active({ direction = -1 }) then
                  vim.schedule(function()
                    vim.snippet.jump(-1)
                  end)
                  return
                end
                return "<S-Tab>"
              end
        '';
        options = {
          expr = true;
          silent = true;
        };
      }
    ];
  };
}
