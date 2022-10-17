{ pkgs, config, lib, ... }:
with lib;
let
  pluginWithConfigType = types.submodule {
    options = {
      config = mkOption {
        type = types.lines;
        description = "vimscript for this plugin to be placed in init.vim";
        default = "";
      };

      optional = mkEnableOption "optional" // {
        description = "Don't load by default (load with :packadd)";
      };

      plugin = mkOption {
        type = types.package;
        description = "vim plugin";
      };
    };
  };
in
{
  options = {
    package = mkOption {
      type = types.package;
      default = pkgs.neovim-unwrapped;
      description = "Neovim to use for nixvim";
    };

    extraPlugins = mkOption {
      type = with types; listOf (either package pluginWithConfigType);
      default = [ ];
      description = "List of vim plugins to install";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Extra packages to be made available to neovim";
    };

    extraConfigLua = mkOption {
      type = types.lines;
      default = "";
      description = "Extra contents for init.lua";
    };

    extraConfigLuaPre = mkOption {
      type = types.lines;
      default = "";
      description = "Extra contents for init.lua before everything else";
    };

    extraConfigLuaPost = mkOption {
      type = types.lines;
      default = "";
      description = "Extra contents for init.lua after everything else";
    };


    extraConfigVim = mkOption {
      type = types.lines;
      default = "";
      description = "Extra contents for init.vim";
    };

    output = mkOption {
      type = types.package;
      description = "Final package built by nixvim";
      readOnly = true;
      visible = false;
    };
  };

  config =
    let
      customRC =
        (optionalString (config.extraConfigLuaPre != "") ''
          lua <<EOF
          ${config.extraConfigLuaPre}
          EOF
        '') +
        config.extraConfigVim + (optionalString (config.extraConfigLuaPre != "" || config.extraConfigLuaPost != "") ''
          lua <<EOF
          ${config.extraConfigLua}
          ${config.extraConfigLuaPost}
          EOF
        '');

      defaultPlugin = {
        plugin = null;
        config = "";
        optional = false;
      };

      normalizedPlugins = map (x: defaultPlugin // (if x ? plugin then x else { plugin = x; })) config.extraPlugins;

      neovimConfig = pkgs.neovimUtils.makeNeovimConfig ({
        inherit customRC;
        plugins = normalizedPlugins;
      }
      # Necessary to make sure the runtime path is set properly in NixOS 22.05,
      # or more generally before the commit:
      # cda1f8ae468 - neovim: pass packpath via the wrapper
      // optionalAttrs (functionArgs pkgs.neovimUtils.makeNeovimConfig ? configure) {
        configure.packages =
          { nixvim = { start = map (x: x.plugin) normalizedPlugins; opt = [ ]; }; };
      });

      extraWrapperArgs = optionalString (config.extraPackages != [ ])
        ''--prefix PATH : "${makeBinPath config.extraPackages}"'';

      wrappedNeovim = pkgs.wrapNeovimUnstable config.package (neovimConfig // {
        wrapperArgs = lib.escapeShellArgs neovimConfig.wrapperArgs + " " + extraWrapperArgs;
      });
    in
    {
      output = wrappedNeovim;
    };
}
