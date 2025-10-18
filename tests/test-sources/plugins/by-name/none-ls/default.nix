{
  # Empty configuration
  empty = {
    plugins.none-ls.enable = true;
  };

  with-lsp-format = {
    plugins = {
      lsp.enable = true;
      lsp-format.enable = true;
      none-ls = {
        enable = true;
        # This is implied:
        # enableLspFormat = true;
      };
    };
  };

  defaults = {
    plugins.none-ls = {
      enable = true;

      settings = {
        border = null;
        cmd = [ "nvim" ];
        debounce = 250;
        debug = false;
        default_timeout = 5000;
        diagnostic_config = { };
        diagnostics_format = "#{m}";
        fallback_severity.__raw = "vim.diagnostic.severity.ERROR";
        log_level = "warn";
        notify_format = "[null-ls] %s";
        on_attach = null;
        on_init = null;
        on_exit = null;
        root_dir = "require('null-ls.utils').root_pattern('.null-ls-root', 'Makefile', '.git')";
        root_dir_async = null;
        should_attach = null;
        sources = null;
        temp_dir = null;
        update_in_insert = false;
      };
    };
  };

  example = {
    plugins.none-ls = {
      enable = true;

      settings = {
        diagnostics_format = "[#{c}] #{m} (#{s})";
        on_attach = ''
          function(client, bufnr)
            -- Integrate lsp-format with none-ls
            -- Disabled because plugins.lsp-format is not enabled
            -- require('lsp-format').on_attach(client, bufnr)
          end
        '';
        on_exit = ''
          function()
            print("Goodbye, cruel world!")
          end
        '';
        on_init = ''
          function(client, initialize_result)
            print("Hello, world!")
          end
        '';
        root_dir = ''
          function(fname)
            return fname:match("my-project") and "my-project-root"
          end
        '';
        root_dir_async = ''
          function(fname, cb)
            cb(fname:match("my-project") and "my-project-root")
          end
        '';
        should_attach = ''
          function(bufnr)
            return not vim.api.nvim_buf_get_name(bufnr):match("^git://")
          end
        '';
        temp_dir = "/tmp";
        update_in_insert = false;
      };
    };
  };

  with-sources =
    { options, lib, ... }:
    {
      plugins.none-ls = {
        enable = true;

        sources =
          let
            disabled = [
              # TODO Added 2025-10-12
              # mbedtls is marked insecure
              "haxe_formatter"

              # TODO Added 2025-04-01
              # php-cs-fixer is marked as broken
              "phpcsfixer"
            ];
          in
          # Enable every none-ls source that has an option
          lib.mapAttrs (
            _:
            lib.mapAttrs (
              sourceName: opts:
              {
                # Enable unless disabled above
                enable = !(lib.elem sourceName disabled);
              }
              # Some sources are defined using mkUnpackagedOption whose default will throw
              // lib.optionalAttrs (opts ? package && !(builtins.tryEval opts.package.default).success) {
                package = null;
              }
            )
          ) options.plugins.none-ls.sources;
      };
    };
}
