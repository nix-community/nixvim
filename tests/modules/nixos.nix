{
  nixvim,
  nixpkgs,
  system,
}:
nixpkgs.lib.nixosSystem {
  inherit system;

  modules = [
    {
      system.stateVersion = "23.11";
      boot.loader.systemd-boot.enable = true;
      fileSystems."/" = {
        device = "/non/existent/device";
      };

      programs.nixvim = {
        enable = true;
      };
    }
    nixvim.nixosModules.nixvim
  ];
}
