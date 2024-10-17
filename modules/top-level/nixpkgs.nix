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

    overlays = lib.mkOption {
      type =
        let
          overlayType = lib.mkOptionType {
            name = "nixpkgs-overlay";
            description = "nixpkgs overlay";
            check = lib.isFunction;
            merge = lib.mergeOneOption;
          };
        in
        lib.types.listOf overlayType;
      default = [ ];
      # FIXME: use an example that is topical for vim
      example = lib.literalExpression ''
        [
          (self: super: {
            openssh = super.openssh.override {
              hpnSupport = true;
              kerberos = self.libkrb5;
            };
          })
        ]
      '';
      description = ''
        List of overlays to apply to Nixpkgs.
        This option allows modifying the Nixpkgs package set accessed through the `pkgs` module argument.

        For details, see the [Overlays chapter in the Nixpkgs manual](https://nixos.org/manual/nixpkgs/stable/#chap-overlays).

        <!-- TODO: Remove -->
        Overlays specified using the {option}`nixpkgs.overlays` option will be
        applied after the overlays that were already included in `nixpkgs.pkgs`.

        <!--
          TODO:
          If the {option}`nixpkgs.pkgs` option is set, overlays specified using `nixpkgs.overlays`
          will be applied after the overlays that were already included in `nixpkgs.pkgs`.
        -->
      '';
    };
  };

  config =
    let
      # TODO: construct a default pkgs instance from pkgsPath and cfg options
      # https://github.com/nix-community/nixvim/issues/1784

      finalPkgs =
        if opt.pkgs.isDefined then
          cfg.pkgs.appendOverlays cfg.overlays
        else
          # TODO: Remove once pkgs can be constructed internally
          throw ''
            nixvim: `nixpkgs.pkgs` is not defined. In the future, this option will be optional.
            Currently a pkgs instance must be evaluated externally and assigned to `nixpkgs.pkgs` option.
          '';
    in
    {
      # We explicitly set the default override priority, so that we do not need
      # to evaluate finalPkgs in case an override is placed on `_module.args.pkgs`.
      # After all, to determine a definition priority, we need to evaluate `._type`,
      # which is somewhat costly for Nixpkgs. With an explicit priority, we only
      # evaluate the wrapper to find out that the priority is lower, and then we
      # don't need to evaluate `finalPkgs`.
      _module.args.pkgs = lib.mkOverride lib.modules.defaultOverridePriority finalPkgs.__splicedPackages;
    };
}
