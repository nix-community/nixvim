{ inputs, system, ... }:
{
  # Import all your configuration modules here
  imports = [ ./bufferline.nix ];

  nixpkgs.pkgs = import inputs.nixpkgs { inherit system; };
}
