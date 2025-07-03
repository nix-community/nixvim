# Extract maintainers from nixvim configuration using meta.maintainers
# This script evaluates an empty nixvimConfiguration and extracts the merged maintainer information
let
  nixvim = import ../../..;
  lib = nixvim.inputs.nixpkgs.lib.extend nixvim.lib.overlay;

  emptyConfig = lib.nixvim.evalNixvim {
    modules = [ { _module.check = false; } ];
    extraSpecialArgs = {
      pkgs = null;
    };
  };

  inherit (emptyConfig.config.meta) maintainers;

  extractMaintainerObjects =
    maintainerData:
    lib.pipe maintainerData [
      lib.attrValues
      lib.concatLists
      lib.unique
    ];

  allMaintainerObjects = extractMaintainerObjects maintainers;

  allMaintainerNames = lib.filter (name: name != null) (
    map (maintainer: maintainer.github) allMaintainerObjects
  );

  nixvimMaintainers = import ../../../lib/maintainers.nix;
  nixvimMaintainerNames = lib.attrNames nixvimMaintainers;
  partitionedMaintainers = lib.partition (nameValue: lib.elem nameValue.name nixvimMaintainerNames) (
    lib.attrsToList maintainerDetails
  );

  maintainerDetails = lib.pipe allMaintainerObjects [
    (map (obj: {
      name = obj.github;
      value = obj // {
        source =
          if categorizedMaintainers.nixvim ? ${obj.github} then
            "nixvim"
          else if categorizedMaintainers.nixpkgs ? ${obj.github} then
            "nixpkgs"
          else
            throw "${obj.github} is neither a nixvim or nixpkgs maintainer";
      };
    }))
    lib.listToAttrs
  ];

  categorizedMaintainers = {
    nixvim = lib.listToAttrs partitionedMaintainers.right;
    nixpkgs = lib.listToAttrs partitionedMaintainers.wrong;
  };

  formattedMaintainers = lib.generators.toPretty {
    multiline = true;
    indent = "";
  } maintainerDetails;
in
{
  raw = maintainers;
  names = allMaintainerNames;
  details = maintainerDetails;
  categorized = categorizedMaintainers;
  formatted = formattedMaintainers;

  stats = {
    totalMaintainers = lib.length allMaintainerNames;
    nixvimMaintainers = lib.length (lib.attrNames categorizedMaintainers.nixvim);
    nixpkgsMaintainers = lib.length (lib.attrNames categorizedMaintainers.nixpkgs);
  };
}
