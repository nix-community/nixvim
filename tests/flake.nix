{
  description = "A set of test configurations for nixvim";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixvim.url = "./..";

  inputs.build-ts.url = "github:pta2002/build-ts-grammar.nix";
  inputs.gleam.url = "github:gleam-lang/tree-sitter-gleam";
  inputs.gleam.flake = false;

  inputs.nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.05";
  inputs.nixvim-stable = {
    url = "./..";
    inputs.nixpkgs.follows = "nixpkgs-stable";
  };

  outputs = {
    self,
    nixvim,
    nixvim-stable,
    nixpkgs,
    flake-utils,
    nixpkgs-stable,
    build-ts,
    gleam,
    ...
  }:
    (flake-utils.lib.eachDefaultSystem
      (system: let
        pkgs = import nixpkgs {inherit system;};
        pkgs-stable = import nixpkgs-stable {inherit system;};
        build = nixvim.legacyPackages.${system}.makeNixvim;
        build-stable = nixvim-stable.legacyPackages.${system}.makeNixvim;
      in rec {
        # A plain nixvim configuration
        packages = {
          plain = build {};

          # Should print "Hello!" when starting up
          hello = build {
            extraConfigLua = "print(\"Hello!\")";
          };

          simple-plugin = build {
            extraPlugins = [pkgs.vimPlugins.vim-surround];
          };

          gruvbox = build {
            extraPlugins = [pkgs.vimPlugins.gruvbox];
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
          elixir-ls = build {
            plugins.lsp.enable = true;
            plugins.lsp.servers.elixirls.enable = true;
          };

          lsp-lines = build-stable {
            plugins.lsp-lines.enable = true;
          };

          trouble = build {
            plugins.lsp = {
              enable = true;
              servers.clangd.enable = true;
            };

            plugins.trouble.enable = true;
          };

          beautysh = build {
            plugins.null-ls = {
              enable = true;
              sources.formatting.beautysh.enable = true;
            };
          };

          keymaps = build {
            maps.normal."," = "<cmd>echo \"test\"<cr>";
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

          issue-65 = build {
            colorschemes.gruvbox = {
              enable = true;
              contrastLight = "hard";
              contrastDark = "hard";
            };

            options = {
              number = true;
              shiftwidth = 2;
              tabstop = 2;
              guifont = "FiraCode\ Nerd\ Font\ Mono:h14";
            };

            plugins = {
              lsp = {
                enable = true;
                servers.rnix-lsp.enable = true;
                servers.rust-analyzer.enable = true;
                servers.jsonls.enable = true;
              };

              nvim-tree = {
                enable = true;
                openOnSetup = true;
                openOnTab = true;
              };

              telescope = {
                enable = true;
              };

              nvim-cmp = {
                formatting = {
                  format = ''
                    require("lspkind").cmp_format({
                            mode="symbol",
                            maxwidth = 50,
                            ellipsis_char = "..."
                    })
                  '';
                };

                auto_enable_sources = true;
                snippet = {
                  expand = ''
                    function(args)
                      require("luasnip").lsp_expand(args.body)
                    end
                  '';
                };
                enable = true;
                sources = [
                  {name = "nvim_lsp";}
                  {
                    name = "luasnip";
                    option = {
                      show_autosnippets = true;
                    };
                  }
                  {name = "path";}
                  {name = "buffer";}
                ];
              };
              barbar.enable = true;
            };

            globals.mapleader = " ";
            extraPlugins = with pkgs.vimPlugins; [
              which-key-nvim
              # leap-nvim
              vim-flutter
              plenary-nvim
              fidget-nvim
              luasnip
              lspkind-nvim
            ];

            # extraConfigLua = (builtins.readFile ./nvim-extra-lua.lua);
          };

          issue-71 = build {
            maps.normal."<leader>hb" = "<cmd>lua require('gitsigns').blame_line{full=true}<cr>";
          };

          lspkind = build {
            plugins = {
              lsp = {
                enable = true;
                servers.clangd.enable = true;
              };
              nvim-cmp.enable = true;
              lspkind.enable = true;
            };
          };

          highlight = build {
            options.termguicolors = true;
            highlight = {
              Normal.fg = "#ff0000";
            };
          };

          autoCmd = build {
            autoCmd = [
              {
                event = ["BufEnter" "BufWinEnter"];
                pattern = ["*.c" "*.h"];
                command = "echo 'Entering a C or C++ file'";
              }
              {
                event = "InsertEnter";
                command = "norm zz";
              }
            ];
          };

          ts-custom = build {
            plugins.treesitter = {
              enable = true;
              nixGrammars = true;
              grammarPackages = [
                (build-ts.lib.buildGrammar pkgs {
                  language = "gleam";
                  version = "0.25.0";
                  source = gleam;
                })
              ];
            };
          };
        };
      }))
    // {
      nixosConfigurations.nixvim-machine = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({pkgs, ...}: {
            environment.systemPackages = [
              (nixvim.build pkgs {colorschemes.gruvbox.enable = true;})
            ];
          })
        ];
      };
      nixosConfigurations.container = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({pkgs, ...}: {
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
