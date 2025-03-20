{ lib, pkgs, ... }:
let
  globalPrefix = "faust";
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "faust";
  packPathName = "faust-nvim";
  package = "faust-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # Configuration is done through globals vim.g.faust*
  hasSettings = false;
  extraOptions = {
    faustPackage = lib.mkOption {
      type = with lib.types; nullOr package;
      default = pkgs.faust;
      defaultText = lib.literalExpression "pkgs.faust";
      description = ''
        If non-null, the provided package will be used to initialize the plugin's settings:
        ```nix
          settings = {
            _examples_dir = "''${cfg.faustPackage}/share/faust/examples";
            "2appls_dir" = "''${cfg.faustPackage}/bin";
            lib_dir = "''${cfg.faustPackage}/share/faust/";
          };
        ```
      '';
    };

    settings = lib.nixvim.plugins.vim.mkSettingsOption {
      inherit globalPrefix;
      name = "faust";
      example = {
        _examples_dir = "/usr/share/faust/examples";
        "2appls_dir" = "/bin/";
        lib_dir = "/usr/share/faust/";
      };
    };
  };

  callSetup = false;
  extraConfig = cfg: {
    plugins.faust = {
      luaConfig.content = ''
        require('faust-nvim')
        require('faust-nvim').load_snippets()
      '';

      # Explicitly provide the paths to the faust components
      settings = lib.mkIf (cfg.faustPackage != null) {
        _examples_dir = lib.mkDefault "${cfg.faustPackage}/share/faust/examples";
        "2appls_dir" = lib.mkDefault (lib.getBin cfg.faustPackage);
        lib_dir = lib.mkDefault "${cfg.faustPackage}/share/faust/";
      };
    };
    globals = lib.nixvim.applyPrefixToAttrs globalPrefix cfg.settings;
  };
}
