{ lib, ... }:
let
  inherit (lib) mkOption types;
  inherit (lib.nixvim) defaultNullOpts literalLua toLuaObject;

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
        lib.nixvim.mkNullOrOption
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

      exclude = lib.nixvim.mkNullOrOption (with lib.types; maybeRaw (listOf (maybeRaw str))) ''
        List of languages to exclude, by default is empty.
      '';

      include = lib.nixvim.mkNullOrOption (with lib.types; maybeRaw (listOf (maybeRaw str))) ''
        List of languages to include, by default is not set.
      '';
    };
  };
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "luasnip";
  package = "luasnip";
  setup = ".config.setup";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsOptions = {
    keep_roots = defaultNullOpts.mkBool false ''
      Whether snippet-roots should be linked.
    '';

    link_roots = defaultNullOpts.mkBool false ''
      Whether snippet-roots should be linked.
    '';

    exit_roots = defaultNullOpts.mkBool true ''
      Whether snippet-roots should exit at reaching at their last node, $0.
      This setting is only valid for root snippets, not child snippets.
      This setting may avoid unexpected behavior by disallowing to jump earlier (finished) snippets.
    '';

    link_children = defaultNullOpts.mkBool false ''
      Whether children should be linked.
    '';

    update_events =
      defaultNullOpts.mkNullableWithRaw (with types; either str (listOf str)) "InsertLeave"
        ''
          Choose which events trigger an update of the active nodes' dependents.
        '';

    region_check_events =
      defaultNullOpts.mkNullableWithRaw (with types; either str (listOf str)) (literalLua "nil")
        ''
          Events on which to leave the current snippet-root if the cursor is outside its' 'region'. Disabled by default.
        '';

    delete_check_events =
      defaultNullOpts.mkNullableWithRaw (with types; either str (listOf str)) (literalLua "nil")
        ''
          When to check if the current snippet was deleted, and if so, remove it from the history. Off by default.
        '';

    cut_selection_keys = defaultNullOpts.mkStr (literalLua "nil") ''
      Mapping for populating TM_SELECTED_TEXT and related variables (not set by default).
    '';

    enable_autosnippets = defaultNullOpts.mkBool false ''
      Autosnippets are disabled by default to minimize performance penalty if unused. Set to true to enable.
    '';

    ext_opts =
      defaultNullOpts.mkAttrsOf (with types; attrsOf (attrsOf anything))
        {
          "types.textNode" = {
            active = {
              hl_group = "LuasnipTextNodeActive";
            };
            passive = {
              hl_group = "LuasnipTextNodePassive";
            };
            visited = {
              hl_group = "LuasnipTextNodeVisited";
            };
            unvisited = {
              hl_group = "LuasnipTextNodeUnvisited";
            };
            snippet_passive = {
              hl_group = "LuasnipTextNodeSnippetPassive";
            };
          };
          "types.insertNode" = {
            active = {
              hl_group = "LuasnipInsertNodeActive";
            };
            passive = {
              hl_group = "LuasnipInsertNodePassive";
            };
            visited = {
              hl_group = "LuasnipInsertNodeVisited";
            };
            unvisited = {
              hl_group = "LuasnipInsertNodeUnvisited";
            };
            snippet_passive = {
              hl_group = "LuasnipInsertNodeSnippetPassive";
            };
          };
          "types.exitNode" = {
            active = {
              hl_group = "LuasnipExitNodeActive";
            };
            passive = {
              hl_group = "LuasnipExitNodePassive";
            };
            visited = {
              hl_group = "LuasnipExitNodeVisited";
            };
            unvisited = {
              hl_group = "LuasnipExitNodeUnvisited";
            };
            snippet_passive = {
              hl_group = "LuasnipExitNodeSnippetPassive";
            };
          };
          "types.functionNode" = {
            active = {
              hl_group = "LuasnipFunctionNodeActive";
            };
            passive = {
              hl_group = "LuasnipFunctionNodePassive";
            };
            visited = {
              hl_group = "LuasnipFunctionNodeVisited";
            };
            unvisited = {
              hl_group = "LuasnipFunctionNodeUnvisited";
            };
            snippet_passive = {
              hl_group = "LuasnipFunctionNodeSnippetPassive";
            };
          };
          "types.snippetNode" = {
            active = {
              hl_group = "LuasnipSnippetNodeActive";
            };
            passive = {
              hl_group = "LuasnipSnippetNodePassive";
            };
            visited = {
              hl_group = "LuasnipSnippetNodeVisited";
            };
            unvisited = {
              hl_group = "LuasnipSnippetNodeUnvisited";
            };
            snippet_passive = {
              hl_group = "LuasnipSnippetNodeSnippetPassive";
            };
          };
          "types.choiceNode" = {
            active = {
              hl_group = "LuasnipChoiceNodeActive";
            };
            passive = {
              hl_group = "LuasnipChoiceNodePassive";
            };
            visited = {
              hl_group = "LuasnipChoiceNodeVisited";
            };
            unvisited = {
              hl_group = "LuasnipChoiceNodeUnvisited";
            };
            snippet_passive = {
              hl_group = "LuasnipChoiceNodeSnippetPassive";
            };
          };
          "types.dynamicNode" = {
            active = {
              hl_group = "LuasnipDynamicNodeActive";
            };
            passive = {
              hl_group = "LuasnipDynamicNodePassive";
            };
            visited = {
              hl_group = "LuasnipDynamicNodeVisited";
            };
            unvisited = {
              hl_group = "LuasnipDynamicNodeUnvisited";
            };
            snippet_passive = {
              hl_group = "LuasnipDynamicNodeSnippetPassive";
            };
          };
        }
        ''
          Additional options passed to extmarks. Can be used to add passive/active highlight on a per-node-basis.
        '';

    ext_base_prio = defaultNullOpts.mkInt 200 ''
      Base priority for extmarks.
    '';

    ext_prio_increase = defaultNullOpts.mkInt 9 ''
      Priority increase for extmarks.
    '';

    parser_nested_assembler =
      defaultNullOpts.mkRaw
        ''
          function(pos, snip)
            local iNode = require("luasnip.nodes.insertNode")
            local cNode = require("luasnip.nodes.choiceNode")

            modify_nodes(snip)
            snip:init_nodes()
            snip.pos = nil

            return cNode.C(pos, { snip, iNode.I(nil, { "" }) })
          end
        ''
        ''
          Override the default behavior of inserting a choiceNode containing the nested snippet and an empty insertNode for nested placeholders.
        '';

    ft_func =
      defaultNullOpts.mkRaw
        ''
          require("luasnip.extras.filetype_functions").from_filetype
        ''
        ''
          Source of possible filetypes for snippets.
          Defaults to a function, which returns vim.split(vim.bo.filetype, ".", true),
          but check filetype_functions or the Extras-Filetype-Functions-section for more options.
        '';

    load_ft_func =
      defaultNullOpts.mkRaw
        ''
          require("luasnip.extras.filetype_functions").from_filetype_load
        ''
        ''
          Function to determine which filetypes belong to a given buffer (used for lazy_loading). fn(bufnr) -> filetypes (string[]).
          Again, there are some examples in filetype_functions.
        '';

    loaders_store_source = defaultNullOpts.mkBool false ''
      Whether loaders should store the source of the loaded snippets.
      Enabling this means that the definition of any snippet can be jumped to via Extras-Snippet-Location,
      but also entails slightly increased memory consumption (and load-time, but it's not really noticeable).
    '';
  };

  settingsExample = {
    update_events = [
      "TextChanged"
      "TextChangedI"
    ];
    keep_roots = true;
    link_roots = true;
    exit_roots = false;
    enable_autosnippets = true;
  };

  extraOptions = {
    fromVscode = mkOption {
      type = types.listOf loaderSubmodule;
      default = [ ];
      example = lib.literalExpression ''
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
    };

    fromSnipmate = mkOption {
      default = [ ];
      description = ''
        Luasnip does not support the full snipmate format: Only
        `./{ft}.snippets` and `./{ft}/*.snippets` will be loaded. See
        <https://github.com/honza/vim-snippets> for lots of examples.
      '';
      example = lib.literalExpression ''
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
      example = lib.literalExpression ''
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

  extraConfig =
    cfg:
    let
      loaderConfig =
        lib.pipe
          {
            vscode = cfg.fromVscode;
            snipmate = cfg.fromSnipmate;
            lua = cfg.fromLua;
          }
          [
            (lib.mapAttrsToList (name: loaders: map (loader: { inherit name loader; }) loaders))
            lib.flatten
            (map (
              pair:
              let
                inherit (pair) name loader;
                options = lib.getAttrs [
                  "paths"
                  "exclude"
                  "include"
                ] loader;
              in
              ''
                require("luasnip.loaders.from_${name}").${lib.optionalString loader.lazyLoad "lazy_"}load(${toLuaObject options})
              ''
            ))
          ];

      filetypeExtendConfig = lib.mapAttrsToList (name: value: ''
        require("luasnip").filetype_extend("${name}", ${toLuaObject value})
      '') cfg.filetypeExtend;
    in
    {
      plugins.luasnip.luaConfig.content = lib.concatLines (loaderConfig ++ filetypeExtendConfig);
    };
}
