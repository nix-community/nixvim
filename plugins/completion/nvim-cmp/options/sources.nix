{ lib, config, ... }:

with lib;
with types;
let

  helpers = import ../../../helpers.nix { inherit lib config; };

  sourceNameAndPlugin = {
    "buffer" = "cmp-buffer";
    "calc" = "cmp-calc";
    "cmdline" = "cmp-cmdline";
    "cmp-clippy" = "cmp-clippy";
    "cmp-cmdline-history" = "cmp-cmdline-history";
    "cmp_pandoc" = "cmp-pandoc-nvim";
    "cmp_tabnine" = "cmp-tabnine";
    "conventionalcommits" = "cmp-conventionalcommits";
    "copilot" = "cmp-copilot";
    "crates" = "crates-nvim";
    "dap" = "cmp-dap";
    "dictionary" = "cmp-dictionary";
    "digraphs" = "cmp-digraphs";
    "emoji" = "cmp-emoji";
    "fish" = "cmp-fish";
    "fuzzy_buffer" = "cmp-fuzzy-buffer";
    "fuzzy_path" = "cmp-fuzzy-path";
    "git" = "cmp-git";
    "greek" = "cmp-greek";
    "latex_symbols" = "cmp-latex-symbols";
    "look" = "cmp-look";
    "luasnip" = "cmp_luasnip";
    "npm" = "cmp-npm";
    "nvim_lsp" = "cmp-nvim-lsp";
    "nvim_lsp_document_symbol" = "cmp-nvim-lsp-document-symbol";
    "nvim_lsp_signature_help" = "cmp-nvim-lsp-signature-help";
    "nvim_lua" = "cmp-nvim-lua";
    "omni" = "cmp-omni";
    "pandoc_references" = "cmp-pandoc-references";
    "path" = "cmp-path";
    "rg" = "cmp-rg";
    "snippy" = "cmp-snippy";
    "spell" = "cmp-spell";
    "tmux" = "cmp-tmux";
    "treesitter" = "cmp-treesitter";
    "ultisnips" = "cmp-nvim-ultisnips";
    "vim_lsp" = "cmp-vim-lsp";
    "vimwiki-tags" = "cmp-vimwiki-tags";
    "vsnip" = "cmp-vsnip";
    "zsh" = "cmp-zsh";
  };
  
  toSourceModule = name: package:
    with helpers;
    let
      # cfg = config.programs.nixvim.plugins.nvim-cmp.sources.${name};
    in mkOption {
      type = nullOr (submodule {
        options = {
          enable = mkEnableOption "";
          option = mkOption {
            type = nullOr (attrsOf anything);
            description = "If direct lua code is needed use helpers.mkRaw";
            default = null;
          };
          triggerCharacters = mkOption {
            type = nullOr (listOf str);
            default = null;
          };
          keywordLength = intNullOption null "";
          keywordPattern = intNullOption null "";
          priority = intNullOption null "";
          maxItemCount = intNullOption null "";
          groupIndex = intNullOption null "";
        };
      });
      description = "Module for the ${name} (${package}) source for nvim-cmp";
      default = null;
    };
    #   config.programs.nixvim = mkIf cfg.enable {
    #     extraConfigLua = '' -- ${name} as ${package}'';
    #    # extraPlugins = [ pkgs.vimExtraPlugins.${package} ];

    #     # TODO: actually put config into lua code
    #     # extraConfigLua = ''
    #     #   require('cmp').setup {
    #     #     sources = {
    #     #       { name = '${name}' },
    #     #     }
    #     #   }
    #     # '';
    #   };
    # };
in mapAttrs (sourceName: package: toSourceModule sourceName package) sourceNameAndPlugin

  # mkOption {
  #   default = null;
  #   type = nullOr (either (listOf optionsFormat) (listOf (listOf optionsFormat)));
  #   description = ''
  #     The sources to use.
  #     Can either be a list of sourceConfigs which will be made directly to a Lua object.
  #     Or it can be a list of lists, which will use the cmp built-in helper function `cmp.config.sources`.
  #     '';
  #   example = ''
  #     [
  #       { name = "nvim_lsp"; }
  #       { name = "luasnip"; } #For luasnip users.
  #       { name = "path"; }
  #       { name = "buffer"; }
  #     ]
  #       '';
  # }
# }
