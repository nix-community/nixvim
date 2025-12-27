{
  nixpkgsLib,
  runCommandLocal,
}:
let
  nixvimList = import ../lib/maintainers.nix;
  nixpkgsList = nixpkgsLib.maintainers;
  duplicates = builtins.filter (name: nixpkgsList ? ${name}) (builtins.attrNames nixvimList);
  count = builtins.length duplicates;
in
runCommandLocal "maintainers-test" { inherit count duplicates; } ''
  if [ $count -gt 0 ]; then
    echo "$count Nixvim maintainers are also nixpkgs maintainers:"
    for name in $duplicates; do
      echo "- $name"
    done
    exit 1
  fi
  touch $out
''
