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

  loaderSubmodule = types.submodule {
    options = {
      lazyLoad = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether or not to lazy load the snippets
        '';
      };

      # TODO: add option to also include the default runtimepath
      paths =
        helpers.mkNullOrOption
          (
            with helpers.nixvimTypes;
            oneOf [
              str
              path
              rawLua
              (listOf (oneOf [
                str
                path
                rawLua
              ]))
            ]
          )
          ''
            List of paths to load.
          '';

      exclude = helpers.defaultNullOpts.mkListOf' {
        type = types.str;
        description = ''
          List of languages to exclude, by default is empty.
        '';
      };

      include = helpers.defaultNullOpts.mkListOf' {
        type = types.str;
        description = ''
          List of languages to include, by default is not set.
        '';
      };
    };
  };
in
{
  options.plugins.luasnip = {
    enable = mkEnableOption "luasnip";

    package = helpers.mkPluginPackageOption "luasnip" pkgs.vimPlugins.luasnip;

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
      type = types.listOf loaderSubmodule;
    };

    fromSnipmate = mkOption {
      default = [ ];
      description = ''
        Luasnip does not support the full snipmate format: Only
        `./{ft}.snippets` and `./{ft}/*.snippets` will be loaded. See
        <https://github.com/honza/vim-snippets> for lots of examples.
      '';
      example = literalExpression ''
        [
          { }
          { paths = ./path/to/snippets; }
        ]'';
      type = types.listOf loaderSubmodule;
    };

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
      type = types.listOf loaderSubmodule;
    };
  };

  config =
    let
      loaderConfig =
        trivial.pipe
          {
            vscode = cfg.fromVscode;
            snipmate = cfg.fromSnipmate;
            lua = cfg.fromLua;
          }
          [
            # Convert loader options to [{ name = "vscode"; loader = ...; }]
            (attrsets.mapAttrsToList (name: loaders: lists.map (loader: { inherit name loader; }) loaders))
            lists.flatten

            (lists.map (
              pair:
              let
                inherit (pair) name loader;
                options = attrsets.getAttrs [
                  "paths"
                  "exclude"
                  "include"
                ] loader;
              in
              ''
                require("luasnip.loaders.from_${name}").${optionalString loader.lazyLoad "lazy_"}load(${helpers.toLuaObject options})
              ''
            ))
          ];
      extraConfig = [
        ''
          require("luasnip").config.set_config(${helpers.toLuaObject cfg.extraConfig})
        ''
      ];
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];
      extraLuaPackages = ps: [ ps.jsregexp ];
      extraConfigLua = concatStringsSep "\n" (extraConfig ++ loaderConfig);
    };
}
