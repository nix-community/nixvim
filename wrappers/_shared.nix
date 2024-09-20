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
  # TODO: Added 2024-07-24; remove after 24.11
  imports = [
    (lib.mkRenamedOptionModule
      [
        "nixvim"
        "helpers"
      ]
      [
        "lib"
        "nixvim"
      ]
    )
  ];

  config = mkMerge [
    {
      # Make our lib available to the host modules
      # NOTE: user-facing so we must include the legacy `pkgs` argument
      lib.nixvim = lib.mkDefault (import ../lib { inherit pkgs lib; });

      # Make nixvim's "extended" lib available to the host's module args
      _module.args.nixvimLib = lib.mkDefault config.lib.nixvim.extendedLib;
    }

    # Propagate extraFiles to the host modules
    (optionalAttrs (filesOpt != null) (
      mkIf (!cfg.wrapRc) (
        setAttrByPath filesOpt (
          listToAttrs (
            map (
              { target, finalSource, ... }:
              {
                name = filesPrefix + target;
                value = {
                  source = finalSource;
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
