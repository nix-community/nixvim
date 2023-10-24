{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.conform;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options.plugins.conform =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "conform.nvim";

      package = helpers.mkPackageOption "conform.nvim" pkgs.vimPlugins.conform-nvim;

      # Map of filetype to formatters
      formattersByFt =
        helpers.defaultNullOpts.mkNullable types.attrs
        "see documentation"
        ''
          Map of filetype to formatters
          lua = { "stylua" },
          Conform will run multiple formatters sequentially
          python = { "isort", "black" },
          Use a sub-list to run only the first available formatter
          javascript = { { "prettierd", "prettier" } },
          Use the "*" filetype to run formatters on all filetypes.
          ["*"] = { "codespell" },
          Use the "_" filetype to run formatters on filetypes that don't
          have other formatters configured.
          ["_"] = { "trim_whitespace" },
        '';
      # If this is set, Conform will run the formatter on save.
      # It will pass the table to conform.format().
      # This can also be a function that returns the table.
      # See :help conform.format for details.
      formatOnSave = {
        lspFallback =
          helpers.defaultNullOpts.mkBool true
          "See :help conform.format for details.";
        timeoutMs =
          helpers.defaultNullOpts.mkNullable (types.int) 1000
          "See :help conform.format for details.";
      };

      # If this is set, Conform will run the formatter asynchronously after save.
      # It will pass the table to conform.format().
      # This can also be a function that returns the table.
      formatAfterSave = {
        lspFallback =
          helpers.defaultNullOpts.mkBool true
          "See :help conform.format for details.";
      };

      # Set the log level. Use `:ConformInfo` to see the location of the log file.
      logLevel =
        helpers.defaultNullOpts.mkNullable
        types.str
        "vim.log.levels.ERROR"
        " See :h log_levels ";

      # Conform will notify you when a formatter errors
      notifyOnError =
        helpers.defaultNullOpts.mkBool true
        "Conform will notify you when a formatter errors";

      # Custom formatters and changes to built-in formatters
      formatters =
        helpers.defaultNullOpts.mkNullable types.attrs
        "see documentation"
        "Custom formatters and changes to built-in formatters";
    };

  config = let
    setupOptions = with cfg;
      {
        inherit formattersByFt;
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
