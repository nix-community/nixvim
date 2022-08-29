{
  description = "A set of test configurations for nixvim";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixvim.url = "./..";

  outputs = { self, nixvim, nixpkgs, flake-utils, ... }:
    (flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
          build = nixvim.build pkgs;
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
          };
        })) // {
      nixosConfigurations.container = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          [
            ({ pkgs, ... }: {
              boot.isContainer = true;

              # Let 'nixos-version --json' know about the Git revision
              # of this flake.
              system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

              # Network configuration.
              networking.useDHCP = false;
              networking.firewall.allowedTCPPorts = [ 80 ];

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
