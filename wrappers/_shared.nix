{
  # Function used to evaluate the `programs.nixvim` configuration
  extendModules,
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
  options,
  ...
}:
let
  inherit (lib)
    mkIf
    mkMerge
    optionalAttrs
    setAttrByPath
    ;

  cfg = config.programs.nixvim;
  opts = finalConfiguration.options;

  flake = lib.optionalAttrs opts.flake.isDefined cfg.flake;
  libOverlay = flake.lib.overlay or (import ../lib/overlay.nix);

  # FIXME: buildPlatform can't use mkOptionDefault because it already defaults to hostPlatform
  buildPlatformPrio = (lib.mkOptionDefault null).priority - 1;

  nixpkgsModule =
    { config, ... }:
    {
      _file = ./_shared.nix;
      nixpkgs = {
        # Use global packages in nixvim's submodule
        pkgs = lib.mkIf config.nixpkgs.useGlobalPackages (lib.mkDefault pkgs);

        # Inherit platforms
        hostPlatform = lib.mkOptionDefault pkgs.stdenv.hostPlatform.system;
        buildPlatform = lib.mkOverride buildPlatformPrio pkgs.stdenv.buildPlatform.system;
      };
    };

  baseConfiguration = extendModules {
    modules = [
      nixpkgsModule
      { disabledModules = [ "<internal:nixvim-nocheck-base-eval>" ]; }
    ];
  };

  finalConfiguration =
    options.programs.nixvim.valueMeta.configuration or (throw
      # v2 check+merge was added 2025-08-28, halfway through the 25.11 cycle
      "`${options.programs.nixvim}` was evaluated using Nixpkgs lib ${lib.trivial.release}, which does not support `valueMeta` added in Nixpkgs 25.11."
    );

  extraFiles = lib.filter (file: file.enable) (lib.attrValues cfg.extraFiles);
in
{
  _file = ./_shared.nix;

  options.programs.nixvim = lib.mkOption {
    inherit (baseConfiguration) type;
    default = { };
  };

  # TODO: Added 2024-07-24; remove after 24.11
  imports = [
    (lib.mkRenamedOptionModule [ "nixvim" "helpers" ] [ "lib" "nixvim" ])
  ];

  config = mkMerge [
    {
      # Make Nixvim's extended lib available to the host modules
      # - The `config.lib.nixvim` option is Nixvim's section of the lib
      #   (based on our flake's locked Nixpkgs lib)
      # - The `nixvimLib` arg is `lib` extended with our overlay
      #   (based on the host configuration's `lib`)
      #
      # NOTE: It is important that we use the flake-locked Nixpkgs lib,
      # so that we can safely use recently added lib features.
      # TODO: Consider deprecating `_module.args.nixvimLib`?
      lib.nixvim = lib.mkDefault finalConfiguration._module.specialArgs.lib.nixvim;
      _module.args.nixvimLib = lib.mkDefault (lib.extend libOverlay);
    }

    # Propagate nixvim's assertions to the host modules
    (lib.mkIf cfg.enable { inherit (cfg) warnings assertions; })

    # Propagate extraFiles to the host modules
    (optionalAttrs (filesOpt != null) (
      mkIf (cfg.enable && !cfg.wrapRc) (
        setAttrByPath filesOpt (
          builtins.listToAttrs (
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
