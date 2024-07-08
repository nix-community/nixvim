{
  # Option path where extraFiles should go
  filesOpt ? null,
  # Filepath prefix to apply to extraFiles
  filesPrefix ? "nvim/",
  # Filepath to use when adding `cfg.initPath` to `filesOpt`
  # Is prefixed with `filesPrefix`
  initName ? "init.lua",
}:
{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    isAttrs
    listToAttrs
    map
    mkIf
    mkMerge
    mkOption
    mkOptionType
    optionalAttrs
    setAttrByPath
    ;
  cfg = config.programs.nixvim;
  extraFiles = lib.filter (file: file.enable) (lib.attrValues cfg.extraFiles);
in
{
  options = {
    nixvim.helpers = mkOption {
      type = mkOptionType {
        name = "helpers";
        description = "Helpers that can be used when writing nixvim configs";
        check = isAttrs;
      };
      description = "Use this option to access the helpers";
    };
  };

  config = mkMerge [
    # Make our lib available to the host modules
    { nixvim.helpers = lib.mkDefault (import ../lib/helpers.nix { inherit pkgs lib; }); }
    # Propagate extraFiles to the host modules
    (optionalAttrs (filesOpt != null) (
      mkIf (!cfg.wrapRc) (
        setAttrByPath filesOpt (
          listToAttrs (
            map (
              { target, source, ... }:
              {
                name = filesPrefix + target;
                value = {
                  inherit source;
                };
              }
            ) extraFiles
          )
          // {
            ${filesPrefix + initName}.source = cfg.initPath;
          }
        )
      )
    ))
  ];
}
