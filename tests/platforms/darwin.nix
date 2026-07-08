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
        imports = [
          ./module-check-enabled.nix
        ];
      };

      system.stateVersion = 5;
    }
    self.nixDarwinModules.nixvim
    ./inf-rec-lib.nix
  ];
}
