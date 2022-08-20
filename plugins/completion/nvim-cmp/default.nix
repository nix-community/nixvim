{ pkgs, config, lib, ... }@args:
with lib;
let
  cfg = config.programs.nixvim.plugins.nvim-cmp;
  helpers = import ../../helpers.nix { inherit lib config; };

  mkNullOrOption = helpers.mkNullOrOption;
  cmpLib = import ./cmp-helpers.nix args;
  # functionName should be a string
  # parameters should be a list of strings
  wrapWithFunction = functionName: parameters:
    let
      parameterString = strings.concatStringsSep "," parameters;
    in
    ''${functionName}(${parameterString})'';
in with helpers;
{
  options.programs.nixvim.plugins.nvim-cmp = {
    enable = mkEnableOption "Enable nvim-cmp";

    performance = import ./options/performance.nix { inherit lib; };
    mapping = import ./options/mapping.nix { inherit lib; };
    sources = import ./options/sources.nix { inherit lib config; };
    completion = import ./options/completion.nix { inherit lib; };

    preselect = mkOption {
      type = types.nullOr (types.enum [ "Item" "None" ]);
      default = null;
      example = ''"Item"'';
    };

    snippet = mkOption {
      default = null;
      type = types.nullOr (types.submodule ({ ... }: {
        options = {
          expand = mkOption {
            type = types.nullOr types.str;
            example = ''
              function(args)
                vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
              end
            '';
          };
        };
      }));
    };

    mappingPresets = mkOption {
      default = [ ];
      type = types.listOf (types.enum [
        "insert"
        "cmdline"
        # Not sure if there are more or if this should just be str
      ]);
      description = "Mapping presets to use; cmp.mapping.preset.\${mappingPreset} will be called with the configured mappings";
      example = ''
        [ "insert" "cmdline" ]
      '';
    };

    confirmation = mkOption {
      default = null;
      type = types.nullOr (types.submodule ({ ... }: {
        options = {
          get_commit_characters = mkOption {
            default = null;
            type = types.nullOr types.str;
            description = "Direct lua code as a string";
          };
        };
      }));
    };

    formatting = mkOption {
      default = null;
      type = types.nullOr (types.submodule ({ ... }: {
        options = {
          fields = mkOption {
            type = types.nullOr (types.listOf types.str);
            example = ''[ "kind" "abbr" "menu" ]'';
            default = null;
          };
          format = mkOption {
            type = types.nullOr types.str;
            description = "A lua function as a string";
            default = null;
          };
        };
      }));
    };

    matching = mkOption {
      default = null;
      type = types.nullOr (types.submodule ({ ... }: {
        options = {
          disallow_fuzzy_matching = mkOption {
            default = null;
            type = types.nullOr types.bool;
          };
          disallow_partial_matching = mkOption {
            default = null;
            type = types.nullOr types.bool;
          };
          disallow_prefix_unmatching = mkOption {
            default = null;
            type = types.nullOr types.bool;
          };
        };
      }));
    };

    sorting = mkOption {
      default = null;
      type = types.nullOr (types.submodule ({ ... }: {
        options = {
          priority_weight = mkOption {
            default = null;
            type = types.nullOr types.int;
          };
          comparators = mkOption {
            default = null;
            type = types.nullOr types.str;
          };
        };
      }));
    };

    view = mkOption {
      default = null;
      type = types.nullOr (types.submodule ({ ... }: {
        options = {
          entries = mkOption {
            default = null;
            type = with types; nullOr (either str attrs);
          };
        };
      }));
    };

    window =
      let
        # Reusable options
        border = with types; mkNullOrOption (either str (listOf str)) null;
        winhighlight = mkNullOrOption types.str null;
        zindex = mkNullOrOption types.int null;
      in
      mkOption {
        default = null;
        type = types.nullOr (types.submodule ({ ... }: {
          options = {
            completion = mkOption {
              default = null;
              type = types.nullOr (types.submodule ({ ... }: {
                options = {
                  inherit border winhighlight zindex;
                };
              }));
            };

            documentation = mkOption {
              default = null;
              type = types.nullOr (types.submodule ({ ... }: {
                options = {
                  inherit border winhighlight zindex;
                  max_width = mkNullOrOption types.int "Window's max width";
                  max_height = mkNullOrOption types.int "Window's max height";
                };
              }));
            };
          };
        }));
      };

    # This can be kept as types.attrs since experimental features are often removed or completely changed after a while
    experimental = mkNullOrOption types.attrs "Experimental features";
  };

  config =
    let
      pluginOptions = {
        enabled = cfg.enable;
        performance = cfg.performance;
        preselect = if (isNull cfg.preselect) then null else helpers.mkRaw "cmp.PreselectMode.${cfg.preselect}";

        # Not very readable sorry
        # If null then null
        # If an attribute is a string, just treat it as lua code for that mapping
        # If an attribute is a module, create a mapping with cmp.mapping() using the action as the first input and the modes as the second.
        mapping =
          let
            mappings =
              if (isNull cfg.mapping) then null
              else
                mapAttrs
                  (bind: mapping: helpers.mkRaw (if isString mapping then mapping
                  else "cmp.mapping(${mapping.action}${optionalString (mapping.modes != null && length mapping.modes >= 1) ("," + (helpers.toLuaObject mapping.modes))})"))
                  cfg.mapping;
            luaMappings = (helpers.toLuaObject mappings);
            wrapped = lists.fold (presetName: prevString: ''cmp.mapping.preset.${presetName}(${prevString})'') luaMappings cfg.mappingPresets;
          in
          helpers.mkRaw wrapped;

        snippet = {
          expand = if (isNull cfg.snippet || isNull cfg.snippet.expand) then null else helpers.mkRaw cfg.snippet.expand;
        };

        completion = if (isNull cfg.completion) then null else {
          keyword_length = cfg.completion.keyword_length;
          keyword_pattern = cfg.completion.keyword_pattern;
          autocomplete = if (isNull cfg.completion.autocomplete) then null else mkRaw cfg.completion.autocomplete;
          completeopt = cfg.completion.completeopt;
        };

        confirmation = if (isNull cfg.confirmation) then null else {
          get_commit_characters =
            if (isString cfg.confirmation.get_commit_characters) then helpers.mkRaw cfg.confirmation.get_commit_characters
            else cfg.confirmation.get_commit_characters;
        };

        formatting = if (isNull cfg.formatting) then null else {
          fields = cfg.formatting.fields;
          format = if (isNull cfg.formatting.format) then null else helpers.mkRaw cfg.formatting.format;
        };

        matching = cfg.matching;

        sorting = if (isNull cfg.sorting) then null else {
          priority_weight = cfg.sorting.priority_weight;
          comparators = if (isNull cfg.sorting.comparators) then null else helpers.mkRaw cfg.sorting.comparators;
        };

        sources = cfg.sources;
        view = cfg.view;
        window = cfg.window;
        experimental = cfg.experimental;
      };
    in
    mkIf cfg.enable {
      programs.nixvim = {
        extraPlugins = [ pkgs.vimExtraPlugins.nvim-cmp ];

        extraConfigLua = ''
          do -- create scope to not interfere with other plugins
            require('cmp').setup(${helpers.toLuaObject pluginOptions})
          end
        '';
      };
    };
}
