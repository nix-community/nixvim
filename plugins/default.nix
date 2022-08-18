{
  imports = [
    ./bufferlines/barbar.nix
    ./bufferlines/bufferline.nix
    ./bufferlines/tabby.nix

    ./colorschemes/base16.nix
    ./colorschemes/gruvbox.nix
    ./colorschemes/nord.nix
    ./colorschemes/one.nix
    ./colorschemes/onedark.nix
    ./colorschemes/tokyonight.nix

    ./completion/coq.nix
    ./completion/nvim-cmp
    ./completion/nvim-cmp/sources

    ./git/fugitive.nix
    ./git/gitgutter.nix
    ./git/neogit.nix

    ./languages/ledger.nix
    ./languages/nix.nix
    ./languages/treesitter.nix
    ./languages/zig.nix

    ./null-ls

    ./nvim-lsp
    ./nvim-lsp/lspsaga.nix

    ./pluginmanagers/packer.nix

    ./statuslines/airline.nix
    ./statuslines/lightline.nix
    ./statuslines/lualine.nix

    ./telescope

    ./utils/asyncrun.nix
    ./utils/comment-nvim.nix
    ./utils/commentary.nix
    ./utils/dashboard.nix
    ./utils/easyescape.nix
    ./utils/emmet.nix
    ./utils/endwise.nix
    ./utils/floaterm.nix
    ./utils/focus.nix
    ./utils/goyo.nix
    ./utils/headlines.nix
    ./utils/intellitab.nix
    ./utils/lspkind.nix
    ./utils/mark-radar.nix
    ./utils/nerdcommenter.nix
    ./utils/notify.nix
    ./utils/nvim-autopairs.nix
    ./utils/nvim-tree.nix
    ./utils/specs.nix
    ./utils/stabilize.nix
    ./utils/startify.nix
    ./utils/surround.nix
    ./utils/tagbar.nix
    ./utils/todo-comments.nix
    ./utils/trouble.nix
    ./utils/undotree.nix
    ./utils/vimwiki.nix
  ];
}
