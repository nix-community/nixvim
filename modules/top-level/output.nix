{
  pkgs,
  config,
  lib,
  helpers,
  ...
}:
let
  inherit (lib) types mkOption mkPackageOption;
  inherit (lib) optional optionalAttrs;
  builders = lib.nixvim.builders.withPkgs pkgs;
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  options = {
    viAlias = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Symlink `vi` to `nvim` binary.
      '';
    };

    vimAlias = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Symlink `vim` to `nvim` binary.
      '';
    };

    withRuby = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Ruby provider.";
    };

    withNodeJs = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Node provider.";
    };

    withPerl = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Perl provider.";
    };

    withPython3 = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Python 3 provider.";
    };

    package = mkPackageOption pkgs "Neovim" {
      default = "neovim-unwrapped";
    };

    wrapRc = mkOption {
      type = types.bool;
      description = ''
        Whether the config will be included in the wrapper script.

        When enabled, the nixvim config will be passed to `nvim` using the `-u` option.
      '';
      defaultText = lib.literalMD ''
        Configured by your installation method: `false` when using the home-manager module, `true` otherwise.
      '';
    };

    impureRtp = mkOption {
      type = types.bool;
      description = ''
        Whether to keep the (impure) nvim config directory in the runtimepath.

        If disabled, the XDG config dirs `nvim` and `nvim/after` will be removed from the runtimepath.
      '';
      defaultText = lib.literalMD ''
        Configured by your installation method: `true` when using the home-manager module, `false` otherwise.
      '';
    };

    enablePrintInit = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = ''
        Install a tool that shows the content of the generated `init.lua` file.

        Run it using `${config.build.printInitPackage.meta.mainProgram}`.
      '';
    };

    build = {
      # TODO: `standalonePackage`; i.e. package + printInitPackage + man-docs bundled together

      package = mkOption {
        type = types.package;
        description = ''
          Wrapped Neovim.

          > [!NOTE]
          > Evaluating this option will also check `assertions` and print any `warnings`.
          > If this is not desired, you can use `build.packageUnchecked` instead.
        '';
        readOnly = true;
        defaultText = lib.literalExpression "config.build.packageUnchecked";
        apply =
          let
            assertions = builtins.concatMap (x: lib.optional (!x.assertion) x.message) config.assertions;
          in
          if assertions != [ ] then
            throw "\nFailed assertions:\n${lib.concatMapStringsSep "\n" (msg: "- ${msg}") assertions}"
          else
            lib.showWarnings config.warnings;
      };

      packageUnchecked = mkOption {
        type = types.package;
        description = ''
          Wrapped Neovim (without checking warnings or assertions).
        '';
        readOnly = true;
      };

      nvimPackage = mkOption {
        type = types.package;
        description = ''
          Wrapped Neovim (without man-docs, printInitPackage, etc).
        '';
        readOnly = true;
        internal = true;
      };

      initFile = mkOption {
        type = types.path;
        description = ''
          The generated `init.lua` file.

          > [!NOTE]
          > If `performance.byteCompileLua` is enabled, this file may not contain human-readable lua source code.
          > Consider using `build.initSource` instead.
        '';
        readOnly = true;
        visible = false;
      };

      initSource = mkOption {
        type = types.path;
        description = ''
          The generated `init.lua` source file.

          This is usually identical to `build.initFile`, however if `performance.byteCompileLua` is enabled,
          this option will refer to the un-compiled lua source file.
        '';
        readOnly = true;
        visible = false;
      };

      printInitPackage = mkOption {
        type = types.package;
        description = ''
          A tool to show the content of the generated `init.lua` file.
          Run using `${config.build.printInitPackage.meta.mainProgram}`.
        '';
        readOnly = true;
        visible = false;
      };

      manDocsPackage = mkOption {
        type = types.package;
        defaultText = lib.literalMD "`packages.<system>.man-docs` from Nixvim's flake";
        description = ''
          Nixvim's manpage documentation.
        '';
        readOnly = true;
        visible = false;
      };
    };
  };

  config =
    let
      # Optionally byte compile lua library
      inherit (pkgs.callPackage ./plugins/byte-compile-lua-lib.nix { inherit lib; })
        byteCompileLuaPackages
        ;
      extraLuaPackages =
        if config.performance.byteCompileLua.enable && config.performance.byteCompileLua.luaLib then
          ps: byteCompileLuaPackages (config.extraLuaPackages ps)
        else
          config.extraLuaPackages;

      neovimConfig = pkgs.neovimUtils.makeNeovimConfig (
        {
          inherit extraLuaPackages;
          inherit (config)
            extraPython3Packages
            viAlias
            vimAlias
            withRuby
            withNodeJs
            withPerl
            withPython3
            ;
          # inherit customRC;
          inherit (config.build) plugins;
        }
        # Necessary to make sure the runtime path is set properly in NixOS 22.05,
        # or more generally before the commit:
        # cda1f8ae468 - neovim: pass packpath via the wrapper
        // optionalAttrs (lib.functionArgs pkgs.neovimUtils.makeNeovimConfig ? configure) {
          configure.packages = {
            nixvim = {
              start = map (x: x.plugin) config.build.plugins;
              opt = [ ];
            };
          };
        }
      );

      # TODO: 2025-01-06
      # Wait for user feedback on disabling the fixup phase.
      # Ideally this will be upstreamed to nixpkgs.
      # See https://github.com/nix-community/nixvim/pull/3660#discussion_r2326250439
      wrappedNeovim = (pkgs.wrapNeovimUnstable package neovimConfig).overrideAttrs {
        dontFixup = true;
      };

      customRC = helpers.concatNonEmptyLines [
        (helpers.wrapVimscriptForLua wrappedNeovim.initRc)
        config.content
      ];

      initSource = builders.writeLua "init.lua" customRC;
      initByteCompiled = builders.writeByteCompiledLua "init.lua" customRC;
      initFile =
        if
          config.type == "lua"
          && config.performance.byteCompileLua.enable
          && config.performance.byteCompileLua.initLua
        then
          initByteCompiled
        else
          initSource;

      extraWrapperArgs = builtins.concatStringsSep " " (
        # Setting environment variables in the wrapper
        (lib.mapAttrsToList (
          name: value:
          lib.escapeShellArgs [
            "--set"
            name
            value
          ]
        ) config.env)
        ++ (optional (
          config.extraPackages != [ ]
        ) ''--prefix PATH : "${lib.makeBinPath config.extraPackages}"'')
        ++ (optional (
          config.extraPackagesAfter != [ ]
        ) ''--suffix PATH : "${lib.makeBinPath config.extraPackagesAfter}"'')
        ++ (optional config.wrapRc ''--add-flags -u --add-flags "${initFile}"'')
      );

      package =
        if config.performance.byteCompileLua.enable && config.performance.byteCompileLua.nvimRuntime then
          # Using symlinkJoin to avoid rebuilding neovim
          pkgs.symlinkJoin {
            name = "neovim-byte-compiled-${lib.getVersion config.package}";
            paths = [ config.package ];
            # Required attributes from original neovim package
            inherit (config.package) lua meta;
            nativeBuildInputs = [ builders.byteCompileLuaHook ];
            postBuild = ''
              # Replace Nvim's binary symlink with a regular file,
              # or Nvim will use original runtime directory
              rm $out/bin/nvim
              cp ${config.package}/bin/nvim $out/bin/nvim

              runHook postFixup
            '';
          }
        else
          config.package;
    in
    {
      build = {
        inherit initFile initSource;
        package = config.build.packageUnchecked;

        nvimPackage = wrappedNeovim.override (prev: {
          wrapperArgs =
            (if lib.isString prev.wrapperArgs then prev.wrapperArgs else lib.escapeShellArgs prev.wrapperArgs)
            + " "
            + extraWrapperArgs;
          wrapRc = false;
        });

        packageUnchecked = pkgs.symlinkJoin {
          name = "nixvim";
          paths =
            with config.build;
            [
              nvimPackage
            ]
            ++ lib.optionals config.enableMan [
              manDocsPackage
            ]
            ++ lib.optionals config.enablePrintInit [
              printInitPackage
            ];
          meta.mainProgram = "nvim";
        };

        printInitPackage = pkgs.writeShellApplication {
          name = "nixvim-print-init";
          runtimeInputs = [
            pkgs.bat
            pkgs.coreutils
            pkgs.which
            pkgs.gnused
            pkgs.gnugrep
          ];
          text = ''
            INIT_PATH=$(tail -n1 "$(which nvim)" | sed "s/ /\n/g" | grep "init.lua") ||
              {
                echo "init.lua not found";
                exit 1;
              }
            readonly INIT_PATH

            grep "Nixvim's internal module table" "$INIT_PATH" > /dev/null || {
              echo "init.lua found, but it was not made by Nixvim";
              exit 1;
            };

            bat --language=lua "$INIT_PATH"
          '';
        };

        manDocsPackage = config.flake.packages.${system}.man-docs;
      };

      # Set `wrapRc` and `impureRtp`s option defaults with even lower priority than `mkOptionDefault`
      wrapRc = lib.mkOverride 1501 true;
      impureRtp = lib.mkOverride 1501 false;

      extraConfigLuaPre = lib.mkOrder 100 (
        lib.concatStringsSep "\n" (
          lib.optional (!config.impureRtp) ''
            -- Ignore the user lua configuration
            vim.opt.runtimepath:remove(vim.fn.stdpath('config'))              -- ~/.config/nvim
            vim.opt.runtimepath:remove(vim.fn.stdpath('config') .. "/after")  -- ~/.config/nvim/after
          ''
          # Add a global table at start of init
          ++ lib.singleton ''
            -- Nixvim's internal module table
            -- Can be used to share code throughout init.lua
            local _M = {}
          ''
        )
      );

      extraPlugins = lib.mkIf config.wrapRc [ config.build.extraFiles ];
    };
}
