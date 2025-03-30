{
  lib,
  helpers,
  config,
  options,
  ...
}:
with lib;
let
  lspCfg = config.plugins.lsp;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "ltex-extra";
  packPathName = "ltex_extra.nvim";
  package = "ltex_extra-nvim";

  maintainers = [ maintainers.loicreynier ];

  description = ''
    This plugin works with both the ltex or ltex_plus language servers and will enable ltex_plus if neither are.
  '';

  callSetup = false;

  settingsOptions = {
    path = helpers.defaultNullOpts.mkStr "" ''
      Path (relative to project root) to load external files from.

      Commonly used values are:
      - `.ltex`
      - `.vscode` for compatibility with projects using the associated VS Code extension.
    '';

    init_check = helpers.defaultNullOpts.mkBool true ''
      Whether to load dictionaries on startup.
    '';

    load_langs = helpers.defaultNullOpts.mkListOf types.str [ "en-US" ] ''
      Languages for witch dicionnaries will be loaded.
      See `plugins.lsp.servers.ltex.languages` for possible values.
    '';

    log_level = helpers.defaultNullOpts.mkEnumFirstDefault [
      "none"
      "trace"
      "debug"
      "info"
      "warn"
      "error"
      "fatal"
    ] "Log level.";
  };

  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.ltex-extra" [
      {
        when = !lspCfg.enable;
        message = ''
          You have enabled `ltex-extra` but not the lsp (`plugins.lsp`).
          You should set `plugins.lsp.enable = true` to make use of the LTeX_extra plugin's features.
        '';
      }
      (
        let
          expectedDefs = map toString [
            ./.
            ../../lsp/language-servers
          ];
          isExternal = d: !elem d.file expectedDefs;
          anyExternal =
            acc: name: v:
            let
              e = findFirst isExternal null v.definitionsWithLocations;
            in
            if acc != null then
              acc
            else if e == null then
              null
            else
              {
                inherit name;
                inherit (e) file;
              };
          external = foldlAttrs anyExternal null options.plugins.lsp.servers.ltex;
        in
        {
          # TODO: Added 2025-03-30; remove after 25.05
          # Warn if servers.ltex seems to be configured outside of ltex-extra
          when = !lspCfg.servers.ltex.enable && external != null;
          message = ''
            in ${external.file}
            You seem to have configured `plugins.lsp.servers.ltex.${external.name}` for `ltex-extra`.
            It now uses `plugins.lsp.servers.ltex_plus` by default,
            either move the configuration or explicitly enable `ltex` with `plugins.lsp.servers.ltex.enable = true`
          '';
        }
      )
    ];

    plugins.lsp =
      let
        attachLua = ''
          require("ltex_extra").setup(${lib.nixvim.toLuaObject cfg.settings})
        '';
      in
      {
        servers.ltex.onAttach.function = attachLua;
        servers.ltex_plus = {
          # Enable ltex_plus if ltex is not already enabled
          enable = mkIf (!lspCfg.servers.ltex.enable) (mkDefault true);
          onAttach.function = attachLua;
        };
      };
  };

  settingsExample = {
    path = ".ltex";
    initCheck = true;
    loadLangs = [
      "en-US"
      "fr-FR"
    ];
    logLevel = "non";
  };
}
