{
  imports = [
    ./bufferlines/barbar.nix
    ./bufferlines/barbecue.nix
    ./bufferlines/bufferline.nix
    ./bufferlines/navic.nix

    ./colorschemes/ayu.nix
    ./colorschemes/base16
    ./colorschemes/catppuccin.nix
    ./colorschemes/dracula.nix
    ./colorschemes/gruvbox.nix
    ./colorschemes/kanagawa.nix
    ./colorschemes/melange.nix
    ./colorschemes/nord.nix
    ./colorschemes/one.nix
    ./colorschemes/onedark.nix
    ./colorschemes/oxocarbon.nix
    ./colorschemes/palette.nix
    ./colorschemes/poimandres.nix
    ./colorschemes/rose-pine.nix
    ./colorschemes/tokyonight.nix
    ./colorschemes/vscode.nix

    ./completion/codeium-vim.nix
    ./completion/copilot-lua.nix
    ./completion/copilot-vim.nix
    ./completion/coq.nix
    ./completion/coq-thirdparty.nix
    ./completion/lspkind.nix
    ./completion/cmp

    ./dap

    ./filetrees/chadtree.nix
    ./filetrees/neo-tree.nix
    ./filetrees/nvim-tree.nix

    ./git/committia.nix
    ./git/diffview.nix
    ./git/fugitive.nix
    ./git/git-worktree.nix
    ./git/gitblame.nix
    ./git/gitgutter.nix
    ./git/gitignore.nix
    ./git/gitlinker.nix
    ./git/gitmessenger.nix
    ./git/gitsigns
    ./git/neogit

    ./languages/clangd-extensions.nix
    ./languages/debugprint.nix
    ./languages/haskell-scope-highlighting.nix
    ./languages/helm.nix
    ./languages/julia/julia-cell.nix
    ./languages/lean.nix
    ./languages/ledger.nix
    ./languages/lint.nix
    ./languages/ltex-extra.nix
    ./languages/markdown-preview.nix
    ./languages/nix.nix
    ./languages/nvim-jdtls.nix
    ./languages/openscad.nix
    ./languages/parinfer-rust.nix
    ./languages/plantuml-syntax.nix
    ./languages/python/jupytext.nix
    ./languages/qmk.nix
    ./languages/rust-tools.nix
    ./languages/rustaceanvim.nix
    ./languages/sniprun.nix
    ./languages/tagbar.nix
    ./languages/treesitter/hmts.nix
    ./languages/treesitter/rainbow-delimiters.nix
    ./languages/treesitter/treesitter-context.nix
    ./languages/treesitter/treesitter-playground.nix
    ./languages/treesitter/treesitter-refactor.nix
    ./languages/treesitter/treesitter-textobjects.nix
    ./languages/treesitter/treesitter.nix
    ./languages/treesitter/ts-autotag.nix
    ./languages/treesitter/ts-context-commentstring.nix
    ./languages/typescript-tools.nix
    ./languages/typst/typst-vim.nix
    ./languages/vim-slime.nix
    ./languages/vimtex.nix
    ./languages/zig.nix

    ./lsp
    ./lsp/conform-nvim.nix
    ./lsp/fidget.nix
    ./lsp/inc-rename.nix
    ./lsp/lspsaga.nix
    ./lsp/lsp-format.nix
    ./lsp/lsp-lines.nix
    ./lsp/nvim-lightbulb.nix
    ./lsp/trouble.nix
    ./lsp/wtf.nix

    ./neotest

    ./none-ls

    ./pluginmanagers/packer.nix
    ./pluginmanagers/lazy.nix

    ./snippets/friendly-snippets.nix
    ./snippets/luasnip

    ./statuslines/airline.nix
    ./statuslines/lightline.nix
    ./statuslines/lualine.nix

    ./telescope

    ./ui/headlines.nix
    ./ui/image.nix
    ./ui/neoscroll.nix
    ./ui/noice.nix
    ./ui/statuscol.nix
    ./ui/transparent.nix
    ./ui/twilight.nix
    ./ui/virt-column.nix
    ./ui/zen-mode.nix

    ./utils/alpha.nix
    ./utils/auto-save.nix
    ./utils/auto-session.nix
    ./utils/autoclose.nix
    ./utils/bacon.nix
    ./utils/baleia.nix
    ./utils/better-escape.nix
    ./utils/ccc.nix
    ./utils/clipboard-image.nix
    ./utils/comment.nix
    ./utils/commentary.nix
    ./utils/conjure.nix
    ./utils/coverage.nix
    ./utils/cursorline.nix
    ./utils/dashboard.nix
    ./utils/direnv.nix
    ./utils/dressing.nix
    ./utils/easyescape.nix
    ./utils/emmet.nix
    ./utils/endwise.nix
    ./utils/flash.nix
    ./utils/floaterm.nix
    ./utils/fzf-lua.nix
    ./utils/goyo.nix
    ./utils/hardtime.nix
    ./utils/harpoon.nix
    ./utils/hop.nix
    ./utils/illuminate.nix
    ./utils/improved-search.nix
    ./utils/indent-blankline.nix
    ./utils/indent-o-matic.nix
    ./utils/instant.nix
    ./utils/intellitab.nix
    ./utils/lastplace.nix
    ./utils/leap.nix
    ./utils/magma-nvim.nix
    ./utils/mark-radar.nix
    ./utils/marks.nix
    ./utils/mini.nix
    ./utils/mkdnflow.nix
    ./utils/molten.nix
    ./utils/multicursors.nix
    ./utils/navbuddy.nix
    ./utils/neocord.nix
    ./utils/neogen.nix
    ./utils/neorg.nix
    ./utils/netman.nix
    ./utils/nix-develop.nix
    ./utils/notify.nix
    ./utils/nvim-autopairs.nix
    ./utils/nvim-bqf.nix
    ./utils/nvim-colorizer.nix
    ./utils/nvim-osc52.nix
    ./utils/nvim-ufo.nix
    ./utils/obsidian
    ./utils/oil.nix
    ./utils/ollama.nix
    ./utils/persistence.nix
    ./utils/presence-nvim.nix
    ./utils/project-nvim.nix
    ./utils/quickmath.nix
    ./utils/refactoring.nix
    ./utils/rest.nix
    ./utils/sandwich.nix
    ./utils/sleuth.nix
    ./utils/smart-splits.nix
    ./utils/specs.nix
    ./utils/spider.nix
    ./utils/startify
    ./utils/startup.nix
    ./utils/surround.nix
    ./utils/tmux-navigator.nix
    ./utils/todo-comments.nix
    ./utils/toggleterm.nix
    ./utils/undotree.nix
    ./utils/vim-bbye.nix
    ./utils/vim-css-color.nix
    ./utils/vim-matchup.nix
    ./utils/which-key.nix
    ./utils/wilder.nix
    ./utils/yanky.nix
    ./utils/zellij.nix
    ./utils/zk.nix
  ];
}
