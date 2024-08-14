{
  config,
  options,
  lib,
  ...
}:
let
  cfg = config.nixpkgs;
  opt = options.nixpkgs;
in
{
  options.nixpkgs = {
    pkgs = lib.mkOption {
      # TODO:
      # defaultText = lib.literalExpression ''
      #   import "''${nixos}/.." {
      #     inherit (cfg) config overlays localSystem crossSystem;
      #   }
      # '';
      defaultText = lib.literalMD ''
        The `pkgs` inherited from your host config (i.e. NixOS, home-manager, or nix-darwin),
        or the `pkgs` supplied to `makeNixvimWithModule` when building a standalone nixvim.

        > [!CAUTION]
        > This default will be removed in a future version of nixvim
      '';
      type = lib.types.pkgs // {
        description = "An evaluation of Nixpkgs; the top level attribute set of packages";
      };
      example = lib.literalExpression "import <nixpkgs> { }";
      description = ''
        If set, the `pkgs` argument to all Nixvim modules is the value of this option.

        <!-- TODO: remove -->
        If unset, an assertion will trigger. In the future a `pkgs` instance will be constructed.

        <!--
          TODO:
          If unset, the pkgs argument is determined as shown in the default value for this option.

          TODO:
          The default value imports the Nixpkgs input specified in Nixvim's `flake.lock`.
          The `config`, `overlays`, `localSystem`, and `crossSystem` come from this option's siblings.
        -->

        This option can be used by external applications to increase the performance of evaluation,
        or to create packages that depend on a container that should be built with the exact same
        evaluation of Nixpkgs, for example.
        Applications like this should set their default value using `lib.mkDefault`,
        so user-provided configuration can override it without using `lib`.
        E.g. Nixvim's home-manager module can re-use the `pkgs` instance from the "host" modules.

        > [!NOTE]
        > Using a distinct version of Nixpkgs with Nixvim may be an unexpected source of problems.
        > Use this option with care.
      '';
    };
  };

  config = {
    # For now we only set this when `nixpkgs.pkgs` is defined
    # TODO: construct a default pkgs instance from pkgsPath and cfg options
    # https://github.com/nix-community/nixvim/issues/1784
    _module.args = lib.optionalAttrs opt.pkgs.isDefined {
      # We explicitly set the default override priority, so that we do not need
      # to evaluate finalPkgs in case an override is placed on `_module.args.pkgs`.
      # After all, to determine a definition priority, we need to evaluate `._type`,
      # which is somewhat costly for Nixpkgs. With an explicit priority, we only
      # evaluate the wrapper to find out that the priority is lower, and then we
      # don't need to evaluate `finalPkgs`.
      pkgs = lib.mkOverride lib.modules.defaultOverridePriority cfg.pkgs.__splicedPackages;
    };

    assertions = [
      {
        # TODO: Remove or rephrase once pkgs can be constructed internally
        assertion = config._module.args ? pkgs;
        message = ''
          `nixpkgs.pkgs` is not defined. In the future, this option will be optional.
          Currently a pkgs instance must be evaluated externally and assigned to `nixpkgs.pkgs` option.
        '';
      }
    ];
  };
}
