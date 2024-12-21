{
  # The nixvim flake
  self,
  # Extra args for the `evalNixvim` call that produces the type for `programs.nixvim`
  evalArgs ? { },
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
    listToAttrs
    map
    mkIf
    mkMerge
    mkOption
    optionalAttrs
    setAttrByPath
    ;
  cfg = config.programs.nixvim;
  nixvimConfiguration = config.lib.nixvim.modules.evalNixvim (
    evalArgs
    // {
      modules = evalArgs.modules or [ ] ++ [
        # Use global packages by default in nixvim's submodule
        # TODO: `useGlobalPackages` option and/or deprecate using host packages?
        {
          _file = ./_shared.nix;
          nixpkgs.pkgs = lib.mkDefault pkgs;
        }
      ];
    }
  );
  extraFiles = lib.filter (file: file.enable) (lib.attrValues cfg.extraFiles);
in
{
  _file = ./_shared.nix;

  options.programs.nixvim = lib.mkOption {
    inherit (nixvimConfiguration) type;
    default = { };
  };

  # TODO: Added 2024-07-24; remove after 24.11
  imports = [
    (lib.mkRenamedOptionModule [ "nixvim" "helpers" ] [ "lib" "nixvim" ])
  ];

  config = mkMerge [
    {
      # Make our lib available to the host modules
      lib.nixvim = lib.mkDefault self.lib.nixvim;

      # Make nixvim's "extended" lib available to the host's module args
      _module.args.nixvimLib = lib.mkDefault config.lib.nixvim.extendedLib;
    }

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
