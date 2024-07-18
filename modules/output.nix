{ lib, config, ... }:
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
    extraPlugins = mkOption {
      type = with types; listOf (either package pluginWithConfigType);
      default = [ ];
      description = "List of vim plugins to install";
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
      defaultText = literalExpression "p: with p; [ ]";
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
      description = "Whether the generated file is a vim or a lua file";
    };

    target = mkOption {
      type = types.str;
      description = "Path of the file relative to the config directory";
      default = "init.lua";
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

  imports = [ (lib.mkRenamedOptionModule [ "path" ] [ "target" ]) ];

  config =
    let
      contentLua = ''
        ${config.extraConfigLuaPre}
        vim.cmd([[
          ${config.extraConfigVim}
        ]])
        ${config.extraConfigLua}
        ${config.extraConfigLuaPost}
      '';

      contentVim = ''
        lua << EOF
          ${config.extraConfigLuaPre}
        EOF
        ${config.extraConfigVim}
        lua << EOF
          ${config.extraConfigLua}
          ${config.extraConfigLuaPost}
        EOF
      '';
    in
    {
      content = if config.type == "lua" then contentLua else contentVim;
    };
}
