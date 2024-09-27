{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "everforest";
  isColorscheme = true;
  globalPrefix = "everforest_";

  maintainers = [ lib.maintainers.sheemap ];

  settingsOptions = {
    background =
      defaultNullOpts.mkEnum
        [
          "hard"
          "medium"
          "soft"
        ]
        "medium"
        ''
          The background contrast used in this color scheme.
        '';

    enable_italic = defaultNullOpts.mkFlagInt 0 ''
      To enable italic in this color scheme, set this option to `1`.
    '';

    disable_italic_comment = defaultNullOpts.mkFlagInt 0 ''
      By default, italic is enabled in `Comment`. To disable italic in `Comment`, set this option to `1`
    '';

    cursor =
      defaultNullOpts.mkEnumFirstDefault
        [
          "auto"
          "red"
          "orange"
          "yellow"
          "green"
          "aqua"
          "blue"
          "purple"
        ]
        ''
          Customize the cursor color, only works in GUI clients.
        '';

    transparent_background =
      defaultNullOpts.mkEnumFirstDefault
        [
          0
          1
          2
        ]
        ''
          To use transparent background, set this option to `1`.

          If you want more ui components to be transparent (for example, status line
          background), set this option to `2`.
        '';

    dim_inactive_windows = defaultNullOpts.mkFlagInt 0 ''
      Dim inactive windows. Only works in Neovim currently.

      When this option is used in conjunction with |g:everforest_show_eob| set to 0,
      the end of the buffer will only be hidden inside the active window. Inside
      inactive windows, the end of buffer filler characters will be visible in
      dimmed symbols. This is due to the way Vim and Neovim handle |hl-EndOfBuffer|.
    '';

    sign_column_background =
      defaultNullOpts.mkEnumFirstDefault
        [
          "none"
          "grey"
        ]
        ''
          By default, the color of sign column background is the same as normal text
          background, but you can use a grey background by setting this option to `'grey'`.
        '';

    spell_foreground =
      defaultNullOpts.mkEnumFirstDefault
        [
          "none"
          "colored"
        ]
        ''
          By default, this color scheme won't color the foreground of |spell|, instead
          colored under curls will be used. If you also want to color the foreground,
          set this option to `'colored'`.
        '';

    ui_contrast =
      defaultNullOpts.mkEnumFirstDefault
        [
          "low"
          "high"
        ]
        ''
          The contrast of line numbers, indent lines, etc.
        '';

    show_eob = defaultNullOpts.mkFlagInt 1 ''
      Whether to show |hl-EndOfBuffer|.
    '';

    float_style =
      defaultNullOpts.mkEnumFirstDefault
        [
          "bright"
          "dim"
        ]
        ''
          Style used to make floating windows stand out from other windows. `'bright'`
          makes the background of these windows lighter than |hl-Normal|, whereas
          `'dim'` makes it darker.

          Floating windows include for instance diagnostic pop-ups, scrollable
          documentation windows from completion engines, overlay windows from
          installers, etc.
        '';

    diagnostic_text_highlight = defaultNullOpts.mkFlagInt 0 ''
      Some plugins support highlighting error/warning/info/hint texts, by default
      these texts are only underlined, but you can use this option to also highlight
      the background of them.

      Currently, the following plugins are supported:

      - neovim's built-in language server client
      - [coc.nvim](https://github.com/neoclide/coc.nvim)
      - [vim-lsp](https://github.com/prabirshrestha/vim-lsp)
      - [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe)
      - [ale](https://github.com/dense-analysis/ale)
      - [neomake](https://github.com/neomake/neomake)
      - [syntastic](https://github.com/vim-syntastic/syntastic)
    '';

    diagnostic_line_highlight = defaultNullOpts.mkFlagInt 0 ''
      Some plugins support highlighting error/warning/info/hint lines, but this
      feature is disabled by default in this color scheme. To enable this feature,
      set this option to `1`.

      Currently, the following plugins are supported:

      - [coc.nvim](https://github.com/neoclide/coc.nvim)
      - [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe)
      - [ale](https://github.com/dense-analysis/ale)
      - [syntastic](https://github.com/vim-syntastic/syntastic)
    '';

    diagnostic_virtual_text =
      defaultNullOpts.mkEnumFirstDefault
        [
          "grey"
          "colored"
          "highlighted"
        ]
        ''
          Some plugins can use the virtual text feature of Neovim to display
          error/warning/info/hint information. You can use this option to adjust the
          way these virtual texts are highlighted.

          Currently, the following plugins are supported:

          - Neovim's built-in language server client
          - [coc.nvim](https://github.com/neoclide/coc.nvim)
          - [vim-lsp](https://github.com/prabirshrestha/vim-lsp)
          - [ale](https://github.com/dense-analysis/ale)
          - [neomake](https://github.com/neomake/neomake)
          - [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe)
        '';

    current_word =
      defaultNullOpts.mkEnumFirstDefault
        [
          "grey background"
          "bold"
          "underline"
          "italic"
        ]
        ''
          Some plugins can highlight the word under current cursor, you can use this
          option to control their behavior.

          Default value:      `'grey background'` when not in transparent mode, `'bold'`
          when in transparent mode.

          Currently, the following plugins are supported:

          - [coc-highlight](https://github.com/neoclide/coc-highlight)
          - [vim_current_word](https://github.com/dominikduda/vim_current_word)
          - [vim-illuminate](https://github.com/RRethy/vim-illuminate)
          - [vim-cursorword](https://github.com/itchyny/vim-cursorword)
          - [vim-lsp](https://github.com/prabirshrestha/vim-lsp)
        '';

    inlay_hints_background =
      defaultNullOpts.mkEnumFirstDefault
        [
          "none"
          "dimmed"
        ]
        ''
          Inlay hints are special markers that are displayed inline with the code to
          provide you with additional information. You can use this option to customize
          the background color of inlay hints.

          Currently, the following LSP clients are supported:

          - Neovim's built-in language server client
          - [coc.nvim](https://github.com/neoclide/coc.nvim)
          - [vim-lsp](https://github.com/prabirshrestha/vim-lsp)
          - [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe)
        '';

    disable_terminal_colors = defaultNullOpts.mkFlagInt 0 ''
      Setting this option to `1` will disable terminal colors provided by this color
      scheme so you can remain terminal colors the same when using |:terminal| in
      vim and outside of vim.
    '';

    lightline_disable_bold = defaultNullOpts.mkFlagInt 0 ''
      By default, bold is enabled in lightline color scheme. To disable bold in
      lightline color scheme, set this option to `1`.
    '';

    colors_override = defaultNullOpts.mkAttrsOf (lib.types.listOf lib.types.str) { } ''
      Override color palette. The available keys can be found in the plugin's [source code](https://github.com/sainnhe/everforest/blob/master/autoload/everforest.vim)
    '';

  };

  settingsExample = {
    background = "hard";
    dim_inactive_windows = 1;
    colors_override = {
      bg0 = [
        "#202020"
        "234"
      ];
      bg2 = [
        "#282828"
        "235"
      ];
    };
  };

  extraConfig = cfg: { opts.termguicolors = lib.mkDefault true; };
}
