{
  description = "Private inputs for development purposes. These are used by the top level flake in the `dev` partition, but do not appear in consumers' lock files.";

  inputs = {
    # NOTE: Use a different name to the root flake's inputs.nixpkgs to avoid shadowing it.
    # NOTE: The only reason we specify a nixpkgs input at all here, is so the other inputs can follow it.
    # TODO: Once nix 2.26 is more prevalent, follow the root flake's inputs using a "path:../.." input.
    dev-nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # flake-compat is used by the root `default.nix` to allow non-flake users to import nixvim
    #
    # The pinned PR resolves an issue with shallow clones, such as those used by CI.
    flake-compat.url = "github:NixOS/flake-compat?ref=pull/75/merge";

    # keep-sorted start block=yes newline_separated=yes
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "dev-nixpkgs";
    };

    git-hooks = {
      # Pin to commit before https://github.com/cachix/git-hooks.nix/pull/664
      # rumdl not available in pkgs
      url = "github:cachix/git-hooks.nix/50b9238891e388c9fdc6a5c49e49c42533a1b5ce";
      inputs.nixpkgs.follows = "dev-nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "dev-nixpkgs";
    };

    nix-darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.05";
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
