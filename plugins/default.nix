{
  imports = [
    ./bufferlines/barbar.nix
    ./bufferlines/bufferline.nix

    ./colorschemes/base16.nix
    ./colorschemes/gruvbox.nix
    ./colorschemes/nord.nix
    ./colorschemes/one.nix
    ./colorschemes/onedark.nix
    ./colorschemes/tokyonight.nix

    ./completion/coq.nix
    ./completion/coq-thirdparty.nix
    ./completion/copilot.nix
    ./completion/nvim-cmp
    ./completion/nvim-cmp/sources
    ./completion/lspkind.nix

    ./filetrees/neo-tree.nix
    ./filetrees/nvim-tree.nix

    ./git/fugitive.nix
    ./git/gitgutter.nix
    ./git/gitmessenger.nix
    ./git/gitsigns.nix
    ./git/neogit.nix

    ./languages/clangd-extensions.nix
    ./languages/ledger.nix
    ./languages/markdown-preview.nix
    ./languages/nix.nix
    ./languages/nvim-jdtls.nix
    ./languages/openscad.nix
    ./languages/plantuml-syntax.nix
    ./languages/rust.nix
    ./languages/sniprun.nix
    ./languages/tagbar.nix
    ./languages/treesitter/treesitter.nix
    ./languages/treesitter/treesitter-context.nix
    ./languages/treesitter/treesitter-playground.nix
    ./languages/treesitter/treesitter-rainbow.nix
    ./languages/treesitter/treesitter-refactor.nix
    ./languages/vimtex.nix
    ./languages/zig.nix

    ./null-ls

    ./nvim-lsp
    ./nvim-lsp/inc-rename.nix
    ./nvim-lsp/lspsaga.nix
    ./nvim-lsp/lsp-lines.nix
    ./nvim-lsp/nvim-lightbulb.nix
    ./nvim-lsp/trouble.nix

    ./pluginmanagers/packer.nix

    ./snippets/luasnip

    ./statuslines/airline.nix
    ./statuslines/lightline.nix
    ./statuslines/lualine.nix

    ./telescope

    ./ui/noice.nix

    ./utils/comment-nvim.nix
    ./utils/commentary.nix
    ./utils/easyescape.nix
    ./utils/endwise.nix
    ./utils/floaterm.nix
    ./utils/goyo.nix
    ./utils/harpoon.nix
    ./utils/indent-blankline.nix
    ./utils/intellitab.nix
    ./utils/lastplace.nix
    ./utils/mark-radar.nix
    ./utils/neorg.nix
    ./utils/notify.nix
    ./utils/netman.nix
    ./utils/nvim-autopairs.nix
    ./utils/nvim-bqf.nix
    ./utils/nvim-colorizer.nix
    ./utils/nvim-osc52.nix
    ./utils/project-nvim.nix
    ./utils/presence-nvim.nix
    ./utils/specs.nix
    ./utils/startify.nix
    ./utils/surround.nix
    ./utils/tmux-navigator.nix
    ./utils/todo-comments.nix
    ./utils/undotree.nix
    ./utils/vim-bbye.nix
    ./utils/vim-matchup.nix
    ./utils/dashboard.nix
    ./utils/emmet.nix
    ./utils/magma-nvim.nix
  ];
}
