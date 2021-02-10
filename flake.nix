{
  description = "A neovim configuration system for NixOS";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
  inputs.neovim-nightly.url = github:nix-community/neovim-nightly-overlay;

  outputs = { self, nixpkgs, ... }@inputs: rec {
    overlays = [
      inputs.neovim-nightly.overlay
    ];

    nixosModules.nixvim = import ./nixvim.nix { nixos = true; };
    homeManagerModules.nixvim = import ./nixvim.nix { homeManager = true; };
    nixOnDroidModules.nixvim = import ./nixvim.nix { nixOnDroid = true; };

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
            colorschemes.base16 = {
              enable = true;
              colorscheme = "ocean";
            };

            options.number = true;

            maps.normalVisualOp."ç" = ":";

            plugins.airline = {
              enable = true;
              powerline = true;
            };

            plugins.undotree.enable = true;
            plugins.gitgutter.enable = true;
            plugins.commentary.enable = true;

            plugins.lsp = {
              enable = true;
              servers.clangd.enable = true;
            };

            plugins.treesitter.enable = true;
          };
        })
      ];
    };
  };
}
