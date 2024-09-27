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
            with lib.types;
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

      exclude = helpers.mkNullOrOption (with lib.types; maybeRaw (listOf (maybeRaw str))) ''
        List of languages to exclude, by default is empty.
      '';

      include = helpers.mkNullOrOption (with lib.types; maybeRaw (listOf (maybeRaw str))) ''
        List of languages to include, by default is not set.
      '';
    };
  };
in
{
  imports =
    let
      basePluginPath = [
        "plugins"
        "luasnip"
      ];
    in
    [
      # TODO introduced 2024-08-04. Remove after 24.11
      (lib.mkRenamedOptionModule (basePluginPath ++ [ "extraConfig" ]) (basePluginPath ++ [ "settings" ]))
    ];

  options.plugins.luasnip = {
    enable = mkEnableOption "luasnip";

    package = lib.mkPackageOption pkgs "luasnip" {
      default = [
        "vimPlugins"
        "luasnip"
      ];
    };

    settings = mkOption {
      type = with types; attrsOf anything;
      description = ''
        Options provided to the `require('luasnip').config.setup()` function.",
      '';
      example = {
        enable_autosnippets = true;
        store_selection_keys = "<Tab>";
      };
      default = { };
    };

    fromVscode = mkOption {
      default = [ ];
      example = literalExpression ''
        [
          { }
          { paths = ./path/to/snippets; }
        ]'';
      description = ''
        List of custom vscode style snippets to load.

        For example,
        ```nix
          [ {} { paths = ./path/to/snippets; } ]
        ```
        will generate the following lua:
        ```lua
          require("luasnip.loaders.from_vscode").lazy_load({})
          require("luasnip.loaders.from_vscode").lazy_load({['paths'] = {'/nix/store/.../path/to/snippets'}})
        ```
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
        Check <https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#lua> for the necessary file structure.
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

    filetypeExtend = mkOption {
      default = { };
      type = with types; attrsOf (listOf str);
      example = {
        lua = [
          "c"
          "cpp"
        ];
      };
      description = ''
        Wrapper for the `filetype_extend` function.
        Keys are filetypes (`filetype`) and values are list of filetypes (`["ft1" "ft2" "ft3"]`).

        Tells luasnip that for a buffer with `ft=filetype`, snippets from `extend_filetypes` should
        be searched as well.

        For example, `filetypeExtend.lua = ["c" "cpp"]` would search and expand c and cpp snippets
        for lua files.
      '';
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

      filetypeExtendConfig = mapAttrsToList (n: v: ''
        require("luasnip").filetype_extend("${n}", ${helpers.toLuaObject v})
      '') cfg.filetypeExtend;

      extraConfig = [
        ''
          require("luasnip").config.setup(${helpers.toLuaObject cfg.settings})
        ''
      ];
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];
      extraLuaPackages = ps: [ ps.jsregexp ];
      extraConfigLua = concatStringsSep "\n" (extraConfig ++ loaderConfig ++ filetypeExtendConfig);
    };
}
