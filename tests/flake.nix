{
  description = "A set of test configurations for nixvim";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixvim.url = "./..";

  inputs.nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.05";

  outputs = { self, nixvim, nixpkgs, flake-utils, nixpkgs-stable, ... }:
    (flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
          pkgs-stable = import nixpkgs-stable { inherit system; };
          build = nixvim.build pkgs;
          build-stable = nixvim.build pkgs-stable;
        in
        rec {
          # A plain nixvim configuration
          packages = {
            plain = build { };

            # Should print "Hello!" when starting up
            hello = build {
              extraConfigLua = "print(\"Hello!\")";
            };

            simple-plugin = build {
              extraPlugins = [ pkgs.vimPlugins.vim-surround ];
            };

            gruvbox = build {
              extraPlugins = [ pkgs.vimPlugins.gruvbox ];
              colorscheme = "gruvbox";
            };

            gruvbox-module = build {
              colorschemes.gruvbox.enable = true;
            };

            treesitter = build {
              plugins.treesitter.enable = true;
            };

            treesitter-nonix = build {
              plugins.treesitter = {
                enable = true;
                nixGrammars = false;
              };
            };

            lsp-lines = build-stable {
              plugins.lsp-lines.enable = true;
            };

            issue-40 = build-stable {
              plugins = {
                nix.enable = true;
                nvim-autopairs.enable = true;

                lualine = {
                  enable = true;

                  sectionSeparators = {
                    left = "";
                    right = "";
                  };

                  componentSeparators = {
                    left = "";
                    right = "";
                  };

                  theme = "auto";
                };

                goyo = {
                  enable = true;
                  showLineNumbers = false;
                };

                lsp = {
                  enable = true;
                  servers = {
                    rust-analyzer.enable = true;
                    rnix-lsp.enable = true;
                  };
                };

              };

              options = {
                # Indentation
                autoindent = true;
                tabstop = 4;
                shiftwidth = 4;
                expandtab = true;
                backspace = "indent,eol,start";

                # Text
                showmatch = true;
                mouse = "a";
                number = true;
                relativenumber = false;
                ttyfast = true;
                clipboard = "unnamedplus";

                # Colors
                background = "dark";
                termguicolors = true;
              };
            };
          };
        })) // {
      nixosConfigurations.nixvim-machine = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ pkgs, ... }: {
            environment.systemPackages = [
              (nixvim.build pkgs { colorschemes.gruvbox.enable = true; })
            ];
          })
        ];
      };
      nixosConfigurations.container = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          [
            ({ pkgs, ... }: {
              boot.isContainer = true;

              # Let 'nixos-version --json' know about the Git revision
              # of this flake.
              system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

              imports = [
                nixvim.nixosModules.x86_64-linux.nixvim
              ];

              programs.nixvim = {
                enable = true;
                colorschemes.gruvbox.enable = true;
              };
            })
          ];
      };
    };
}
