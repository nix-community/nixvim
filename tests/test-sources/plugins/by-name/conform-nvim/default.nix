{ lib, pkgs }:
{
  empty = {
    plugins.conform-nvim.enable = true;
  };

  all-formatters =
    let
      allFormatters = lib.importJSON ../../../../../generated/conform-formatters.json;
    in
    {
      plugins.conform-nvim = {
        enable = true;
        autoInstall = {
          enable = true;
          enableWarnings = false;
        };
        settings.formatters_by_ft."*" = allFormatters;
      };
    };

  default = {
    plugins.conform-nvim = {
      enable = true;

      settings = {
        formatters_by_ft.__empty = { };
        format_on_save = {
          lsp_format = "never";
          timeout_ms = 1000;
          quiet = false;
          stop_after_first = false;
        };
        default_format_opts = {
          lsp_format = "never";
          timeout_ms = 1000;
          quiet = false;
          stop_after_first = false;
        };
        format_after_save = {
          lsp_format = "never";
          timeout_ms = 1000;
          quiet = false;
          stop_after_first = false;
        };
        log_level = "error";
        notify_on_error = true;
        notify_no_formatters = true;
        formatters.__empty = { };
      };
    };
  };

  example = {
    plugins.conform-nvim = {
      enable = true;

      settings = {
        formatters_by_ft = {
          lua = [ "stylua" ];
          python = [
            "isort"
            "black"
          ];
          javascript = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            timeout_ms = 2000;
            stop_after_first = true;
          };
          "*" = [ "codespell" ];
          "_" = [ "trimWhitespace" ];
        };
        format_on_save = {
          lsp_format = "fallback";
          timeout_ms = 500;
        };
        format_after_save = {
          lsp_format = "fallback";
        };
        log_level = "error";
        notify_on_error = false;
        notify_no_formatters = false;
        formatters = {
          nixfmt = {
            command = lib.getExe pkgs.nixfmt-rfc-style;
          };
          myFormatter = {
            command = "myCmd";
            args = [
              "--stdin-from-filename"
              "$FILENAME"
            ];
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
            exitCodes = [
              0
              1
            ];
            env = {
              VAR = "value";
            };
            "inherit" = true;
            prependArgs = [ "--use-tabs" ];
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
  };

  custom_format_on_save_function = {
    plugins.conform-nvim = {
      enable = true;

      settings = {
        format_on_save = ''
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
  };

  custom_format_after_save_function = {
    plugins.conform-nvim = {
      enable = true;

      settings = {
        format_after_save = ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
            if not _conform_slow_format_filetypes[vim.bo[bufnr].filetype] then
              return
            end
            return { lsp_fallback = true }
          end
        '';
      };
    };
  };
}
