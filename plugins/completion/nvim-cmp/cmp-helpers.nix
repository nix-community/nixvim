{
  lib,
  config,
  pkgs,
  ...
}: let
  helpers = import ../../helpers.nix {inherit lib;};
in
  with helpers;
  with lib; {
    mkCmpSourcePlugin = {
      name,
      extraPlugins ? [],
      useDefaultPackage ? true,
      ...
    }:
      mkPlugin {inherit lib config pkgs;} {
        inherit name;
        extraPlugins = extraPlugins ++ (lists.optional useDefaultPackage pkgs.vimPlugins.${name});
        description = "Enable ${name}";
      };

    pluginAndSourceNames = {
      "luasnip" = "cmp_luasnip";
      "snippy" = "cmp-snippy";
      "ultisnips" = "cmp-nvim-ultisnips";
      "vsnip" = "cmp-vsnip";
      "buffer" = "cmp-buffer";
      "calc" = "cmp-calc";
      "dictionary" = "cmp-dictionary";
      "digraphs" = "cmp-digraphs";
      "omni" = "cmp-omni";
      "spell" = "cmp-spell";
      "nvim_lsp" = "cmp-nvim-lsp";
      "nvim_lsp_document_symbol" = "cmp-nvim-lsp-document-symbol";
      "nvim_lsp_signature_help" = "cmp-nvim-lsp-signature-help";
      "vim_lsp" = "cmp-vim-lsp";
      "path" = "cmp-path";
      "git" = "cmp-git";
      "conventionalcommits" = "cmp-conventionalcommits";
      "cmdline" = "cmp-cmdline";
      "cmp-cmdline-history" = "cmp-cmdline-history";
      "fuzzy_buffer" = "cmp-fuzzy-buffer";
      "fuzzy_path" = "cmp-fuzzy-path";
      "rg" = "cmp-rg";
      "fish" = "cmp-fish";
      "tmux" = "cmp-tmux";
      "zsh" = "cmp-zsh";
      "crates" = "crates-nvim";
      "npm" = "cmp-npm";
      "cmp-clippy" = "cmp-clippy";
      "cmp_tabnine" = "cmp-tabnine";
      "copilot" = "copilot-cmp";
      "dap" = "cmp-dap";
      "emoji" = "cmp-emoji";
      "greek" = "cmp-greek";
      "latex_symbols" = "cmp-latex-symbols";
      "look" = "cmp-look";
      "nvim_lua" = "cmp-nvim-lua";
      "pandoc_references" = "cmp-pandoc-references";
      "cmp_pandoc" = "cmp-pandoc-nvim";
      "treesitter" = "cmp-treesitter";
      "vimwiki-tags" = "cmp-vimwiki-tags";
    };
  }
