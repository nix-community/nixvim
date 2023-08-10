{
  imports = [
    ./bufferlines/barbar.nix
    ./bufferlines/bufferline.nix

    ./colorschemes/ayu.nix
    ./colorschemes/base16.nix
    ./colorschemes/gruvbox.nix
    ./colorschemes/kanagawa.nix
    ./colorschemes/nord.nix
    ./colorschemes/one.nix
    ./colorschemes/onedark.nix
    ./colorschemes/oxocarbon.nix
    ./colorschemes/poimandres.nix
    ./colorschemes/tokyonight.nix
    ./colorschemes/catppuccin.nix
    ./colorschemes/rose-pine.nix

    ./completion/coq.nix
    ./completion/coq-thirdparty.nix
    ./completion/copilot-lua.nix
    ./completion/copilot-vim.nix
    ./completion/nvim-cmp
    ./completion/nvim-cmp/sources
    ./completion/lspkind.nix

    ./filetrees/chadtree.nix
    ./filetrees/neo-tree.nix
    ./filetrees/nvim-tree.nix

    ./git/diffview.nix
    ./git/fugitive.nix
    ./git/gitgutter.nix
    ./git/gitmessenger.nix
    ./git/gitsigns.nix
    ./git/neogit.nix

    ./languages/clangd-extensions.nix
    ./languages/julia/julia-cell.nix
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
    ./languages/treesitter/ts-autotag.nix
    ./languages/treesitter/ts-context-commentstring.nix
    ./languages/typst/typst-vim.nix
    ./languages/vim-slime.nix
    ./languages/vimtex.nix
    ./languages/zig.nix

    ./lsp
    ./lsp/fidget.nix
    ./lsp/inc-rename.nix
    ./lsp/lspsaga.nix
    ./lsp/lsp-format.nix
    ./lsp/lsp-lines.nix
    ./lsp/nvim-lightbulb.nix
    ./lsp/trouble.nix

    ./null-ls

    ./dap

    ./pluginmanagers/packer.nix

    ./snippets/luasnip

    ./statuslines/airline.nix
    ./statuslines/lightline.nix
    ./statuslines/lualine.nix

    ./telescope

    ./ui/noice.nix

    ./utils/alpha.nix
    ./utils/auto-save.nix
    ./utils/auto-session.nix
    ./utils/comment-nvim.nix
    ./utils/commentary.nix
    ./utils/conjure.nix
    ./utils/coverage.nix
    ./utils/cursorline.nix
    ./utils/easyescape.nix
    ./utils/endwise.nix
    ./utils/floaterm.nix
    ./utils/goyo.nix
    ./utils/harpoon.nix
    ./utils/illuminate.nix
    ./utils/indent-blankline.nix
    ./utils/intellitab.nix
    ./utils/lastplace.nix
    ./utils/leap.nix
    ./utils/mark-radar.nix
    ./utils/mini.nix
    ./utils/neorg.nix
    ./utils/neogen.nix
    ./utils/notify.nix
    ./utils/netman.nix
    ./utils/nvim-autopairs.nix
    ./utils/nvim-bqf.nix
    ./utils/nvim-colorizer.nix
    ./utils/nvim-osc52.nix
    ./utils/nvim-ufo.nix
    ./utils/oil.nix
    ./utils/project-nvim.nix
    ./utils/presence-nvim.nix
    ./utils/quickmath.nix
    ./utils/specs.nix
    ./utils/spider.nix
    ./utils/startify.nix
    ./utils/surround.nix
    ./utils/tmux-navigator.nix
    ./utils/todo-comments.nix
    ./utils/toggleterm.nix
    ./utils/undotree.nix
    ./utils/vim-bbye.nix
    ./utils/vim-matchup.nix
    ./utils/dashboard.nix
    ./utils/emmet.nix
    ./utils/magma-nvim.nix
    ./utils/which-key.nix
    ./utils/wilder-nvim.nix
    ./utils/zk.nix
  ];
}
