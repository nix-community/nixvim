{
  lib,
  config,
  helpers,
  ...
}:
let
  inherit (lib) types mkOption;

  pluginWithConfigType = types.submodule {
    options = {
      config = mkOption {
        type = types.lines;
        description = "vimscript for this plugin to be placed in init.vim";
        default = "";
      };

      optional = lib.mkEnableOption "optional" // {
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
    env = mkOption {
      type =
        with types;
        lazyAttrsOf (oneOf [
          str
          path
          int
          float
        ]);
      description = "Environment variables to set in the neovim wrapper.";
      default = { };
      example = {
        FOO = 1;
        PI = 3.14;
        BAR_PATH = "/home/me/.local/share/bar";
        INFER_MODE = "local";
        BAZ_MAX_COUNT = 1000;
      };
    };

    extraPlugins = mkOption {
      type = with types; listOf (nullOr (either package pluginWithConfigType));
      default = [ ];
      description = "List of vim plugins to install";
      apply = builtins.filter (p: p != null);
    };

    extraPackages = mkOption {
      type = with types; listOf (nullOr package);
      default = [ ];
      description = "Extra packages to be made available to neovim";
      apply = builtins.filter (p: p != null);
    };

    extraPython3Packages = mkOption {
      type = with types; functionTo (listOf package);
      default = p: [ ];
      defaultText = lib.literalExpression "p: with p; [ ]";
      description = "Python packages to add to the `PYTHONPATH` of neovim.";
      example = lib.literalExpression ''
        p: [ p.numpy ]
      '';
    };

    extraConfigLua = mkOption {
      type = types.lines;
      default = "";
      description = "Extra contents for the file";
    };

    extraConfigLuaPre = mkOption {
      type = types.lines;
      default = "";
      description = "Extra contents for the file before everything else";
    };

    extraConfigLuaPost = mkOption {
      type = types.lines;
      default = "";
      description = "Extra contents for the file after everything else";
    };

    extraConfigVim = mkOption {
      type = types.lines;
      default = "";
      description = "Extra contents for the file, in vimscript";
    };

    type = mkOption {
      type = types.enum [
        "vim"
        "lua"
      ];
      default = "lua";
      description = ''
        Whether the generated file is a vim or a lua file

        Read-only outside of `files` submodules.
      '';
      readOnly = config.isTopLevel;
    };

    path = mkOption {
      type = types.str;
      description = "Path of the file relative to the config directory";
    };

    content = mkOption {
      type = types.str;
      description = "The content of the config file";
      readOnly = true;
      visible = false;
    };

    extraLuaPackages = mkOption {
      type = types.functionTo (types.listOf types.package);
      description = "Extra lua packages to include with neovim";
      default = _: [ ];
    };
  };

  config = {
    content =
      if config.type == "lua" then
        # Lua
        helpers.concatNonEmptyLines [
          config.extraConfigLuaPre
          (helpers.wrapVimscriptForLua config.extraConfigVim)
          config.extraConfigLua
          config.extraConfigLuaPost
        ]
      else
        # Vimscript
        helpers.concatNonEmptyLines [
          (helpers.wrapLuaForVimscript config.extraConfigLuaPre)
          config.extraConfigVim
          (helpers.wrapLuaForVimscript (
            helpers.concatNonEmptyLines [
              config.extraConfigLua
              config.extraConfigLuaPost
            ]
          ))
        ];
  };
}
