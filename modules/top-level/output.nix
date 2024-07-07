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
      # Plugin list extended with dependencies
      allPlugins =
        let
          pluginWithItsDeps = p: [ p ] ++ builtins.concatMap pluginWithItsDeps p.dependencies or [ ];
        in
        lib.unique (builtins.concatMap pluginWithItsDeps config.extraPlugins);

      # All plugins with doc tags removed
      allPluginsOverridden = map (
        plugin:
        plugin.overrideAttrs (prev: {
          nativeBuildInputs = lib.remove pkgs.vimUtils.vimGenDocHook prev.nativeBuildInputs or [ ];
          configurePhase = builtins.concatStringsSep "\n" (
            builtins.filter (s: s != ":") [
              prev.configurePhase or ":"
              "rm -vf doc/tags"
            ]
          );
        })
      ) allPlugins;

      # Combine all plugins into a single pack
      pluginPack = pkgs.vimUtils.toVimPlugin (
        pkgs.buildEnv {
          name = "plugin-pack";
          paths = allPluginsOverridden;
          inherit (config.performance.combinePlugins) pathsToLink;
          # Remove empty directories and activate vimGenDocHook
          postBuild = ''
            find $out -type d -empty -delete
            runHook preFixup
          '';
        }
      );

      # Combined plugins
      combinedPlugins = [ pluginPack ];

      # Plugins to use in finalPackage
      plugins = if config.performance.combinePlugins.enable then combinedPlugins else config.extraPlugins;

      defaultPlugin = {
        plugin = null;
        config = "";
        optional = false;
      };

      normalizedPlugins = map (x: defaultPlugin // (if x ? plugin then x else { plugin = x; })) plugins;

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
          plugins = normalizedPlugins;
        }
        # Necessary to make sure the runtime path is set properly in NixOS 22.05,
        # or more generally before the commit:
        # cda1f8ae468 - neovim: pass packpath via the wrapper
        // optionalAttrs (lib.functionArgs pkgs.neovimUtils.makeNeovimConfig ? configure) {
          configure.packages = {
            nixvim = {
              start = map (x: x.plugin) normalizedPlugins;
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
