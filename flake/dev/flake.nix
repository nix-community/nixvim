{
  description = "Private inputs for development purposes. These are used by the top level flake in the `dev` partition, but do not appear in consumers' lock files.";

  inputs = {
    # Nix 2.26 improved support for relative path flake inputs.
    # This dev-flake is only evaluated by flake-parts' flake-compat,
    # and is only managed by our update CI, so we can safely rely on it.
    nixvim.url = ../..;

    # flake-compat is used by the root `default.nix` to allow non-flake users to import nixvim
    flake-compat = {
      url = "github:NixOS/flake-compat";
      flake = false;
    };

    # keep-sorted start block=yes newline_separated=yes
    devshell = {
      url = "github:numtide/devshell";
      flake = false;
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      flake = false;
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      flake = false;
    };

    nuschtosSearch = {
      url = "github:NuschtOS/search";
      inputs.nixpkgs.follows = "nixvim/nixpkgs";
      inputs.flake-utils.inputs.systems.follows = "nixvim/systems";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixvim/nixpkgs";
    };

    # keep-sorted end
  };

  # This flake is only used for its inputs.
  outputs = inputs: { };
}
