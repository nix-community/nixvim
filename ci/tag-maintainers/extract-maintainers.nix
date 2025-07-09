{
  nixvim ? import ../..,
  lib ? nixvim.inputs.nixpkgs.lib,
  changedFilesJson ? throw "provide either changedFiles or changedFilesJson",
  changedFiles ? builtins.fromJSON changedFilesJson,
}:
let
  emptyConfig = nixvim.lib.nixvim.evalNixvim {
    modules = [ { _module.check = false; } ];
    extraSpecialArgs.pkgs = null;
  };
  inherit (emptyConfig.config.meta) maintainers;

  # Find maintainers for files that match changed plugin directories
  relevantMaintainers = lib.pipe maintainers [
    (lib.filterAttrs (path: _: lib.any (file: lib.hasSuffix (dirOf file) path) changedFiles))
    lib.attrValues
    lib.concatLists
    lib.unique
  ];

  # Extract GitHub usernames
  githubUsers = lib.pipe relevantMaintainers [
    (lib.filter (maintainer: maintainer ? github))
    (map (maintainer: maintainer.github))
    lib.unique
  ];

in
githubUsers
