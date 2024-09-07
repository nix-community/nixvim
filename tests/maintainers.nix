{
  lib,
  runCommandNoCCLocal,
}:
let
  inherit (lib) attrNames filter length;
  nixvimList = import ../lib/maintainers.nix;
  nixpkgsList = lib.maintainers;
  duplicates = filter (name: nixpkgsList ? ${name}) (attrNames nixvimList);
  count = length duplicates;
in
runCommandNoCCLocal "maintainers-test" { inherit count duplicates; } ''
  if [ $count -gt 0 ]; then
    echo "$count nixvim maintainers are also nixpkgs maintainers:"
    for name in $duplicates; do
      echo "- $name"
    done
    exit 1
  fi
  touch $out
''
