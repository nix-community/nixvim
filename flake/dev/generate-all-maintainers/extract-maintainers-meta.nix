# Extract maintainers from nixvim configuration using meta.maintainers
# This script evaluates an empty nixvimConfiguration and extracts the merged maintainer information
let
  nixvim = import ../../..;
  lib = nixvim.inputs.nixpkgs.lib.extend nixvim.lib.overlay;

  emptyConfig = lib.nixvim.evalNixvim {
    modules = [ ];
    extraSpecialArgs = { };
    system = "x86_64-linux";
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

  getMaintainerName = maintainer: maintainer.github or maintainer.name or null;

  allMaintainerNames = lib.filter (name: name != null) (map getMaintainerName allMaintainerObjects);

  maintainerDetails = lib.pipe allMaintainerObjects [
    (lib.filter (obj: getMaintainerName obj != null))
    (map (obj: {
      name = getMaintainerName obj;
      value = obj;
    }))
    lib.listToAttrs
  ];

  nixvimMaintainers = import ../../../lib/maintainers.nix;
  nixvimMaintainerNames = lib.attrNames nixvimMaintainers;
  partitionedMaintainers = lib.partition (nameValue: lib.elem nameValue.name nixvimMaintainerNames) (
    lib.attrsToList maintainerDetails
  );
  categorizedMaintainers = {
    nixvim = lib.listToAttrs partitionedMaintainers.right;
    nixpkgs = lib.listToAttrs partitionedMaintainers.wrong;
  };

  formatMaintainer =
    name: info: source:
    let
      # Handle identifiers that start with numbers or contain invalid characters
      quotedName =
        if lib.match "[0-9].*" name != null || lib.match "[^a-zA-Z0-9_-].*" name != null then
          ''"${name}"''
        else
          name;

      # Filter out internal fields
      filteredInfo = lib.filterAttrs (k: v: !lib.hasPrefix "_" k) info;
    in
    "  # ${source}\n  ${quotedName} = ${
        lib.generators.toPretty {
          multiline = true;
          indent = "    ";
        } filteredInfo
      };";

  formatAllMaintainers =
    let
      nixvimEntries = lib.mapAttrsToList (
        name: info: formatMaintainer name info "nixvim"
      ) categorizedMaintainers.nixvim;
      nixpkgsEntries = lib.mapAttrsToList (
        name: info: formatMaintainer name info "nixpkgs"
      ) categorizedMaintainers.nixpkgs;
    in
    lib.concatStringsSep "\n" (nixvimEntries ++ nixpkgsEntries);

in
{
  raw = maintainers;
  names = allMaintainerNames;
  details = maintainerDetails;
  categorized = categorizedMaintainers;
  formatted = formatAllMaintainers;

  stats = {
    totalFiles = lib.length (lib.attrNames maintainers);
    totalMaintainers = lib.length allMaintainerNames;
    nixvimMaintainers = lib.length (lib.attrNames categorizedMaintainers.nixvim);
    nixpkgsMaintainers = lib.length (lib.attrNames categorizedMaintainers.nixpkgs);
  };
}
