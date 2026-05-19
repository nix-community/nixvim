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

  extraOptions = {
    jdtLanguageServerPackage = lib.mkPackageOption pkgs "jdt-language-server" {
      nullable = true;
    };
  };

  settingsDescription = "LSP configuration passed to `vim.lsp.config('jdtls', ...)`.";
  callSetup = false;
  extraConfig = cfg: opts: {
    extraPackages = [ cfg.jdtLanguageServerPackage ];

    lsp.servers.jdtls = {
      enable = lib.mkDefault true;
      config = lib.mkDerivedConfig opts.settings lib.id;
    };
  };

  settingsOptions = import ./settings-options.nix lib;

  settingsExample = {
    cmd = [
      "jdtls"
      { __raw = "'--jvm-arg='..(vim.g.NVIM_LOMBOK or '')"; }
    ];
    root_dir.__raw = ''
      vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1])
    '';
  };
}
