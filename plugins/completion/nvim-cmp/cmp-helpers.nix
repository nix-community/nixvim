{ lib, pkgs, config, ... }@attrs:

with lib;

let
  helpers = import ../../helpers.nix { inherit lib config; };

in with helpers;
rec {
  # mkCmpSourcePlugin = { name, extraPlugins ? [], useDefaultPackage ? true, ... }: mkPlugin attrs {
  #   inherit name;
  #   extraPlugins = extraPlugins ++ (lists.optional useDefaultPackage pkgs.vimExtraPlugins.${name});
  #   description = "Enable ${name}";
  # };

  # value is string (package name) or a set of form '{ package = "..."; extraConfig = "..."; }'
  # the former is needed if source needs extra config like the crates-nvim source
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
    "crates" = { package = "crates-nvim"; extraConfig = "require('crates').setup()"; };
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
    "luasnip" = "cmp-luasnip";
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

  # create a list off all packages of all activated sources for extraPackgs
  sourcePackages = attrs:
    let
      packageList = mapAttrsToList (sourceName: _option:
        if isNull attrs.${sourceName} then
          null
        else if attrs.${sourceName}.enable then
          let
            value = sourceNameAndPlugin.${sourceName};
            package =
              if isString value then
                value
              else
                value.package;
          in pkgs.vimExtraPlugins.${package}
        else
          null
        ) attrs;
    in filter (p: !(isNull p)) packageList;

  # create a list off all activated sources for cmp lua config
  sourceConfig = attrs:
    let
      packageList = mapAttrsToList (sourceName: _option:
        if isNull attrs.${sourceName} then
          null
        else if attrs.${sourceName}.enable then
          { name = sourceName; }
        else
          null
        ) attrs;
    in filter (p: !(isNull p)) packageList;

  # create a list off all extraConfig of activated sources for extraConfig of cmp module
  sourceExtraConfig = attrs:
    let
      packageList = mapAttrsToList (sourceName: option:
        if isNull attrs.${sourceName} then
          null
        else if attrs.${sourceName}.enable then
          let
            value = sourceNameAndPlugin.${sourceName};
          in if isString value then
                null
              else
                value.extraConfig
        else
          null
        ) attrs;
    in concatStringsSep "\n" (filter (p: !(isNull p)) packageList);
}
