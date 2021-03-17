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
            colorschemes.gruvbox = {
              enable = true;
            };

            extraPlugins = [
              pkgs.vimPlugins.vim-nix
            ];

            options.number = true;
            options.mouse = "a";

            maps.normalVisualOp."ç" = ":";

            plugins.airline = {
              enable = true;
              powerline = true;
            };

            plugins.undotree.enable = true;
            plugins.gitgutter.enable = true;
            plugins.commentary.enable = true;
            plugins.startify = {
              enable = true;
              useUnicode = true;
            };
            plugins.goyo = {
              enable = true;
              showLineNumbers = true;
            };

            plugins.lsp = {
              enable = true;
              servers.clangd.enable = true;
            };

            plugins.telescope = {
              enable = true;
              extensions = {
                frecency.enable = true;
              };
            };

            globals = {
              vimsyn_embed = "l";
              mapleader = " ";
            };

            plugins.lspsaga.enable = true;

            plugins.treesitter.enable = true;
          };
        })
      ];
    };
  };
}
