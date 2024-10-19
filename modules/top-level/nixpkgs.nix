{
  config,
  options,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixpkgs;
  opt = options.nixpkgs;

  isConfig = x: builtins.isAttrs x || lib.isFunction x;

  mergeConfig =
    lhs_: rhs_:
    let
      optCall = maybeFn: x: if lib.isFunction maybeFn then maybeFn x else maybeFn;
      lhs = optCall lhs_ { inherit pkgs; };
      rhs = optCall rhs_ { inherit pkgs; };
    in
    lib.recursiveUpdate lhs rhs
    // lib.optionalAttrs (lhs ? packageOverrides) {
      packageOverrides =
        pkgs:
        optCall lhs.packageOverrides pkgs // optCall (lib.attrByPath [ "packageOverrides" ] { } rhs) pkgs;
    }
    // lib.optionalAttrs (lhs ? perlPackageOverrides) {
      perlPackageOverrides =
        pkgs:
        optCall lhs.perlPackageOverrides pkgs
        // optCall (lib.attrByPath [ "perlPackageOverrides" ] { } rhs) pkgs;
    };
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

    config = lib.mkOption {
      default = { };
      example = {
        allowBroken = true;
        allowUnfree = true;
      };
      type = lib.mkOptionType {
        name = "nixpkgs-config";
        description = "nixpkgs config";
        check = x: isConfig x || lib.traceSeqN 1 x false;
        merge = loc: lib.foldr (def: mergeConfig def.value) { };
      };
      description = ''
        Global configuration for Nixpkgs.
        The complete list of [Nixpkgs configuration options] is in the [Nixpkgs manual section on global configuration].

        Ignored when {option}`nixpkgs.pkgs` is set.

        [Nixpkgs configuration options]: https://nixos.org/manual/nixpkgs/unstable/#sec-config-options-reference
        [Nixpkgs manual section on global configuration]: https://nixos.org/manual/nixpkgs/unstable/#chap-packageconfig
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
      # First example from https://nixos.org/manual/nixpkgs/unstable/#what-if-your-favourite-vim-plugin-isnt-already-packaged
      # Second example from https://github.com/nix-community/nixvim/pull/2430#discussion_r1805700738
      # Third example from https://github.com/atimofeev/nixos-config/blob/0b1c1c47c4359d6a2aa9a5eeecb32fa89ad08c88/overlays/neovim-unwrapped.nix
      example = lib.literalExpression ''
        [

          # Add a vim plugin that isn't packaged in nixpkgs
          (final: prev: {
            easygrep = final.vimUtils.buildVimPlugin {
              name = "vim-easygrep";
              src = final.fetchFromGitHub {
                owner = "dkprice";
                repo = "vim-easygrep";
                rev = "d0c36a77cc63c22648e792796b1815b44164653a";
                hash = "sha256-bL33/S+caNmEYGcMLNCanFZyEYUOUmSsedCVBn4tV3g=";
              };
            };
          })

          # Override neovim-unwrapped with one from a flake input
          # Using `stdenv.hostPlatform` to access `system`
          (final: prev: {
            neovim-unwrapped =
              inputs.neovim-nightly-overlay.packages.''${final.stdenv.hostPlatform.system}.default;
          })

          # Override neovim-unwrapped to tweak its desktop entry
          (final: prev: {
            neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (old: {
              postInstall = old.postInstall or "" + '''
                substituteInPlace $out/share/applications/nvim.desktop \
                  --replace "TryExec=nvim" "" \
                  --replace "Terminal=true" "Terminal=false" \
                  --replace "Exec=nvim %F" "Exec=kitty -e nvim %F"
              ''';
            });
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

    hostPlatform = lib.mkOption {
      type = with lib.types; either str attrs;
      example = {
        system = "aarch64-linux";
      };
      apply = lib.systems.elaborate;
      defaultText = lib.literalMD ''
        - Inherited from the "host" configuration's `pkgs`
        - Must be specified manually when building a standalone nixvim
      '';
      description = ''
        Specifies the platform where the Nixvim configuration will run.

        To cross-compile, also set `nixpkgs.buildPlatform`.

        Ignored when `nixpkgs.pkgs` is set.
      '';
    };

    buildPlatform = lib.mkOption {
      type = with lib.types; either str attrs;
      default = cfg.hostPlatform;
      example = {
        system = "x86_64-linux";
      };
      apply =
        value:
        let
          elaborated = lib.systems.elaborate value;
        in
        # If equivalent to `hostPlatform`, make it actually identical so that `==` can be used
        # See https://github.com/NixOS/nixpkgs/issues/278001
        if lib.systems.equals elaborated cfg.hostPlatform then cfg.hostPlatform else elaborated;
      defaultText = lib.literalMD ''
        Inherited from the "host" configuration's `pkgs`.
        Or `config.nixpkgs.hostPlatform` when building a standalone nixvim.
      '';
      description = ''
        Specifies the platform on which Nixvim should be built.
        By default, Nixvim is built on the system where it runs, but you can change where it's built.
        Setting this option will cause Nixvim to be cross-compiled.

        Ignored when `nixpkgs.pkgs` is set.
      '';
    };

    # NOTE: This is a nixvim-specific option; there's no equivalent in nixos
    source = lib.mkOption {
      type = lib.types.path;
      default = config.flake.inputs.nixpkgs;
      defaultText = lib.literalMD "Nixvim's flake `input.nixpkgs`";
      description = ''
        The path to import Nixpkgs from.

        Ignored when `nixpkgs.pkgs` is set.
      '';

      # FIXME: This is a stub option for now
      internal = true;
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

      # FIXME: This is a stub option for now
      warnings = lib.optional (
        opt.source.isDefined && opt.source.highestPrio < (lib.mkOptionDefault null).priority
      ) "Defining the option `nixpkgs.source` currently has no effect";

      assertions = [
        {
          assertion = opt.pkgs.isDefined -> cfg.config == { };
          message = ''
            Your system configures nixpkgs with an externally created instance.
            `nixpkgs.config` options should be passed when creating the instance instead.

            Current value:
            ${lib.generators.toPretty { multiline = true; } cfg.config}

            Defined in:
            ${lib.concatMapStringsSep "\n" (file: "  - ${file}") opt.config.files}
          '';
        }
      ];
    };
}
