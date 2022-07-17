{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.nvim-cmp;
  helpers = import ../../helpers.nix { lib = lib; };
in
{
  options.programs.nixvim.plugins.nvim-cmp = {
    enable = mkEnableOption "Enable nvim-cmp";

    performance = mkOption {
      default = null;
      type = types.nullOr (types.submodule ({...}: {
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
      type = types.nullOr (types.submodule ({...}: {
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
  };

  config = let
    options = {
      enabled = cfg.enable;
      performance = cfg.performance;
      preselect = if (isNull cfg.preselect) then null else helpers.mkRaw "cmp.PreselectMode.${cfg.preselect}";
      # mapping = cfg.mapping;
      snippet = {
        expand = if (isNull cfg.snippet.expand) then null else helpers.mkRaw cfg.snippet.expand;
      };
      # completion = cfg.completion;
      # confirmation = cfg.confirmation;
      # formatting = cfg.formatting;
      # matching = cfg.matching;
      # sorting = cfg.sorting;
      # sources = cfg.sources;
      # view = cfg.view;
      # window = cfg.window;
      # experimental = cfg.experimental;
    };
  in mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = [ pkgs.vimPlugins.nvim-cmp ];

      extraConfigLua = ''
        local cmp = require('cmp')
        cmp.setup(${helpers.toLuaObject options})
      '';
    };
  };
}
