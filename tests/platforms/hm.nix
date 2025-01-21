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

      home.stateVersion = "24.11";

      programs.nixvim = {
        enable = true;
      };

      programs.home-manager.enable = true;
    }
    self.homeManagerModules.nixvim
  ];
}
