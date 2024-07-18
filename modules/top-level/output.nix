{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
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

    printInitPackage = mkOption {
      type = types.package;
      description = "A tool to show the content of the generated `init.lua` file.";
      readOnly = true;
      visible = false;
    };
  };

  imports = [
    (lib.mkRemovedOptionModule [ "initPath" ] ''
      Use `finalConfig' instead.
    '')
  ];

  config =
    let
      defaultPlugin = {
        plugin = null;
        config = "";
        optional = false;
      };

      normalizedPlugins = map (
        x: defaultPlugin // (if x ? plugin then x else { plugin = x; })
      ) config.extraPlugins;

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
        // optionalAttrs (functionArgs pkgs.neovimUtils.makeNeovimConfig ? configure) {
          configure.packages = {
            nixvim = {
              start = map (x: x.plugin) normalizedPlugins;
              opt = [ ];
            };
          };
        }
      );

      extraWrapperArgs = builtins.concatStringsSep " " (
        (optional (config.extraPackages != [ ]) ''--prefix PATH : "${makeBinPath config.extraPackages}"'')
        ++ (optional config.wrapRc ''--add-flags -u --add-flags "${config.finalConfig}"'')
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

      content = lib.mkForce (
        lib.concatStringsSep "\n" [
          (optionalString (hasContent neovimConfig.neovimRcContent) ''
            vim.cmd([[
              ${neovimConfig.neovimRcContent}
            ]])
          '')
          config.extraConfigLuaPre
          (optionalString (hasContent config.extraConfigVim) ''
            vim.cmd([[
              ${config.extraConfigVim}
            ]])
          '')
          config.extraConfigLua
          config.extraConfigLuaPost
        ]
      );

      finalPackage = wrappedNeovim;

      printInitPackage = pkgs.writeShellApplication {
        name = "nixvim-print-init";
        runtimeInputs = [ pkgs.bat ];
        text = ''
          bat --language=lua "${config.finalConfig}"
        '';
      };

      extraConfigLuaPre = lib.optionalString config.wrapRc ''
        -- Ignore the user lua configuration
        vim.opt.runtimepath:remove(vim.fn.stdpath('config'))              -- ~/.config/nvim
        vim.opt.runtimepath:remove(vim.fn.stdpath('config') .. "/after")  -- ~/.config/nvim/after
        vim.opt.runtimepath:remove(vim.fn.stdpath('data') .. "/site")     -- ~/.local/share/nvim/site
      '';

      extraPlugins = if config.wrapRc then [ config.filesPlugin ] else [ ];
    };
}
