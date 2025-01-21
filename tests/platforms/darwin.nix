{
  self,
  system,
}:
self.inputs.nix-darwin.lib.darwinSystem {
  modules = [
    {
      nixpkgs.hostPlatform = system;

      programs.nixvim = {
        enable = true;
      };

      system.stateVersion = 5;
    }
    self.nixDarwinModules.nixvim
  ];
}
