{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "neoconf";
  packPathName = "neoconf.nvim";
  package = "neoconf-nvim";

  maintainers = [ lib.maintainers.BoneyPatel ];

  settingsOptions = {
    local_settings = defaultNullOpts.mkStr ".neoconf.json" ''
      Name of the local settings file for the plugin.
    '';

    global_settings = defaultNullOpts.mkStr "neoconf.json" ''
      Name of the global settings file in your Neovim config directory.
    '';

    import = {
      vscode = defaultNullOpts.mkBool true ''
        Whether to import settings from local `.vscode/settings.json` files.
      '';

      coc = defaultNullOpts.mkBool true ''
        Whether to import settings from global/local `coc-settings.json` files.
      '';

      lsp = defaultNullOpts.mkBool true ''
        Whether to import settings from global/local `nlsp-settings.nvim` JSON settings.
      '';
    };

    live_reload = defaultNullOpts.mkBool true ''
      Send new configuration to LSP clients when JSON settings change.
    '';

    filetype_jsonc = defaultNullOpts.mkBool true ''
      Set the filetype to JSONC for settings files, allowing comments. Requires the JSONC treesitter parser.
    '';

    plugins = {
      lspconfig = {
        enabled = defaultNullOpts.mkBool true ''
          Enable configuration of LSP clients in order of Lua settings, global JSON settings, then local JSON settings.
        '';
      };

      jsonls = {
        enabled = defaultNullOpts.mkBool true ''
          Enable jsonls to provide completion for `.nvim.settings.json` files.
        '';

        configured_servers_only = defaultNullOpts.mkBool true ''
          Limit JSON settings completion to configured LSP servers only.
        '';
      };

      lua_ls = {
        enabled_for_neovim_config = defaultNullOpts.mkBool true ''
          Enable lua_ls annotations specifically within the Neovim config directory.
        '';

        enabled = defaultNullOpts.mkBool false ''
          Enable adding annotations in local `.nvim.settings.json` files.
        '';
      };
    };
  };

  settingsExample = {
    local_settings = ".neoconf.json";
    global_settings = "neoconf.json";
    import = {
      vscode = true;
      coc = true;
      lsp = true;
    };
    live_reload = true;
    filetype_jsonc = true;
    plugins = {
      lspconfig = {
        enabled = true;
      };
      lua_ls = {
        enabled_for_neovim_config = true;
        enabled = false;
      };
    };
  };
}
