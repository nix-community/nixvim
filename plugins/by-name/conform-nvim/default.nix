{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  inherit (builtins) attrValues;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "conform-nvim";
  moduleName = "conform";
  description = "Lightweight yet powerful formatter plugin for Neovim.";

  maintainers = with lib.maintainers; [
    khaneliman
    saygo-png
  ];

  extraOptions = {
    autoInstall = {
      enable = lib.mkEnableOption ''
        automatic installation of formatters listed in `settings.formatters_by_ft` and `settings.formatters`
      '';

      enableWarnings = lib.mkOption {
        default = true;
        example = false;
        description = "Whether to enable warnings.";
        type = lib.types.bool;
      };

      overrides = lib.mkOption {
        type = with types; attrsOf (nullOr package);
        default = { };
        example = lib.literalExpression ''
          {
            "treefmt" = null;
            "pyproject-fmt" = pkgs.python312Packages.pyproject-parser;
          };
        '';
        description = ''
          Attribute set of formatter names to nix packages.
          You can set a formatter to `null` to disable auto-installing its package.
        '';
      };
    };
  };

  settingsOptions =
    let
      lsp_format =
        defaultNullOpts.mkEnumFirstDefault
          [
            "never"
            "fallback"
            "prefer"
            "first"
            "last"
          ]
          ''
            Option for choosing lsp formatting preference.

            - `never`: never use the LSP for formatting.
            - `fallback`:  LSP formatting is used when no other formatters are available.
            - `prefer`: Use only LSP formatting when available.
            - `first`: LSP formatting is used when available and then other formatters.
            - `last`: Other formatters are used then LSP formatting when available.
          '';

      timeout_ms = defaultNullOpts.mkUnsignedInt 1000 "Time in milliseconds to block for formatting.";

      quiet = defaultNullOpts.mkBool false "Don't show any notifications for warnings or failures.";

      stop_after_first = defaultNullOpts.mkBool false "Only run the first available formatter in the list.";

      # NOTE: These are the available options for the `default_format_opts` opt.
      # They are also included in the `format_opts` options available to `format_after_save` and `format_on_save`.
      defaultFormatSubmodule =
        with types;
        (submodule {
          freeformType = attrsOf anything;
          options = {
            inherit
              lsp_format
              timeout_ms
              quiet
              stop_after_first
              ;
          };
        });
    in
    {
      formatters_by_ft = defaultNullOpts.mkAttrsOf types.anything { } ''
        Creates a table mapping filetypes to formatters.

        You can run multiple formatters in a row by adding them in a list.
        If you'd like to stop after the first successful formatter, set `stop_after_first`.

        ```nix
          # Map of filetype to formatters
          formatters_by_ft =
            {
              lua = [ "stylua" ];
              # Conform will run multiple formatters sequentially
              python = [ "isort" "black" ];
              # Use stop_after_first to run only the first available formatter
              javascript = {
                __unkeyed-1 = "prettierd";
                __unkeyed-2 = "prettier";
                stop_after_first = true;
              };
              # Use the "*" filetype to run formatters on all filetypes.
              "*" = [ "codespell" ];
              # Use the "_" filetype to run formatters on filetypes that don't
              # have other formatters configured.
              "_" = [ "trim_whitespace" ];
            };
        ```
      '';

      format_on_save = defaultNullOpts.mkNullable' {
        type = with types; either strLuaFn defaultFormatSubmodule;
        pluginDefault = { };
        description = ''
          If this is set, Conform will run the formatter asynchronously on save.

          Conform will pass the table from `format_on_save` to `conform.format()`.
          This can also be a function that returns the table.

          See `:help conform.format` for details.
        '';
      };

      default_format_opts = defaultNullOpts.mkNullable defaultFormatSubmodule { } ''
        The default options to use when calling `conform.format()`.
      '';

      format_after_save = defaultNullOpts.mkNullable' {
        type = with types; either strLuaFn defaultFormatSubmodule;
        pluginDefault = { };
        description = ''
          If this is set, Conform will run the formatter asynchronously after save.

          Conform will pass the table from `format_after_save` to `conform.format()`.
          This can also be a function that returns the table.

          See `:help conform.format` for details.
        '';
      };

      log_level = defaultNullOpts.mkLogLevel "error" ''
        Set the log level. Use `:ConformInfo` to see the location of the log file.
      '';

      notify_on_error = defaultNullOpts.mkBool true "Conform will notify you when a formatter errors.";

      notify_no_formatters = defaultNullOpts.mkBool true "Conform will notify you when no formatters are available for the buffer.";

      formatters =
        defaultNullOpts.mkAttrsOf types.anything { }
          "Custom formatters and changes to built-in formatters.";
    };

  settingsExample = lib.literalMD ''
    ```nix
      {
        formatters_by_ft = {
          bash = [
            "shellcheck"
            "shellharden"
            "shfmt"
          ];
          cpp = [ "clang_format" ];
          javascript = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            timeout_ms = 2000;
            stop_after_first = true;
          };
          "_" = [
            "squeeze_blanks"
            "trim_whitespace"
            "trim_newlines"
          ];
        };
        format_on_save = # Lua
          '''
            function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end

              if slow_format_filetypes[vim.bo[bufnr].filetype] then
                return
              end

              local function on_format(err)
                if err and err:match("timeout$") then
                  slow_format_filetypes[vim.bo[bufnr].filetype] = true
                end
              end

              return { timeout_ms = 200, lsp_fallback = true }, on_format
             end
          ''';
        format_after_save = # Lua
          '''
            function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end

              if not slow_format_filetypes[vim.bo[bufnr].filetype] then
                return
              end

              return { lsp_fallback = true }
            end
          ''';
        log_level = "warn";
        notify_on_error = false;
        notify_no_formatters = false;
        formatters = {
          shellcheck = {
            command = lib.getExe pkgs.shellcheck;
          };
          shfmt = {
            command = lib.getExe pkgs.shfmt;
          };
          shellharden = {
            command = lib.getExe pkgs.shellharden;
          };
          squeeze_blanks = {
            command = lib.getExe' pkgs.coreutils "cat";
          };
        };
      }
    ```
  '';

  extraConfig =
    cfg: opts:
    let
      inherit (cfg.autoInstall) enable enableWarnings;
      inherit (import ./auto-install.nix { inherit pkgs lib; })
        getPackageOrStateByName
        collectFormatters
        mkWarnsFromStates
        ;
      getPackageOrStateByNameWith = getPackageOrStateByName {
        configuredFormatters = cfg.settings.formatters;
        inherit (cfg.autoInstall) overrides;
      };
      formatterNames = collectFormatters (attrValues (cfg.settings.formatters_by_ft or { }));
      packagesAndStates = lib.foldAttrs (item: acc: [ item ] ++ acc) [ ] (
        map getPackageOrStateByNameWith formatterNames
      );
    in
    {
      warnings = lib.mkIf (enable && enableWarnings) (mkWarnsFromStates opts packagesAndStates.wrong);
      extraPackages = lib.mkIf enable packagesAndStates.right;
    };
}
