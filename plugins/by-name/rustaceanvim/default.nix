{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin {
  name = "rustaceanvim";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO: introduced 2024-05-17, remove on 2024-02-17
  deprecateExtraOptions = true;
  optionsRenamedToSettings = import ./renamed-options.nix;

  extraOptions = {
    rustAnalyzerPackage = lib.mkPackageOption pkgs "rust-analyzer" {
      nullable = true;
    };
  };

  settingsOptions = import ./settings-options.nix { inherit lib helpers pkgs; };

  settingsExample = {
    server = {
      standalone = false;
      cmd = [
        "rustup"
        "run"
        "nightly"
        "rust-analyzer"
      ];
      default_settings = {
        rust-analyzer = {
          inlayHints = {
            lifetimeElisionHints = {
              enable = "always";
            };
          };
          check = {
            command = "clippy";
          };
        };
      };
    };
  };

  callSetup = false;
  hasConfigAttrs = false;
  configLocation = null;
  extraConfig =
    cfg:
    mkMerge [
      {
        extraPackages = [ cfg.rustAnalyzerPackage ];

        globals.rustaceanvim = cfg.settings;

        assertions = [
          {
            assertion = cfg.enable -> !config.plugins.lsp.servers.rust-analyzer.enable;
            message = ''
              Nixvim (plugins.rustaceanvim): Both `plugins.rustaceanvim.enable` and `plugins.lsp.servers.rust-analyzer.enable` are true.
              Disable one of them otherwise you will have multiple clients attached to each buffer.
            '';
          }
        ];

        # TODO: remove after 24.11
        warnings =
          optional
            (hasAttrByPath [
              "settings"
              "server"
              "settings"
            ] cfg)
            ''
              The `plugins.rustaceanvim.settings.server.settings' option has been renamed to `plugins.rustaceanvim.settings.server.default_settings'.

              Note that if you supplied an attrset and not a function you need to set this attr set in:
                `plugins.rustaceanvim.settings.server.default_settings.rust-analyzer'.
            '';
      }
      # If nvim-lspconfig is enabled:
      (mkIf config.plugins.lsp.enable {
        # Use the same `on_attach` callback as for the other LSP servers
        plugins.rustaceanvim.settings.server.on_attach = mkDefault ''
          function(client, bufnr)
            return _M.lspOnAttach(client, bufnr)
          end
        '';
      })
    ];
}
