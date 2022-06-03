{
  description = "A set of test configurations for nixvim";

  inputs.nixvim.url = "./..";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixvim, nixpkgs, ... }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    rec {
      # A plain nixvim configuration
      plain = nixvim.build { };

      # Should print "Hello!" when starting up
      hello = nixvim.build {
        extraConfigLua = "print(\"Hello!\")";
      };

      simple-plugin = nixvim.build {
        extraPlugins = [ pkgs.vimPlugins.vim-surround ];
      };

      gruvbox = nixvim.build {
        extraPlugins = [ pkgs.vimPlugins.gruvbox ];
        colorscheme = "gruvbox";
      };

      gruvbox-module = nixvim.build {
        colorschemes.gruvbox.enable = true;
      };
    };
}
