{
  self,
  system,
}:
self.inputs.nixpkgs.lib.nixosSystem {
  inherit system;

  modules = [
    {
      system.stateVersion = "24.11";
      boot.loader.systemd-boot.enable = true;
      fileSystems."/" = {
        device = "/non/existent/device";
      };

      programs.nixvim = {
        enable = true;
      };
    }
    self.nixosModules.nixvim
  ];
}
