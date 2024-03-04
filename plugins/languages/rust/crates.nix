{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
  helpers.neovim-plugin.mkNeovimPlugin config {
    name = "crates";
    originalName = "crates.nvim";
    defaultPackage = pkgs.vimPlugins.crates-nvim;

    maintainers = [maintainers.GaetanLepage];

    settingsOptions = {
      on_attach = helpers.defaultNullOpts.mkLuaFn "function(bufnr) end" ''
        `fun(bufnr: integer)`

        Callback to run when a `Cargo.toml` file is opened.

        NOTE: Ignored if `autoload` is disabled.
      '';

      cmp = {
        enabled = helpers.defaultNullOpts.mkBool false ''
          Whether to load and register the `nvim-cmp` source.

          NOTE: Ignored if `autoload` is disabled.
          You may manually register it, after `nvim-cmp` has been loaded.
          ```lua
            require("crates.src.cmp").setup()
          ```
        '';
      };

      null_ls = {
        enabled = helpers.defaultNullOpts.mkBool false ''
          Whether to register the `null-ls.nvim` source.
        '';

        name = helpers.defaultNullOpts.mkStr "crates.nvim" ''
          The `null-ls.nvim` name.
        '';
      };

      lsp = {
        enabled = helpers.defaultNullOpts.mkBool false ''
          Whether to enable the in-process language server.
        '';

        name = helpers.defaultNullOpts.mkStr "crates.nvim" ''
          The lsp server name.
        '';

        on_attach = helpers.defaultNullOpts.mkLuaFn "function(client, bufnr) end" ''
          `fun(client: lsp.Client, bufnr: integer)`

          Callback to run when the in-process language server attaches to a buffer.

          NOTE: Ignored if `autoload` is disabled.
        '';

        # on_attach = helpers.defaultNullOpts.mkLuaFn "__lspOnAttach" ''
        # '';

        actions = helpers.defaultNullOpts.mkBool false ''
          Whether to enable the `codeActionProvider` capability.
        '';

        completion = helpers.defaultNullOpts.mkBool false ''
          Whether to enable the `completionProvider` capability.
        '';

        hover = helpers.defaultNullOpts.mkBool false ''
          Whether to enable the `hover` capability.
        '';
      };
    };

    settingsExample = {
      smart_insert = true;
      insert_closing_quote = true;
      autoload = true;
      autoupdate = true;
      autoupdate_throttle = 250;
      loading_indicator = true;
      date_format = "%Y-%m-%d";
      thousands_separator = ".";
      notification_title = "crates.nvim";
      curl_args = ["-sL" "--retry" "1"];
      max_parallel_requests = 80;
      open_programs = ["xdg-open" "open"];
      on_attach = "function(bufnr) end";
      text = {
        loading = "   Loading";
        version = "   %s";
      };
      highlight = {
        loading = "CratesNvimLoading";
        version = "CratesNvimVersion";
      };
    };

    extraConfig = cfg: {
      warnings = let
        cmpSourceEnabled = isBool cfg.settings.cmp.enabled && cfg.cmp.settings.enabled;
      in
        optional (cmpSourceEnabled && !config.plugins.cmp.enable)
        ''
          Nixvim (plugins.crates): You have enabled `cmp.enabled` but `plugins.cmp.enable` is `false`.
          You need to enable `cmp` to use this setting.
        '';
    };
  }
