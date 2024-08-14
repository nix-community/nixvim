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
  _file = ./_shared.nix;

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

    # Use global packages by default in nixvim's submodule
    # TODO: `useGlobalPackages` option and/or deprecate using host packages?
    { programs.nixvim.nixpkgs.pkgs = lib.mkDefault pkgs; }

    # Propagate nixvim's assertions to the host modules
    (lib.mkIf cfg.enable { inherit (cfg) warnings assertions; })

    # Propagate extraFiles to the host modules
    (optionalAttrs (filesOpt != null) (
      mkIf (cfg.enable && !cfg.wrapRc) (
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
            ${filesPrefix + initName}.source = cfg.build.initFile;
          }
        )
      )
    ))
  ];
}
