{ pkgsPath, ... }:
{
  imports = [
    ./context.nix
    ./nixvim-info.nix
    (pkgsPath + "/nixos/modules/misc/assertions.nix")
    (pkgsPath + "/nixos/modules/misc/meta.nix")
  ];
}
