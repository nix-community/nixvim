{
  empty = {
    plugins.conform-nvim.enable = true;
  };

  default = {
    plugins.conform-nvim = {
      enable = true;

      formattersByFt = {
        lua = ["stylua"];
        python = ["isort" "black"];
        javascript = [["prettierd" "prettier"]];
        "*" = ["codespell"];
        "_" = ["trimWhitespace"];
      };
      formatOnSave = {
        lspFallback = true;
        timeoutMs = 500;
      };
      formatAfterSave = {
        lspFallback = true;
      };
      logLevel = "error";
      notifyOnError = true;
      formatters = {
        myFormatter = {
          command = "myCmd";
          args = ["--stdin-from-filename" "$FILENAME"];
          rangeArgs = ''
            function(ctx)
              return { "--line-start", ctx.range.start[1], "--line-end", ctx.range["end"][1] }
            end;
          '';
          stdin = true;
          cwd = ''
            require("conform.util").rootFile({ ".editorconfig", "package.json" });
          '';
          requireCwd = true;
          condition = ''
            function(ctx)
              return vim.fs.basename(ctx.filename) ~= "README.md"
            end;
          '';
          exitCodes = [0 1];
          env = {
            VAR = "value";
          };
          "inherit" = true;
          prependArgs = ["--use-tabs"];
        };
        otherFormatter = ''
          function(bufnr)
            return {
              command = "myCmd";
            }
          end;
        '';
      };
    };
  };

  custom_format_on_save_function = {
    plugins.conform-nvim = {
      enable = true;

      formattersByFt = {
        lua = ["stylua"];
        python = ["isort" "black"];
        javascript = [["prettierd" "prettier"]];
        "*" = ["codespell"];
        "_" = ["trimWhitespace"];
      };

      formatOnSave = ''
        function(bufnr)
          local ignore_filetypes = { "helm" }
          if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
            return
          end

          -- Disable with a global or buffer-local variable
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end

          -- Disable autoformat for files in a certain path
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          if bufname:match("/node_modules/") then
            return
          end
          return { timeout_ms = 500, lsp_fallback = true }
        end
      '';
    };
  };
}
