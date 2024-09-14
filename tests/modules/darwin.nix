{
  nixvim,
  system,
  nix-darwin,
}:
nix-darwin.lib.darwinSystem {
  modules = [
    {
      nixpkgs.hostPlatform = system;

      programs.nixvim = {
        enable = true;
      };

      system.stateVersion = 5;
    }
    nixvim.nixDarwinModules.nixvim
  ];
}
