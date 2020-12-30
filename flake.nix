{
  description = "A neovim configuration system for NixOS";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  inputs.neovim-nightly.url = github:nix-community/neovim-nightly-overlay;

  outputs = { self, nixpkgs, ... }@inputs: rec {
    overlays = [
      inputs.neovim-nightly.overlay
    ];

    nixosModules.nixvim = import ./nixvim.nix;

    # This is a simple container for testing
    nixosConfigurations.container = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          boot.isContainer = true;
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

          users.users.test = {
            isNormalUser = true;
            password = "";
          };

          imports = [
            nixosModules.nixvim
          ];

          nixpkgs.overlays = [ inputs.neovim-nightly.overlay ];

          programs.nixvim = {
            enable = true;
            package = pkgs.neovim-nightly;
            colorschemes.gruvbox.enable = true;

            plugins.lightline.enable = true;
          };
        })
      ];
    };
  };
}
