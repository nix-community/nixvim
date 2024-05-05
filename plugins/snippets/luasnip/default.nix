{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.luasnip;
in
{
  options.plugins.luasnip = {
    enable = mkEnableOption "luasnip";

    package = helpers.mkPackageOption "luasnip" pkgs.vimPlugins.luasnip;

    extraConfig = mkOption {
      type = types.attrsOf types.anything;
      description = ''
        Extra config options for luasnip.

         Example:
         {
           enable_autosnippets = true,
           store_selection_keys = "<Tab>",
         }
      '';
      default = { };
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
      type = types.listOf (
        types.submodule {
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
              type =
                with types;
                nullOr (oneOf [
                  str
                  path
                  helpers.nixvimTypes.rawLua
                  (listOf (oneOf [
                    str
                    path
                    helpers.nixvimTypes.rawLua
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
        }
      );
    };

    # TODO: add support for snipmate
    fromLua = mkOption {
      default = [ ];
      description = ''
        Load lua snippets with the lua loader.
        Check https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#lua for the necessary file structure.
      '';
      example = ''
        [
          {}
          {
            paths = ./path/to/snippets;
          }
        ]
      '';
      type = types.listOf (
        types.submodule {
          options = {
            lazyLoad = mkOption {
              type = types.bool;
              default = true;
              description = ''
                Whether or not to lazy load the snippets
              '';
            };
            paths = helpers.defaultNullOpts.mkNullable (
              with types;
              nullOr (oneOf [
                str
                path
                helpers.nixvimTypes.rawLua
                (listOf (oneOf [
                  str
                  path
                  helpers.nixvimTypes.rawLua
                ]))
              ])
            ) "" "Paths with snippets specified with native lua";
          };
        }
      );
    };
  };

  config =
    let
      fromVscodeLoaders = lists.map (
        loader:
        let
          options = attrsets.getAttrs [
            "paths"
            "exclude"
            "include"
          ] loader;
        in
        ''
          require("luasnip.loaders.from_vscode").${optionalString loader.lazyLoad "lazy_"}load(${helpers.toLuaObject options})
        ''
      ) cfg.fromVscode;
      fromLuaLoaders = lists.map (
        loader:
        let
          options = attrsets.getAttrs [ "paths" ] loader;
        in
        ''
          require("luasnip.loaders.from_lua").${optionalString loader.lazyLoad "lazy_"}load(${helpers.toLuaObject options})
        ''
      ) cfg.fromLua;
      extraConfig = [
        ''
          require("luasnip").config.set_config(${helpers.toLuaObject cfg.extraConfig})
        ''
      ];
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];
      extraLuaPackages = ps: [ ps.jsregexp ];
      extraConfigLua = concatStringsSep "\n" (extraConfig ++ fromVscodeLoaders ++ fromLuaLoaders);
    };
}
