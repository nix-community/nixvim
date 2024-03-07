{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
  helpers.neovim-plugin.mkNeovimPlugin config {
    name = "ltex-extra";
    originalName = "ltex_extra.nvim";
    defaultPackage = pkgs.vimPlugins.ltex_extra-nvim;

    maintainers = [maintainers.loicreynier];

    callSetup = false;

    settingsOptions = {
      path = helpers.defaultNullOpts.mkStr "" ''
        Path (relative to project root) to load external files from.

        Commonly used values are:
        - `.ltex`
        - `.vscode` for compatibility with projects using the associated VS Code extension.
      '';

      initCheck = helpers.defaultNullOpts.mkBool true ''
        Whether to load dictionaries on startup.
      '';

      loadLangs = helpers.defaultNullOpts.mkNullable (types.listOf types.str) ''["en-US"]'' ''
        Languages for witch dicionnaries will be loaded.
        See `plugins.lsp.servers.ltex.languages` for possible values.
      '';

      logLevel = helpers.defaultNullOpts.mkStr "none" ''
        Log level. Possible values:
        - "none"
        - "trace"
        - "debug"
        - "info"
        - "warn"
        - "error"
        - "fatal"
      '';
    };

    extraConfig = cfg: {
      warnings = optional (!config.plugins.lsp.enable) ''
        You have enabled `ltex-extra` but not the lsp (`plugins.lsp`).
        You should set `plugins.lsp.enable = true` to make use of the LTeX_extra plugin's features.
      '';

      extraPlugins = [cfg.package];

      plugins.lsp = {
        servers.ltex = {
          # Enable the ltex language server
          enable = true;

          onAttach.function = ''
            require("ltex_extra").setup(${helpers.toLuaObject setupOptions})
          '';
        };
      };
    };

    settingsExample = {
      path = ".ltex";
      initCheck = true;
      loadLangs = ["en-US" "fr-FR"];
      logLevel = "non";
    };
  }
