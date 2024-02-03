{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with helpers.vim-plugin;
with lib; rec {
  mkCmpSourcePlugin = {
    name,
    extraPlugins ? [],
    useDefaultPackage ? true,
    ...
  }:
    mkVimPlugin config {
      inherit name;
      extraPlugins = extraPlugins ++ (lists.optional useDefaultPackage pkgs.vimPlugins.${name});

      maintainers = [maintainers.GaetanLepage];
    };

  pluginAndSourceNames = {
    "buffer" = "cmp-buffer";
    "calc" = "cmp-calc";
    "dap" = "cmp-dap";
    "cmdline" = "cmp-cmdline";
    "cmp-clippy" = "cmp-clippy";
    "cmp-cmdline-history" = "cmp-cmdline-history";
    "cmp_pandoc" = "cmp-pandoc-nvim";
    "cmp_tabby" = "cmp-tabby";
    "cmp_tabnine" = "cmp-tabnine";
    "codeium" = "codeium-nvim";
    "conventionalcommits" = "cmp-conventionalcommits";
    "copilot" = "copilot-cmp";
    "crates" = "crates-nvim";
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
    "nvim_lsp" = "cmp-nvim-lsp";
    "nvim_lsp_document_symbol" = "cmp-nvim-lsp-document-symbol";
    "nvim_lsp_signature_help" = "cmp-nvim-lsp-signature-help";
    "nvim_lua" = "cmp-nvim-lua";
    "npm" = "cmp-npm";
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

  extractSourcesFromOptionValue = sources:
    if isList sources
    then sources
    else [];

  autoInstallSourcePluginsModule = cfg: let
    # cfg.setup.sources
    setupSources = extractSourcesFromOptionValue cfg.settings.sources;
    # cfg.filetype.<name>.sources
    filetypeSources =
      mapAttrsToList
      (_: filetypeConfig:
        extractSourcesFromOptionValue filetypeConfig.sources)
      cfg.filetype;
    # cfg.cmdline.<name>.sources
    cmdlineSources =
      mapAttrsToList
      (_: cmdlineConfig:
        extractSourcesFromOptionValue cmdlineConfig.sources)
      cfg.cmdline;

    # [{name = "foo";} {name = "bar"; x = 42;} ...]
    allSources = flatten (setupSources ++ filetypeSources ++ cmdlineSources);

    # Take only the names from the sources provided by the user
    # ["foo" "bar"]
    foundSources =
      lists.unique
      (
        map
        (source: source.name)
        allSources
      );

    # A list of known source names
    knownSourceNames = attrNames pluginAndSourceNames;
    attrsEnabled = listToAttrs (map
      (name: {
        # Name of the corresponding plugin to enable
        name = pluginAndSourceNames.${name};
        # Whether or not we enable it
        value.enable = mkIf (elem name foundSources) true;
      })
      knownSourceNames);
    lspCapabilities =
      mkIf
      (elem "nvim_lsp" foundSources)
      {
        lsp.capabilities = ''
          capabilities = vim.tbl_deep_extend("force", capabilities, require('cmp_nvim_lsp').default_capabilities())
        '';
      };
  in
    mkMerge [
      (mkIf cfg.autoEnableSources attrsEnabled)
      lspCapabilities
    ];
}
