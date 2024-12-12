{
  lib,
  ...
}:
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "netman";
  originalName = "netman.nvim";
  package = "netman-nvim";

  hasSettings = false;
  callSetup = false;

  maintainers = [ lib.maintainers.khaneliman ];

  extraOptions = {
    neoTreeIntegration = lib.mkEnableOption "support for netman as a neo-tree source";
  };

  extraConfig = cfg: {
    plugins.netman.luaConfig.content = ''
      require("netman")
    '';

    plugins.neo-tree.extraSources = lib.mkIf cfg.neoTreeIntegration [ "netman.ui.neo-tree" ];
  };
}
