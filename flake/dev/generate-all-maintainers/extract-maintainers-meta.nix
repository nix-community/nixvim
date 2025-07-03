# Extract maintainers from nixvim configuration using meta.maintainers
# This script evaluates an empty nixvimConfiguration and extracts the merged maintainer information
let
  nixvim = import ../../..;
  pkgs = import <nixpkgs> { };
  lib = pkgs.lib.extend nixvim.lib.overlay;

  emptyConfig = lib.nixvim.evalNixvim {
    modules = [ ];
    extraSpecialArgs = { };
    system = "x86_64-linux";
  };

  inherit (emptyConfig.config.meta) maintainers;

  extractMaintainerObjects = maintainerData: lib.unique (lib.flatten (lib.attrValues maintainerData));

  allMaintainerObjects = extractMaintainerObjects maintainers;

  getMaintainerName =
    maintainer:
    if lib.hasAttr "github" maintainer then
      maintainer.github
    else if lib.hasAttr "name" maintainer then
      maintainer.name
    else
      null;

  allMaintainerNames = lib.filter (name: name != null) (map getMaintainerName allMaintainerObjects);

  maintainerDetails = lib.listToAttrs (
    map (obj: {
      name = getMaintainerName obj;
      value = obj;
    }) (lib.filter (obj: getMaintainerName obj != null) allMaintainerObjects)
  );
  nixvimMaintainers = import ../../../lib/maintainers.nix;
  nixvimMaintainerNames = lib.attrNames nixvimMaintainers;
  categorizedMaintainers = {
    nixvim = lib.filterAttrs (name: _: lib.elem name nixvimMaintainerNames) maintainerDetails;
    nixpkgs = lib.filterAttrs (name: _: !(lib.elem name nixvimMaintainerNames)) maintainerDetails;
  };

in
{
  raw = maintainers;
  names = allMaintainerNames;
  details = maintainerDetails;
  categorized = categorizedMaintainers;

  stats = {
    totalFiles = lib.length (lib.attrNames maintainers);
    totalMaintainers = lib.length allMaintainerNames;
    nixvimMaintainers = lib.length (lib.attrNames categorizedMaintainers.nixvim);
    nixpkgsMaintainers = lib.length (lib.attrNames categorizedMaintainers.nixpkgs);
  };
}
