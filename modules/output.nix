{
  lib,
  config,
  ...
}:
with lib; let
  pluginWithConfigType = types.submodule {
    options = {
      config = mkOption {
        type = types.lines;
        description = "vimscript for this plugin to be placed in init.vim";
        default = "";
      };

      optional =
        mkEnableOption "optional"
        // {
          description = "Don't load by default (load with :packadd)";
        };

      plugin = mkOption {
        type = types.package;
        description = "vim plugin";
      };
    };
  };
in {
  options = {
    extraPlugins = mkOption {
      type = with types; listOf (either package pluginWithConfigType);
      default = [];
      description = "List of vim plugins to install";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Extra packages to be made available to neovim";
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
      type = types.enum ["vim" "lua"];
      default = "lua";
      description = "Whether the generated file is a vim or a lua file";
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
      default = _: [];
    };

    extraFiles = mkOption {
      type = types.attrsOf types.str;
      description = "Extra files to add to the runtime path";
      default = {};
    };
  };

  config = let
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
  in {
    content =
      if config.type == "lua"
      then contentLua
      else contentVim;
  };
}
