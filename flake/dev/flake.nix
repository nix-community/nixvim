{
  description = "Private inputs for development purposes. These are used by the top level flake in the `dev` partition, but do not appear in consumers' lock files.";

  inputs = {
    # NOTE: Use a different name to the root flake's inputs.nixpkgs to avoid shadowing it.
    # NOTE: The only reason we specify a nixpkgs input at all here, is so the other inputs can follow it.
    # TODO: Once nix 2.26 is more prevalent, follow the root flake's inputs using a "path:../.." input.
    dev-nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # flake-compat is used by the root `default.nix` to allow non-flake users to import nixvim
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";

    # keep-sorted start block=yes newline_separated=yes
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "dev-nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "dev-nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "dev-nixpkgs";
    };

    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "dev-nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "dev-nixpkgs";
    };

    # keep-sorted end
  };

  # This flake is only used for its inputs.
  outputs = inputs: { };
}
