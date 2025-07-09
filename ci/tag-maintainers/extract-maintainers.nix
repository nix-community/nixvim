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
  relevantMaintainers = lib.concatLists (
    lib.mapAttrsToList (
      path: maintainerList:
      let
        matchingFiles = lib.filter (file: lib.hasSuffix (dirOf file) path) changedFiles;
      in
      if matchingFiles != [ ] then maintainerList else [ ]
    ) maintainers
  );

  # Extract GitHub usernames
  githubUsers = lib.concatMap (
    maintainer: if maintainer ? github then [ maintainer.github ] else [ ]
  ) relevantMaintainers;

in
lib.unique githubUsers
