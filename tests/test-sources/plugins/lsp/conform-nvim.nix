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
      logLevel = "ERROR";
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
}
