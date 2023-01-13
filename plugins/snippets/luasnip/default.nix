{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.plugins.luasnip;
  helpers = import ../../helpers.nix { lib = lib; };
in
{
  options.plugins.luasnip = {
    enable = mkEnableOption "Enable luasnip";

    package = mkOption {
      default = pkgs.vimPlugins.luasnip;
      type = types.package;
    };

    fromVscode = mkOption {
      default = [ ];
      example = ''
        [
          {}
          {
            paths = ./path/to/snippets;
          }
        ]
        # generates:
        #
        # require("luasnip.loaders.from_vscode").lazy_load({})
        # require("luasnip.loaders.from_vscode").lazy_load({['paths'] = {'/nix/store/.../path/to/snippets'}})
        #
      '';
      type = types.listOf (types.submodule {
        options = {
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

      fromVscodeLoaders = lists.map
        (loader:
          let
            options = attrsets.getAttrs [ "paths" "exclude" "include" ] loader;
          in
          ''
            require("luasnip.loaders.from_vscode").${optionalString loader.lazyLoad "lazy_"}load(${helpers.toLuaObject options})
          '')
        cfg.fromVscode;
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];
      extraConfigLua = concatStringsSep "\n" fromVscodeLoaders;
    };
}
