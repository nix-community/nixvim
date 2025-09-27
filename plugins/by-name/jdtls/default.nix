{
  lib,
  pkgs,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "jdtls";
  package = "nvim-jdtls";
  description = "Neovim plugin for the Java Development Tools Language Server (JDT LS).";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO: Added 2025-04-07; remove after 25.05
  inherit (import ./deprecations.nix lib)
    imports
    deprecateExtraOptions
    ;

  extraOptions = {
    jdtLanguageServerPackage = lib.mkPackageOption pkgs "jdt-language-server" {
      nullable = true;
    };
  };

  setup = ".start_or_attach"; # only used settingsDescription
  callSetup = false;
  extraConfig = cfg: {
    extraPackages = [ cfg.jdtLanguageServerPackage ];

    autoCmd = [
      {
        event = "FileType";
        pattern = "java";
        callback.__raw = ''
          function ()
            require('jdtls').start_or_attach(${lib.nixvim.toLuaObject cfg.settings})
          end
        '';
      }
    ];
  };

  settingsOptions = import ./settings-options.nix lib;

  settingsExample = {
    cmd = [
      "jdtls"
      { __raw = "'--jvm-arg='..vim.api.nvim_eval('g:NVIM_LOMBOK')"; }
    ];
    root_dir.__raw = ''
      vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1])
    '';
  };
}
