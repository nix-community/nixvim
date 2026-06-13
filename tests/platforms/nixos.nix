{
  self,
  system,
}:
self.inputs.nixpkgs.lib.nixosSystem {
  inherit system;

  modules = [
    {
      system.stateVersion = "25.05";
      boot.loader.systemd-boot.enable = true;
      fileSystems."/" = {
        fsType = "none";
        device = "/non/existent/device";
      };

      programs.nixvim = {
        enable = true;
        imports = [
          ./module-check-enabled.nix
        ];
      };
    }
    self.nixosModules.nixvim
    ./inf-rec-lib.nix
  ];
}
