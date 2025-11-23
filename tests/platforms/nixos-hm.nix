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
        device = "/non/existent/device";
      };

      users.users.nixvim = {
        description = "Nixvim User";
        initialPassword = "password";
        home = "/invalid/dir";
        isNormalUser = true;
      };

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.nixvim = {
          home.stateVersion = "25.05";

          programs.nixvim = {
            enable = true;
          };

          imports = [ self.homeModules.nixvim ];
        };
      };
    }
    self.inputs.home-manager.nixosModules.home-manager
  ];
}
