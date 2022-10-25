{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.plugins.luasnip;
  helpers = import ../../helpers.nix { lib = lib; };
in
{
  options.plugins.luasnip = {
    enable = mkEnableOption "Enable luasnip";

    loadVsCode = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether or not to lazy load vscode-like snippets
      '';
    };

    fromVscode = mkOption {
      default = null;
      type = types.nullOr (types.submodule {
        options = {
          enable = mkEnableOption "Enable the vscode snippets loader for luasnip";
          lazyLoad = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Whether or not to lazy load the snippets
            '';
          };

          # TODO: add option to also include the default runtimepath
          paths = mkOption {
            default = null;
            type = with types; nullOr (oneOf
              [
                str
                path
                helpers.rawType
                (listOf (oneOf
                  [
                    str
                    path
                    helpers.rawType
                  ]))
              ]);
          };

          exclude = mkOption {
            type = types.nullOr (types.listOf types.str);
            default = null;
            description = ''
              List of languages to exclude, by default is empty.
            '';
          };

          include = mkOption {
            type = types.nullOr (types.listOf types.str);
            default = null;
            description = ''
              List of languages to include, by default is not set.
            '';
          };
        };
      });
    };

    # TODO: add support for snipmate
    # TODO: add support for lua
  };

  config =
    let
      fromVscodeOptions =
        if (isAttrs cfg.fromVscode) then
          {
            exclude = cfg.fromVscode.exclude;
            include = cfg.fromVscode.include;
            paths = cfg.fromVscode.paths;
          }
        else
          { };
    in
    mkIf cfg.enable {
      extraPlugins = [ pkgs.vimPlugins.luasnip ];

      extraConfigLua = optionalString (isAttrs cfg.fromVscode && cfg.fromVscode.enable) ''
        require("luasnip.loaders.from_vscode").${optionalString cfg.fromVscode.lazyLoad "lazy_"}load(${helpers.toLuaObject fromVscodeOptions})
      '';
    };
}
