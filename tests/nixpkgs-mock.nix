# This mock nixpkgs can be used as `nixpkgs.source` in nixpkgs-module-test
# if we want/need to avoid importing & instantiating a real nixpkgs
{
  config ? { },
  ...
}:
let
  pkgs = {
    _type = "pkgs";
    __splicedPackages = pkgs;
    inherit config pkgs;
    mock = true;
  };
in
pkgs
