{
  nixvim,
  pkgs,
  home-manager,
}:
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  modules = [
    {
      home.username = "nixvim";
      home.homeDirectory = "/invalid/dir";

      home.stateVersion = "23.05";

      programs.nixvim = {
        enable = true;
      };

      programs.home-manager.enable = true;
    }
    nixvim.homeManagerModules.nixvim
  ];
}
