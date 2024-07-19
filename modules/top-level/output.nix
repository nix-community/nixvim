{
  pkgs,
  config,
  lib,
  helpers,
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
      neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
        inherit (config)
          extraPython3Packages
          extraLuaPackages
          viAlias
          vimAlias
          withRuby
          withNodeJs
          ;
        plugins = config.extraPlugins;
        # We handle `customRC` ourselves, to position it after `extraConfigLuaPre`
      };

      extraWrapperArgs = builtins.concatStringsSep " " (
        (optional (config.extraPackages != [ ]) ''--prefix PATH : "${makeBinPath config.extraPackages}"'')
        ++ (optional config.wrapRc ''--add-flags -u --add-flags "${config.finalConfig}"'')
      );

      configPrefix =
        if config.type == "lua" then
          ''
            vim.cmd([[
              ${neovimConfig.neovimRcContent}
            ]])
          ''
        else
          neovimConfig.neovimRcContent;
    in
    {
      content = lib.mkIf (helpers.hasContent neovimConfig.neovimRcContent) (lib.mkBefore configPrefix);

      finalPackage = pkgs.wrapNeovimUnstable config.package (
        neovimConfig
        // {
          wrapperArgs = lib.escapeShellArgs neovimConfig.wrapperArgs + " " + extraWrapperArgs;
          # We handle wrapRc ourselves so we can control how init.lua is written
          wrapRc = false;
        }
      );

      printInitPackage = pkgs.writeShellApplication {
        name = "nixvim-print-init";
        runtimeInputs = [ pkgs.bat ];
        text = ''
          bat --language=lua "${config.finalConfig}"
        '';
      };

      extraConfigLuaPre = mkIf config.wrapRc ''
        -- Ignore the user lua configuration
        vim.opt.runtimepath:remove(vim.fn.stdpath('config'))              -- ~/.config/nvim
        vim.opt.runtimepath:remove(vim.fn.stdpath('config') .. "/after")  -- ~/.config/nvim/after
        vim.opt.runtimepath:remove(vim.fn.stdpath('data') .. "/site")     -- ~/.local/share/nvim/site
      '';

      extraPlugins = mkIf config.wrapRc [ config.filesPlugin ];
    };
}
