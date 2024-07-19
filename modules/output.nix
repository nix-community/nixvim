{
  config,
  lib,
  helpers,
  ...
}:
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
      default = if lib.hasSuffix ".vim" config.target then "vim" else "lua";
      defaultText = lib.literalMD ''`"lua"` unless `config.target` ends with `".vim"`'';
      description = "Whether the generated file is a vim or a lua file";
      readOnly = true;
    };

    target = mkOption {
      type = types.str;
      description = "Path of the file relative to the config directory";
      default = "init.lua";
    };

    content = mkOption {
      type = types.lines;
      description = "The content of the config file";
      visible = false;
      # FIXME: can't be readOnly because we prefix it in top-level modules
    };

    finalConfig = mkOption {
      type = types.package;
      description = "The config file written as a derivation";
      readOnly = true;
      internal = true;
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
      derivationName = "nvim-" + lib.replaceStrings [ "/" ] [ "-" ] config.target;

      writer = if config.type == "lua" then helpers.writeLua else pkgs.writeText;

      concatConfig = parts: lib.concatStringsSep "\n" (lib.filter helpers.hasContent parts);

      wrapConfig =
        fn: parts:
        let
          s = concatConfig (toList parts);
        in
        optionalString (helpers.hasContent s) (fn s);

      contentLua = concatConfig [
        config.extraConfigLuaPre
        (wrapConfig (s: ''
          vim.cmd([[
            ${s}
          ]])
        '') config.extraConfigVim)
        config.extraConfigLua
        config.extraConfigLuaPost
      ];

      contentVim = concatConfig [
        (wrapConfig (s: ''
          lua << EOF
            ${s}
          EOF
        '') config.extraConfigLuaPre)
        config.extraConfigVim
        (wrapConfig
          (s: ''
            lua << EOF
              ${s}
            EOF
          '')
          [
            config.extraConfigLua
            config.extraConfigLuaPost
          ]
        )
      ];
    in
    {
      content = if config.type == "lua" then contentLua else contentVim;
      finalConfig = writer derivationName config.content;
    };
}
