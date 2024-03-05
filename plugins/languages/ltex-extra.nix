{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.ltex-extra;
in {
  meta.maintainers = [maintainers.loicreynier];

  options.plugins.ltex-extra =
    helpers.neovim-plugin.extraOptionsOptions
    // {
      enable = mkEnableOption "ltex-extra";

      package = helpers.mkPackageOption "ltex-extra" pkgs.vimPlugins.ltex_extra-nvim;

      path = helpers.defaultNullOpts.mkStr "" ''
        Path (relative to project root) to load external files from.

        Commonly used values are:
        - `.ltex`
        - `.vscode` for compatibility with projects using the associated VS Code extension.
      '';

      initCheck = helpers.defaultNullOpts.mkBool true ''
        Whether to load dicionnaries on startup.
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

  config = let
    setupOptions = with cfg; {
      inherit path;
      init_check = initCheck;
      load_langs = loadLangs;
      log_level = logLevel;
    };
  in
    mkIf cfg.enable {
      warnings = optional (!config.plugins.lsp.enable) ''
        You have enabled `ltex-extra` but not the lsp (`plugins.lsp`).
        You should set `plugins.lsp.enable = true` to make use of the LTeX_extra plugin's features.
      '';

      extraPlugins = [cfg.package];

      plugins.lsp = {
        # Enable the ltex language server
        servers.ltex.enable = true;

        postConfig = ''
          require("ltex_extra").setup(${helpers.toLuaObject setupOptions})
        '';
      };
    };
}
