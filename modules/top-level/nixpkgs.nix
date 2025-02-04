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
      type = lib.types.pkgs // {
        description = "An evaluation of Nixpkgs; the top level attribute set of packages";
      };
      example = lib.literalExpression "import <nixpkgs> { }";
      description = ''
        If set, the `pkgs` argument to all Nixvim modules is the value of this option.

        If unset, the `pkgs` argument is determined by importing `nixpkgs.source`.

        This option can be used by external applications to increase the performance of evaluation,
        or to create packages that depend on a container that should be built with the exact same
        evaluation of Nixpkgs, for example.
        Applications like this should set their default value using `lib.mkDefault`,
        so user-provided configuration can override it without using `lib`.
        E.g. Nixvim's home-manager module can re-use the `pkgs` instance from the "host" modules.

        > [!CAUTION]
        > Changing this option can lead to issues that may be difficult to debug.
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

        If the {option}`nixpkgs.pkgs` option is set, overlays specified using `nixpkgs.overlays`
        will be applied after the overlays that were already included in `nixpkgs.pkgs`.
      '';
    };

    hostPlatform = lib.mkOption {
      type = with lib.types; either str attrs;
      example = {
        system = "aarch64-linux";
      };
      # FIXME: An elaborated platform is not supported,
      # but an `apply` function is probably still needed.
      # See https://github.com/NixOS/nixpkgs/pull/376988
      defaultText = lib.literalMD ''
        - Inherited from the "host" configuration's `pkgs`
        - Or `evalNixvim`'s `system` argument
        - Otherwise, must be specified manually
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
      # FIXME: An elaborated platform is not supported,
      # but an `apply` function is probably still needed.
      # See https://github.com/NixOS/nixpkgs/pull/376988
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

        > [!CAUTION]
        > Changing this option can lead to issues that may be difficult to debug.
      '';
    };
  };

  config =
    let
      finalPkgs =
        if opt.pkgs.isDefined then
          cfg.pkgs.appendOverlays cfg.overlays
        else
          let
            args = {
              inherit (cfg) config overlays;
            };

            elaborated = builtins.mapAttrs (_: lib.systems.elaborate) {
              inherit (cfg) buildPlatform hostPlatform;
            };

            # Configure `localSystem` and `crossSystem` as required
            systemArgs =
              if lib.systems.equals elaborated.buildPlatform elaborated.hostPlatform then
                {
                  localSystem = cfg.hostPlatform;
                }
              else
                {
                  localSystem = cfg.buildPlatform;
                  crossSystem = cfg.hostPlatform;
                };
          in
          import cfg.source (args // systemArgs);
    in
    {
      # We explicitly set the default override priority, so that we do not need
      # to evaluate finalPkgs in case an override is placed on `_module.args.pkgs`.
      # After all, to determine a definition priority, we need to evaluate `._type`,
      # which is somewhat costly for Nixpkgs. With an explicit priority, we only
      # evaluate the wrapper to find out that the priority is lower, and then we
      # don't need to evaluate `finalPkgs`.
      _module.args.pkgs = lib.mkOverride lib.modules.defaultOverridePriority finalPkgs.__splicedPackages;

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
