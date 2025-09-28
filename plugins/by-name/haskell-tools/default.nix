{
  lib,
  config,
  pkgs,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "haskell-tools";
  package = "haskell-tools-nvim";
  maintainers = [ lib.maintainers.saygo-png ];

  # This is a filetype plugin that doesn't use a setup function.
  # Configuration is passed to a global table.
  callSetup = false;

  extraOptions = {
    enableTelescope = lib.mkEnableOption "telescope integration";
    hlsPackage = lib.mkPackageOption pkgs "haskell-language-server" {
      nullable = true;
    };
  };

  settingsExample = {
    hls = {
      default_settings = {
        haskell = {
          formattingProvider = "ormolu";
          plugin = {
            hlint = {
              codeActionsOn = false;
              diagnosticsOn = false;
            };
            importLens = {
              globalOn = false;
              codeActionsOn = false;
              codeLensOn = false;
            };
          };
        };
      };
    };
  };

  extraConfig = cfg: {
    globals.haskell_tools = cfg.settings;
    extraPackages = [ cfg.hlsPackage ];

    plugins.telescope.enabledExtensions = lib.mkIf cfg.enableTelescope [ "ht" ];
    assertions = lib.nixvim.mkAssertions "plugins.haskell-tools" {
      assertion = cfg.enableTelescope -> config.plugins.telescope.enable;
      message = "The haskell-tools telescope integration needs telescope to function as intended.";
    };

    warnings = lib.nixvim.mkWarnings "plugins.haskell-tools" [
      {
        when = config.lsp.servers.hls.enable || config.plugins.lsp.servers.hls.enable;
        message = ''
          It is recommended to disable hls when using haskell-tools
          as it can cause conflicts. The plugin sets up the server already.
        '';
      }
    ];
  };
}
