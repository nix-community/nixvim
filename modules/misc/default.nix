{ defaultPkgs, ... }:
let
  # We can't use config._module.args to define imports,
  # so we're forced to use specialArgs.defaultPkgs's path
  nixosModules = defaultPkgs.path + "/nixos/modules/";
in
{
  imports = [
    ./nixpkgs.nix
    ./nixvim-info.nix
    (nixosModules + "/misc/assertions.nix")
    (nixosModules + "/misc/meta.nix")
  ];
}
