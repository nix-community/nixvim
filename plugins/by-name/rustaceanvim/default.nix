{
  lib,
  helpers,
  config,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "rustaceanvim";
  description = "A Neovim plugin for Rust development, providing features like LSP support, code navigation, and more.";

  maintainers = [ maintainers.GaetanLepage ];

  dependencies = [ "rust-analyzer" ];
  imports = [
    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "godot";
      packageName = "rust-analyzer";
      oldPackageName = "rustAnalyzer";
    })
  ];

  settingsOptions = import ./settings-options.nix { inherit lib helpers; };

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
  hasLuaConfig = false;
  extraConfig = cfg: {
    globals.rustaceanvim = cfg.settings;

    assertions = lib.nixvim.mkAssertions "plugins.rustaceanvim" {
      assertion = cfg.enable -> !config.plugins.lsp.servers.rust_analyzer.enable;
      message = ''
        Both `plugins.rustaceanvim.enable` and `plugins.lsp.servers.rust_analyzer.enable` are true.
        Disable one of them otherwise you will have multiple clients attached to each buffer.
      '';
    };
  };
}
