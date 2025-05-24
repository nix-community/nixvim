{
  self,
  pkgs,
}:
self.inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  modules = [
    {
      home.username = "nixvim";
      home.homeDirectory = "/invalid/dir";

      home.stateVersion = "25.05";

      programs.nixvim = {
        enable = true;
      };

      programs.home-manager.enable = true;
    }
    self.homeModules.nixvim
  ];
}
