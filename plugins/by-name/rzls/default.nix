{ config, lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "rzls";
  package = "rzls-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  dependencies = [
    "rzls"
  ];

  extraOptions = {
    enableRazorFiletypeAssociation = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Sets up the filetype association of `.cshtml` and `razor` files to trigger treesitter
        and lsp support for razor functionality.
      '';
    };
  };

  extraConfig = cfg: {
    assertions = lib.nixvim.mkAssertions "plugins.rzls" {
      assertion = config.plugins.roslyn.enable;
      message = ''
        You must enable `plugins.roslyn` for general functionality in `rzls.nvim`.
      '';
    };

    filetype = lib.mkIf cfg.enableRazorFiletypeAssociation {
      extension = {
        razor = "razor";
        cshtml = "razor";
      };
    };

    plugins.rzls.settings.path = lib.mkOptionDefault (lib.getExe config.dependencies.rzls.package);
  };
}
