{
  pkgs,
  config,
  lib,
  helpers,
  ...
}:
let
  inherit (lib) types mkOption;
  inherit (lib) optional optionalString optionalAttrs;
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

    package = mkOption {
      type = types.package;
      default = pkgs.neovim-unwrapped;
      description = "Neovim to use for NixVim.";
    };

    wrapRc = mkOption {
      type = types.bool;
      description = "Should the config be included in the wrapper script.";
      default = false;
    };

    finalPackage = mkOption {
      type = types.package;
      description = "Wrapped Neovim.";
      readOnly = true;
    };

    initPath = mkOption {
      type = types.str;
      description = "The path to the `init.lua` file.";
      readOnly = true;
      visible = false;
    };

    printInitPackage = mkOption {
      type = types.package;
      description = "A tool to show the content of the generated `init.lua` file.";
      readOnly = true;
      visible = false;
    };
  };

  config =
    let
      # Plugin normalization
      normalize =
        p:
        let
          defaultPlugin = {
            plugin = null;
            config = "";
            optional = false;
          };
        in
        defaultPlugin // (if p ? plugin then p else { plugin = p; });
      normalizePluginList = plugins: map normalize plugins;

      # Normalized plugin list
      normalizedPlugins = normalizePluginList config.extraPlugins;

      # Plugin list extended with dependencies
      allPlugins =
        let
          pluginWithItsDeps =
            p: [ p ] ++ builtins.concatMap pluginWithItsDeps (normalizePluginList p.plugin.dependencies or [ ]);
        in
        lib.unique (builtins.concatMap pluginWithItsDeps normalizedPlugins);

      # Separated start and opt plugins
      partitionedPlugins = builtins.partition (p: p.optional) allPlugins;
      startPlugins = partitionedPlugins.wrong;
      # Remove opt plugin dependencies since they are already available in start plugins
      optPlugins = map (
        p: p // { plugin = builtins.removeAttrs p.plugin [ "dependencies" ]; }
      ) partitionedPlugins.right;

      # Combine start plugins into a single pack
      pluginPack =
        let
          # Plugins with doc tags removed
          overriddenPlugins = map (
            plugin:
            plugin.plugin.overrideAttrs (prev: {
              nativeBuildInputs = lib.remove pkgs.vimUtils.vimGenDocHook prev.nativeBuildInputs or [ ];
              configurePhase = builtins.concatStringsSep "\n" (
                builtins.filter (s: s != ":") [
                  prev.configurePhase or ":"
                  "rm -vf doc/tags"
                ]
              );
            })
          ) startPlugins;

          # Python3 dependencies
          python3Dependencies =
            let
              deps = map (p: p.plugin.python3Dependencies or (_: [ ])) startPlugins;
            in
            ps: builtins.concatMap (f: f ps) deps;
        in
        pkgs.vimUtils.toVimPlugin (
          pkgs.buildEnv {
            name = "plugin-pack";
            paths = overriddenPlugins;
            inherit (config.performance.combinePlugins) pathsToLink;
            # Remove empty directories and activate vimGenDocHook
            postBuild = ''
              find $out -type d -empty -delete
              runHook preFixup
            '';
            passthru = {
              inherit python3Dependencies;
            };
          }
        );

      # Combined plugins
      combinedPlugins = [ (normalize pluginPack) ] ++ optPlugins;

      # Plugins to use in finalPackage
      plugins = if config.performance.combinePlugins.enable then combinedPlugins else normalizedPlugins;

      neovimConfig = pkgs.neovimUtils.makeNeovimConfig (
        {
          inherit (config)
            extraPython3Packages
            extraLuaPackages
            viAlias
            vimAlias
            withRuby
            withNodeJs
            ;
          # inherit customRC;
          inherit plugins;
        }
        # Necessary to make sure the runtime path is set properly in NixOS 22.05,
        # or more generally before the commit:
        # cda1f8ae468 - neovim: pass packpath via the wrapper
        // optionalAttrs (lib.functionArgs pkgs.neovimUtils.makeNeovimConfig ? configure) {
          configure.packages = {
            nixvim = {
              start = map (x: x.plugin) plugins;
              opt = [ ];
            };
          };
        }
      );

      customRC = helpers.concatNonEmptyLines [
        (helpers.wrapVimscriptForLua neovimConfig.neovimRcContent)
        config.content
      ];

      init = helpers.writeLua "init.lua" customRC;

      extraWrapperArgs = builtins.concatStringsSep " " (
        (optional (
          config.extraPackages != [ ]
        ) ''--prefix PATH : "${lib.makeBinPath config.extraPackages}"'')
        ++ (optional config.wrapRc ''--add-flags -u --add-flags "${init}"'')
      );

      wrappedNeovim = pkgs.wrapNeovimUnstable config.package (
        neovimConfig
        // {
          wrapperArgs = lib.escapeShellArgs neovimConfig.wrapperArgs + " " + extraWrapperArgs;
          wrapRc = false;
        }
      );
    in
    {
      type = lib.mkForce "lua";
      finalPackage = wrappedNeovim;
      initPath = "${init}";

      printInitPackage = pkgs.writeShellApplication {
        name = "nixvim-print-init";
        runtimeInputs = [ pkgs.bat ];
        text = ''
          bat --language=lua "${init}"
        '';
      };

      extraConfigLuaPre = lib.mkIf config.wrapRc ''
        -- Ignore the user lua configuration
        vim.opt.runtimepath:remove(vim.fn.stdpath('config'))              -- ~/.config/nvim
        vim.opt.runtimepath:remove(vim.fn.stdpath('config') .. "/after")  -- ~/.config/nvim/after
        vim.opt.runtimepath:remove(vim.fn.stdpath('data') .. "/site")     -- ~/.local/share/nvim/site
      '';

      extraPlugins = if config.wrapRc then [ config.filesPlugin ] else [ ];
    };
}
