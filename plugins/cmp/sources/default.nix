{
  lib,
  helpers,
  pkgs,
  ...
}@args:
let

  # A list of most cmp source plugins, passed to mkCmpSourcePlugin.
  # More complex cmp sources can instead be defined as their own plugin
  # and register their source-name association using the `cmpSourcePlugins` option.
  sources = [
    {
      pluginName = "cmp-async-path";
      sourceName = "async_path";
    }
    {
      pluginName = "cmp-buffer";
      sourceName = "buffer";
    }
    {
      pluginName = "cmp-calc";
      sourceName = "calc";
    }
    {
      pluginName = "cmp-clippy";
      sourceName = "cmp-clippy";
    }
    {
      pluginName = "cmp-cmdline";
      sourceName = "cmdline";
    }
    {
      pluginName = "cmp-cmdline-history";
      sourceName = "cmp-cmdline-history";
    }
    {
      pluginName = "cmp-conventionalcommits";
      sourceName = "conventionalcommits";
    }
    {
      pluginName = "cmp-dap";
      sourceName = "dap";
    }
    {
      pluginName = "cmp-dictionary";
      sourceName = "dictionary";
    }
    {
      pluginName = "cmp-digraphs";
      sourceName = "digraphs";
    }
    {
      pluginName = "cmp-emoji";
      sourceName = "emoji";
    }
    {
      pluginName = "cmp-fish";
      sourceName = "fish";

      extraOptions.fishPackage = lib.mkPackageOption pkgs "fish" { nullable = true; };
      extraConfig = cfg: { extraPackages = [ cfg.fishPackage ]; };
    }
    {
      pluginName = "cmp-fuzzy-buffer";
      sourceName = "fuzzy_buffer";
    }
    {
      pluginName = "cmp-fuzzy-path";
      sourceName = "fuzzy_path";
    }
    {
      pluginName = "cmp-greek";
      sourceName = "greek";
    }
    {
      pluginName = "cmp-latex-symbols";
      sourceName = "latex_symbols";
    }
    {
      pluginName = "cmp-look";
      sourceName = "look";
    }
    {
      pluginName = "cmp_luasnip";
      sourceName = "luasnip";
    }
    {
      pluginName = "cmp-nixpkgs-maintainers";
      sourceName = "nixpkgs_maintainers";
    }
    {
      pluginName = "cmp-npm";
      sourceName = "npm";
    }
    {
      pluginName = "cmp-nvim-lsp";
      sourceName = "nvim_lsp";
    }
    {
      pluginName = "cmp-nvim-lsp-document-symbol";
      sourceName = "nvim_lsp_document_symbol";
    }
    {
      pluginName = "cmp-nvim-lsp-signature-help";
      sourceName = "nvim_lsp_signature_help";
    }
    {
      pluginName = "cmp-nvim-lua";
      sourceName = "nvim_lua";
    }
    {
      pluginName = "cmp-nvim-ultisnips";
      sourceName = "ultisnips";
    }
    {
      pluginName = "cmp-omni";
      sourceName = "omni";
    }
    {
      pluginName = "cmp-pandoc-nvim";
      sourceName = "cmp_pandoc";
    }
    {
      pluginName = "cmp-pandoc-references";
      sourceName = "pandoc_references";
    }
    {
      pluginName = "cmp-path";
      sourceName = "path";
    }
    {
      pluginName = "cmp-rg";
      sourceName = "rg";
    }
    {
      pluginName = "cmp-snippy";
      sourceName = "snippy";
    }
    {
      pluginName = "cmp-spell";
      sourceName = "spell";
    }
    {
      pluginName = "cmp-tmux";
      sourceName = "tmux";
    }
    {
      pluginName = "cmp-treesitter";
      sourceName = "treesitter";
    }
    {
      pluginName = "cmp-vim-lsp";
      sourceName = "vim_lsp";
    }
    {
      pluginName = "cmp-vimtex";
      sourceName = "vimtex";
    }
    {
      pluginName = "cmp-vimwiki-tags";
      sourceName = "vimwiki-tags";
    }
    {
      pluginName = "cmp-vsnip";
      sourceName = "vsnip";
    }
    {
      pluginName = "cmp_yanky";
      sourceName = "yanky";
    }
    {
      pluginName = "cmp-zsh";
      sourceName = "zsh";
    }
    {
      pluginName = "crates-nvim";
      sourceName = "crates";
    }
  ];

  mkCmpSourcePlugin = import ./_mk-cmp-plugin.nix args;
  pluginModules = builtins.map mkCmpSourcePlugin sources;
in
{
  # For extra cmp plugins
  imports = [
    ./crates-nvim.nix
  ] ++ pluginModules;
}
