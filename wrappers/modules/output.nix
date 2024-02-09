{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
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

    package = mkOption {
      type = types.package;
      default = pkgs.neovim-unwrapped;
      description = "Neovim to use for nixvim";
    };

    wrapRc = mkOption {
      type = types.bool;
      description = "Should the config be included in the wrapper script";
      default = false;
    };

    finalPackage = mkOption {
      type = types.package;
      description = "Wrapped neovim";
      readOnly = true;
    };

    initPath = mkOption {
      type = types.str;
      description = "The path to the init.lua file";
      readOnly = true;
      visible = false;
    };

    initContent = mkOption {
      type = types.str;
      description = "The content of the init.lua file";
      readOnly = true;
      visible = false;
    };

    printInitPackage = mkOption {
      type = types.package;
      description = "A tool to show the content of the generated init.lua file.";
      readOnly = true;
      visible = false;
    };
  };

  config = let
    defaultPlugin = {
      plugin = null;
      config = "";
      optional = false;
    };

    normalizedPlugins = map (x:
      defaultPlugin
      // (
        if x ? plugin
        then x
        else {plugin = x;}
      ))
    config.extraPlugins;

    neovimConfig = pkgs.neovimUtils.makeNeovimConfig ({
        inherit
          (config)
          extraPython3Packages
          viAlias
          vimAlias
          ;
        # inherit customRC;
        plugins = normalizedPlugins;
      }
      # Necessary to make sure the runtime path is set properly in NixOS 22.05,
      # or more generally before the commit:
      # cda1f8ae468 - neovim: pass packpath via the wrapper
      // optionalAttrs (functionArgs pkgs.neovimUtils.makeNeovimConfig ? configure) {
        configure.packages = {
          nixvim = {
            start = map (x: x.plugin) normalizedPlugins;
            opt = [];
          };
        };
      });

    customRC =
      ''
        vim.cmd([[
          ${neovimConfig.neovimRcContent}
        ]])
      ''
      + config.content;

    init = pkgs.writeText "init.lua" customRC;
    initPath = toString init;

    extraWrapperArgs = builtins.concatStringsSep " " (
      (optional (config.extraPackages != [])
        ''--prefix PATH : "${makeBinPath config.extraPackages}"'')
      ++ (optional config.wrapRc
        ''--add-flags -u --add-flags "${init}"'')
    );

    wrappedNeovim = pkgs.wrapNeovimUnstable config.package (neovimConfig
      // {
        wrapperArgs = lib.escapeShellArgs neovimConfig.wrapperArgs + " " + extraWrapperArgs;
        wrapRc = false;
      });
  in {
    type = lib.mkForce "lua";
    finalPackage = wrappedNeovim;
    initContent = customRC;
    inherit initPath;

    printInitPackage = pkgs.writeShellApplication {
      name = "nixvim-print-init";
      runtimeInputs = with pkgs; [stylua bat];
      text = ''
        stylua - <"${initPath}" | bat --language=lua
      '';
    };

    extraConfigLuaPre = lib.optionalString config.wrapRc ''
      -- Ignore the user lua configuration
      vim.opt.runtimepath:remove(vim.fn.stdpath('config'))              -- ~/.config/nvim
      vim.opt.runtimepath:remove(vim.fn.stdpath('config') .. "/after")  -- ~/.config/nvim/after
      vim.opt.runtimepath:remove(vim.fn.stdpath('data') .. "/site")     -- ~/.local/share/nvim/site
    '';

    extraPlugins =
      if config.wrapRc
      then [config.filesPlugin]
      else [];
  };
}
