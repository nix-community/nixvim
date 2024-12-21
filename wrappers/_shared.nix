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

  # TODO: Find a way to document the options declared here
  nixpkgsModule =
    { config, ... }:
    {
      _file = ./_shared.nix;

      options.nixpkgs = {
        useGlobalPackages = lib.mkOption {
          type = lib.types.bool;
          default = true; # TODO: Added 2024-10-20; switch to false one release after adding a deprecation warning
          description = ''
            Whether Nixvim should use the host configuration's `pkgs` instance.

            The host configuration is usually home-manager, nixos, or nix-darwin.

            When false, an instance of nixpkgs will be constructed by nixvim.
          '';
        };
      };

      config = {
        nixpkgs = {
          # Use global packages by default in nixvim's submodule
          pkgs = lib.mkIf config.nixpkgs.useGlobalPackages (lib.mkForce pkgs);

          # Inherit platform spec
          # FIXME: buildPlatform can't use option-default because it already has a default
          #        (it defaults to hostPlatform)...
          hostPlatform = lib.mkOptionDefault pkgs.stdenv.hostPlatform;
          buildPlatform = lib.mkDefault pkgs.stdenv.buildPlatform;
        };
      };
    };
  nixvimConfiguration = config.lib.nixvim.modules.evalNixvim (
    evalArgs
    // {
      modules = evalArgs.modules or [ ] ++ [
        nixpkgsModule
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
      # NOTE: user-facing so we must include the legacy `pkgs` argument
      lib.nixvim = lib.mkDefault (
        import ../lib {
          inherit lib;
          flake = self;
        }
      );

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
