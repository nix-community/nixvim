{ pkgs, config, lib, ... }@args:
with lib;
let
  cfg = config.plugins.nvim-cmp;
  helpers = import ../../helpers.nix { lib = lib; };
  mkNullOrOption = helpers.mkNullOrOption;
  cmpLib = import ./cmp-helpers.nix args;
  # functionName should be a string
  # parameters should be a list of strings
  wrapWithFunction = functionName: parameters:
    let
      parameterString = strings.concatStringsSep "," parameters;
    in
    ''${functionName}(${parameterString})'';
in
{
  options.plugins.nvim-cmp = {
    enable = mkEnableOption "Enable nvim-cmp";

    performance = mkOption {
      default = null;
      type = types.nullOr (types.submodule ({ ... }: {
        options = {
          debounce = mkOption {
            type = types.nullOr types.int;
            default = null;
          };
          throttle = mkOption {
            type = types.nullOr types.int;
            default = null;
          };
        };
      }));
    };

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

    mapping = mkOption {
      default = null;
      type = types.nullOr (types.attrsOf (types.either types.str (types.submodule ({ ... }: {
        options = {
          action = mkOption {
            type = types.nonEmptyStr;
            description = "The function the mapping should call";
            example = ''"cmp.mapping.scroll_docs(-4)"'';
          };
          modes = mkOption {
            default = null;
            type = types.nullOr (types.listOf types.str);
            example = ''[ "i" "s" ]'';
          };
        };
      }))));
      example = ''
        {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = {
            modes = [ "i" "s" ];
            action = '${""}'
              function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.expandable() then
                  luasnip.expand()
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                elseif check_backspace() then
                  fallback()
                else
                  fallback()
                end
              end
            '${""}';
          };
        }
      '';
    };

    completion = mkOption {
      default = null;
      type = types.nullOr (types.submodule ({ ... }: {
        options = {
          keyword_length = mkOption {
            default = null;
            type = types.nullOr types.int;
          };

          keyword_pattern = mkOption {
            default = null;
            type = types.nullOr types.str;
          };

          autocomplete = mkOption {
            default = null;
            type = types.nullOr types.str;
            description = "Lua code for the event.";
            example = ''"false"'';
          };

          completeopt = mkOption {
            default = null;
            type = types.nullOr types.str;
          };
        };
      }));
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
            default = null;
            type = types.nullOr (types.listOf types.str);
            example = ''[ "kind" "abbr" "menu" ]'';
          };
          format = mkOption {
            default = null;
            type = types.nullOr types.str;
            description = "A lua function as a string";
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

    auto_enable_sources = mkOption {
      default = true;
      description = ''
        Scans the sources array and installs the plugins if they are known to nixvim.
      '';
    };

    sources =
      let
        source_config = types.submodule ({ ... }: {
          options = {
            name = mkOption {
              type = types.str;
              description = "The name of the source.";
              example = ''"buffer"'';
            };

            option = mkOption {
              default = null;
              type = with types; nullOr (attrsOf anything);
              description = "If direct lua code is needed use helpers.mkRaw";
            };

            keyword_length = mkOption {
              default = null;
              type = types.nullOr types.int;
            };

            keyword_pattern = mkOption {
              default = null;
              type = types.nullOr types.int;
            };

            trigger_characters = mkOption {
              default = null;
              type = with types; nullOr (listOf str);
            };

            priority = mkOption {
              default = null;
              type = types.nullOr types.int;
            };

            max_item_count = mkOption {
              default = null;
              type = types.nullOr types.int;
            };

            group_index = mkOption {
              default = null;
              type = types.nullOr types.int;
            };
          };
        });
      in
      mkOption {
        default = null;
        type = with types; nullOr (either (listOf source_config) (listOf (listOf source_config)));
        description = ''
          The sources to use.
          Can either be a list of sourceConfigs which will be made directly to a Lua object.
          Or it can be a list of lists, which will use the cmp built-in helper function `cmp.config.sources`.
        '';
        example = ''
          [
            { name = "nvim_lsp"; }
            { name = "luasnip"; } #For luasnip users.
            { name = "path"; }
            { name = "buffer"; }
          ]
        '';
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
        col_offset = mkNullOrOption types.int null;
        side_padding = mkNullOrOption types.int null;
      in
      mkOption {
        default = null;
        type = types.nullOr (types.submodule ({ ... }: {
          options = {
            completion = mkOption {
              default = null;
              type = types.nullOr (types.submodule ({ ... }: {
                options = {
                  inherit border winhighlight zindex col_offset side_padding;
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
      options = {
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
      extraPlugins = [ pkgs.vimPlugins.nvim-cmp ];

      extraConfigLua = helpers.wrapDo ''
        local cmp = require('cmp')
        cmp.setup(${helpers.toLuaObject options})
      '';

      # If auto_enable_sources is set to true, figure out which are provided by the user
      # and enable the corresponding plugins.
      plugins =
        let
          flattened_sources = if (isNull cfg.sources) then [ ] else flatten cfg.sources;
          # Take only the names from the sources provided by the user
          found_sources = lists.unique (lists.map (source: source.name) flattened_sources);
          # A list of known source names
          known_source_names = attrNames cmpLib.pluginAndSourceNames;

          attrs_enabled = listToAttrs (map
            (name: {
              name = cmpLib.pluginAndSourceNames.${name};
              value.enable = mkIf (elem name found_sources) true;
            })
            known_source_names);
        in
        mkIf cfg.auto_enable_sources attrs_enabled;
    };
}
