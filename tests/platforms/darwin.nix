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

      # TODO: added 2026-07-05:
      # Workaround for https://github.com/nix-darwin/nix-darwin/issues/1817
      documentation.enable = false;
      system.tools.darwin-uninstaller.enable = false;

      system.stateVersion = 5;
    }
    self.nixDarwinModules.nixvim
    ./inf-rec-lib.nix
  ];
}
