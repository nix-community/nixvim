{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.conform-nvim;
in {
  options.plugins.conform-nvim =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "conform-nvim";

      package = helpers.mkPackageOption "conform-nvim" pkgs.vimPlugins.conform-nvim;

      formattersByFt =
        helpers.defaultNullOpts.mkNullable (types.attrsOf types.anything)
        "see documentation"
        ''
          ```nix
            # Map of filetype to formatters
            formattersByFt =
              {
                lua = [ "stylua" ];
                # Conform will run multiple formatters sequentially
                python = [ "isort" "black" ];
                # Use a sub-list to run only the first available formatter
                javascript = [ [ "prettierd" "prettier" ] ];
                # Use the "*" filetype to run formatters on all filetypes.
                "*" = [ "codespell" ];
                # Use the "_" filetype to run formatters on filetypes that don't
                # have other formatters configured.
                "_" = [ "trim_whitespace" ];
               };
          ```
        '';

      formatOnSave =
        helpers.defaultNullOpts.mkNullable (types.submodule {
          options = {
            lspFallback = mkOption {
              type = types.bool;
              default = true;
              description = "See :help conform.format for details.";
            };
            timeoutMs = mkOption {
              type = types.int;
              default = 500;
              description = "See :help conform.format for details.";
            };
          };
        })
        "see documentation"
        ''
          If this is set, Conform will run the formatter on save.
          It will pass the table to conform.format().
          This can also be a function that returns the table.
          See :help conform.format for details.
        '';

      formatAfterSave =
        helpers.defaultNullOpts.mkNullable (types.submodule {
          options = {
            lspFallback = mkOption {
              type = types.bool;
              default = true;
              description = "See :help conform.format for details.";
            };
          };
        })
        "see documentation"
        ''
          If this is set, Conform will run the formatter asynchronously after save.
          It will pass the table to conform.format().
          This can also be a function that returns the table.
        '';

      logLevel =
        helpers.defaultNullOpts.mkEnumFirstDefault
        ["ERROR" "DEBUG" "INFO" "TRACE" "WARN" "OFF"]
        "Set the log level. Use `:ConformInfo` to see the location of the log file.";

      notifyOnError =
        helpers.defaultNullOpts.mkBool true
        "Conform will notify you when a formatter errors";

      formatters =
        helpers.defaultNullOpts.mkNullable (types.attrsOf types.anything)
        "see documentation"
        "Custom formatters and changes to built-in formatters";
    };

  config = let
    setupOptions = with cfg;
      {
        formatters_by_ft = formattersByFt;
        format_on_save = helpers.ifNonNull' formatOnSave {
          lsp_fallback = formatOnSave.lspFallback;
          timeout_ms = formatOnSave.timeoutMs;
        };
        format_after_save = helpers.ifNonNull' formatOnSave {
          lsp_fallback = formatOnSave.lspFallback;
        };
        log_level = helpers.ifNonNull' logLevel (helpers.mkRaw "vim.log.levels.${logLevel}");
        notify_on_error = notifyOnError;
        inherit formatters;
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = ''
        require("conform").setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
