{
  lib,
  nixpkgsLib,
  runCommandLocal,
}:
let
  inherit (lib) attrNames filter length;
  nixvimList = import ../lib/maintainers.nix;
  nixpkgsList = nixpkgsLib.maintainers;
  duplicates = filter (name: nixpkgsList ? ${name}) (attrNames nixvimList);
  count = length duplicates;
in
runCommandLocal "maintainers-test" { inherit count duplicates; } ''
  if [ $count -gt 0 ]; then
    echo "$count nixvim maintainers are also nixpkgs maintainers:"
    for name in $duplicates; do
      echo "- $name"
    done
    exit 1
  fi
  touch $out
''
