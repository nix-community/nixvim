lib:
let
  inherit (lib) types;
  inherit (lib.nixvim)
    defaultNullOpts
    literalLua
    mkNullOrOption
    mkNullOrOption'
    ;
in
{
  enabled = defaultNullOpts.mkRaw' {
    pluginDefault = ''
      function()
        return vim.bo.buftype ~= 'prompt' and vim.b.completion ~= false
      end
    '';
    example = ''
      function()
        return not vim.tbl_contains({ "lua", "markdown" }, vim.bo.filetype)
          and vim.bo.buftype ~= "prompt"
          and vim.b.completion ~= false
      end
    '';
    description = ''
      A function that returns whether blink-cmp should be enabled or not for this buffer.
    '';
  };

  keymap = defaultNullOpts.mkNullableWithRaw' {
    type = with types; either (attrsOf anything) (enum [ false ]);
    pluginDefault = {
      preset = "default";
    };
    example = {
      "<C-space>" = [
        "show"
        "show_documentation"
        "hide_documentation"
      ];
      "<C-e>" = [ "hide" ];
      "<C-y>" = [ "select_and_accept" ];

      "<Up>" = [
        "select_prev"
        "fallback"
      ];
      "<Down>" = [
        "select_next"
        "fallback"
      ];
      "<C-p>" = [
        "select_prev"
        "fallback"
      ];
      "<C-n>" = [
        "select_next"
        "fallback"
      ];

      "<C-b>" = [
        "scroll_documentation_up"
        "fallback"
      ];
      "<C-f>" = [
        "scroll_documentation_down"
        "fallback"
      ];

      "<Tab>" = [
        "snippet_forward"
        "fallback"
      ];
      "<S-Tab>" = [
        "snippet_backward"
        "fallback"
      ];

    };
    description = ''
      The keymap can be:
      - A preset (`'default'` | `'super-tab'` | `'enter'`)
      - A table of `keys => command[]` (optionally with a "preset" key to merge with a preset)
      When specifying 'preset' in the keymap table, the custom key mappings are merged with the preset,
      and any conflicting keys will overwrite the preset mappings.
    '';
  };

  completion = {
    keyword = {
      range = defaultNullOpts.mkEnumFirstDefault [ "prefix" "full" ] ''
        - `"prefix"` will fuzzy match on the text before the cursor
        - `"full"` will fuzzy match on the text before *and* after the cursor

        Example: `"foo_|_bar"` will match `"foo_"` for `"prefix"` and `"foo__bar"` for `"full"`.
      '';

      regex = defaultNullOpts.mkStr "[-_]\\|\\k" ''
        Regex used to get the text when fuzzy matching.
      '';

      exclude_from_prefix_regex = defaultNullOpts.mkStr "-" ''
        After matching with regex, any characters matching this regex at the prefix will be
        excluded.
      '';
    };

    trigger = {
      prefetch_on_insert = defaultNullOpts.mkBool false ''
        When `true`, will prefetch the completion items when entering insert mode.
        WARN: buggy, not recommended unless you'd like to help develop prefetching.
      '';

      show_in_snippet = defaultNullOpts.mkBool true ''
        When `false`, will not show the completion window when in a snippet.
      '';

      show_on_keyword = defaultNullOpts.mkBool true ''
        When `true`, will show the completion window after typing a character that matches the
        `keyword.regex`.
      '';

      show_on_trigger_character = defaultNullOpts.mkBool true ''
        When `true`, will show the completion window after typing a trigger character.
      '';

      show_on_blocked_trigger_characters =
        defaultNullOpts.mkListOf types.str
          (literalLua ''
            function()
              if vim.api.nvim_get_mode().mode == 'c' then return {} end
                return { ' ', '\n', '\t' }
              end
          '')
          ''
            LSPs can indicate when to show the completion window via trigger characters.

            However, some LSPs (i.e. tsserver) return characters that would essentially always
            show the window.
            We block these by default.
          '';

      show_on_accept_on_trigger_character = defaultNullOpts.mkBool true ''
        When both this and `show_on_trigger_character` are `true`, will show the completion window
        when the cursor comes after a trigger character after accepting an item.
      '';

      show_on_insert_on_trigger_character = defaultNullOpts.mkBool true ''
        When both this and `show_on_trigger_character` are `true`, will show the completion window
        when the cursor comes after a trigger character when entering insert mode.
      '';

      show_on_x_blocked_trigger_characters =
        defaultNullOpts.mkListOf types.str [ "'" ''"'' "(" "{" "[" ]
          ''
            List of trigger characters (on top of `show_on_blocked_trigger_characters`) that won't
            trigger the completion window when the cursor comes after a trigger character when
            entering insert mode/accepting an item
          '';
    };

    list = {
      max_items = defaultNullOpts.mkUnsignedInt 200 ''
        Maximum number of items to display.
      '';

      selection = defaultNullOpts.mkEnumFirstDefault [ "preselect" "manual" "autoinsert" ] ''
        Controls if completion items will be selected automatically, and whether selection
        automatically inserts.
      '';

      cycle = {
        from_bottom = defaultNullOpts.mkBool true ''
          When `true`, calling `select_next` at the **bottom** of the completion list will select
          the **first** completion item.
        '';

        from_top = defaultNullOpts.mkBool true ''
          When `true`, calling `select_prev` at the **top** of the completion list will select the
          **last** completion item.
        '';
      };
    };

    accept = {
      create_undo_point = defaultNullOpts.mkBool true ''
        Create an undo point when accepting a completion item.
      '';

      auto_brackets = {
        enabled = defaultNullOpts.mkBool true ''
          Whether to auto-insert brackets for functions.
        '';

        default_brackets = defaultNullOpts.mkListOf types.str [ "(" ")" ] ''
          Default brackets to use for unknown languages.
        '';

        override_brackets_for_filetypes = defaultNullOpts.mkAttrsOf (with types; listOf str) { } ''
          Brackets override per filetype.
        '';

        force_allow_filetypes = defaultNullOpts.mkListOf types.str [ ] ''
          Overrides the default blocked filetypes.
        '';

        blocked_filetypes = defaultNullOpts.mkListOf types.str [ ] ''
          Blocked filetypes.
        '';

        kind_resolution = {
          enabled = defaultNullOpts.mkBool true ''
            Synchronously use the kind of the item to determine if brackets should be added.
          '';

          blocked_filetypes =
            defaultNullOpts.mkListOf types.str
              [
                "typescriptreact"
                "javascriptreact"
                "vue"
                "rust"
              ]
              ''
                Blocked filetypes.
              '';
        };

        semantic_token_resolution = {
          enabled = defaultNullOpts.mkBool true ''
            Asynchronously use semantic token to determine if brackets should be added
          '';

          blocked_filetypes =
            defaultNullOpts.mkListOf types.str
              [
                "java"
              ]
              ''
                Blocked filetypes.
              '';

          timeout_ms = defaultNullOpts.mkUnsignedInt 400 ''
            How long to wait for semantic tokens to return before assuming no brackets should be added.
          '';
        };
      };
    };

    menu = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable the completion menu.
      '';

      min_width = defaultNullOpts.mkUnsignedInt 15 ''
        Minimum width of the completion menu.
      '';

      max_height = defaultNullOpts.mkUnsignedInt 10 ''
        Maximum width of the completion menu.
      '';

      border = defaultNullOpts.mkNullable types.anything "none" ''
        Border settings.
      '';

      winblend = defaultNullOpts.mkUnsignedInt 0 ''
        `winblend` value for the completion menu.
      '';

      winhighlight = defaultNullOpts.mkStr "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None" ''
        Highlight groups for the completion menu.
      '';

      scrolloff = defaultNullOpts.mkUnsignedInt 2 ''
        Keep the cursor X lines away from the top/bottom of the window.
      '';

      scrollbar = defaultNullOpts.mkBool true ''
        Note that the gutter will be disabled when `border != "none"`.
      '';

      direction_priority =
        defaultNullOpts.mkListOf
          (types.enum [
            "n"
            "s"
          ])
          [ "s" "n" ]
          ''
            Which directions to show the window, falling back to the next direction when there's not
            enough space.
          '';

      order = {
        n = defaultNullOpts.mkEnum [ "top_down" "bottom_up" ] "bottom_up" ''
          Warning: not yet implemented.
        '';

        s = defaultNullOpts.mkEnum [ "top_down" "bottom_up" ] "top_down" ''
          Warning: not yet implemented.
        '';
      };

      auto_show = defaultNullOpts.mkBool true ''
        Whether to automatically show the window when new completion items are available.
      '';

      cmdline_position =
        defaultNullOpts.mkRaw
          ''
            function()
              if vim.g.ui_cmdline_pos ~= nil then
                local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
                return { pos[1] - 1, pos[2] }
              end
              local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
              return { vim.o.lines - height, 0 }
            end
          ''
          ''
            Screen coordinates (0-indexed) of the command line.
          '';

      draw = mkNullOrOption (with types; attrsOf anything) ''
        Controls how the completion items are rendered on the popup window.
      '';
    };

    documentation = {
      auto_show = defaultNullOpts.mkBool false ''
        Controls whether the documentation window will automatically show when selecting a
        completion item.
      '';

      auto_show_delay_ms = defaultNullOpts.mkUnsignedInt 500 ''
        Delay before showing the documentation window.
      '';

      update_delay_ms = defaultNullOpts.mkUnsignedInt 50 ''
        Delay before updating the documentation window when selecting a new item, while an existing
        item is still visible.
      '';

      treesitter_highlighting = defaultNullOpts.mkBool true ''
        Whether to use treesitter highlighting, disable if you run into performance issues.
      '';

      window = {
        min_width = defaultNullOpts.mkUnsignedInt 10 ''
          Minimum width of the documentation window.
        '';

        max_width = defaultNullOpts.mkUnsignedInt 80 ''
          Maximum width of the documentation window.
        '';

        max_height = defaultNullOpts.mkUnsignedInt 20 ''
          Maximum height of the documentation window.
        '';

        desired_min_width = defaultNullOpts.mkUnsignedInt 50 ''
          Desired minimum width of the documentation window.
        '';

        desired_min_height = defaultNullOpts.mkUnsignedInt 10 ''
          Desired minimum height of the documentation window.
        '';

        border = defaultNullOpts.mkNullable types.anything "padded" ''
          Border settings for the documentation window.
        '';

        winblend = defaultNullOpts.mkUnsignedInt 0 ''
          `winblend` value.
        '';

        winhighlight = defaultNullOpts.mkStr "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc" ''
          Highlight groups for the documentation window.
        '';

        scrollbar = defaultNullOpts.mkBool true ''
          Whether to enable `scrollbar` in the documentation window.
        '';

        direction_priority =
          let
            mkDirection = defaultNullOpts.mkListOf (
              types.enum [
                "n"
                "s"
                "e"
                "w"
              ]
            );
          in
          {
            menu_north = mkDirection [ "e" "w" "n" "s" ] ''
              Which directions to show the window, for the _north_ menu window direction, falling
              back to the next direction when there's not enough space.
            '';

            menu_south = mkDirection [ "e" "w" "s" "n" ] ''
              Which directions to show the window, for the _south_ menu window direction, falling
              back to the next direction when there's not enough space.
            '';
          };
      };
    };

    ghost_text = {
      enabled = defaultNullOpts.mkBool false ''
        Displays a preview of the selected item on the current line.
      '';
    };
  };

  fuzzy = {
    use_typo_resistance = defaultNullOpts.mkBool true ''
      When enabled, allows for a number of typos relative to the length of the query.
      Disabling this matches the behavior of fzf.
    '';

    use_frecency = defaultNullOpts.mkBool true ''
      Tracks the most recently/frequently used items and boosts the score of the item.
    '';

    use_proximity = defaultNullOpts.mkBool true ''
      Boosts the score of items matching nearby words.
    '';

    use_unsafe_no_lock = defaultNullOpts.mkBool false ''
      UNSAFE!! When enabled, disables the lock and fsync when writing to the frecency database.
      This should only be used on unsupported platforms (i.e. alpine termux).
    '';

    sorts =
      defaultNullOpts.mkListOf
        (types.enum [
          "label"
          "sort_text"
          "kind"
          "score"
        ])
        [ "score" "sort_text" ]
        ''
          Controls which sorts to use and in which order, these three are currently the only allowed options
        '';

    prebuilt_binaries = {
      download = defaultNullOpts.mkBool true ''
        Whenther or not to automatically download a prebuilt binary from github.
        If this is set to `false` you will need to manually build the fuzzy binary dependencies by
        running `cargo build --release`.
      '';

      ignore_version_mismatch = defaultNullOpts.mkBool false ''
        Ignores mismatched version between the built binary and the current git sha, when building
        locally.
      '';

      force_version = defaultNullOpts.mkStr null ''
        When downloading a prebuilt binary, force the downloader to resolve this version.

        If this is unset then the downloader will attempt to infer the version from the checked out
        git tag (if any).

        WARN: Beware that `main` may be incompatible with the version you select.
      '';

      force_system_triple = defaultNullOpts.mkStr null ''
        When downloading a prebuilt binary, force the downloader to use this system triple.

        If this is unset then the downloader will attempt to infer the system triple from `jit.os`
        and `jit.arch`.
        Check the latest release for all available system triples.

        WARN: Beware that `main` may be incompatible with the version you select
      '';

      extra_curl_args = defaultNullOpts.mkListOf types.str [ ] ''
        Extra arguments that will be passed to curl like
        `[ "curl" ..extra_curl_args ..built_in_args ]`.
      '';
    };
  };

  sources = {
    default = defaultNullOpts.mkListOf types.str [ "lsp" "path" "snippets" "buffer" ] ''
      Default sources.
    '';

    per_filetype = defaultNullOpts.mkAttrsOf (with types; attrsOf str) { } ''
      Sources per filetype.
    '';

    cmdline =
      defaultNullOpts.mkListOf types.str
        (literalLua ''
          function()
            local type = vim.fn.getcmdtype()
            -- Search forward and backward
            if type == '/' or type == '?' then return { 'buffer' } end
            -- Commands
            if type == ':' then return { 'cmdline' } end
            return {}
          end
        '')
        ''
          `cmdline` or `buffer`.
        '';

    transform_items = defaultNullOpts.mkRaw "function(_, items) return items end" ''
      Function to transform the items before they're returned.
    '';

    min_keyword_length = defaultNullOpts.mkUnsignedInt 0 ''
      Minimum number of characters in the keyword to trigger.
    '';

    providers = mkNullOrOption' {
      type = with types; attrsOf (import ./provider-config.nix lib);
      description = ''
        Definition of completion providers.
      '';
      example = {
        buffer.score_offset = -7;
        lsp.fallbacks = [ ];
      };
    };
  };

  signature = {
    enabled = defaultNullOpts.mkBool false ''
      Whether to enable experimental signature help support.
    '';

    trigger = {
      enabled = defaultNullOpts.mkBool true ''
        Whether to enable signature trigger.
      '';

      blocked_trigger_characters = defaultNullOpts.mkListOf types.str [ ] ''
        Blocked trigger characters.
      '';

      blocked_retrigger_characters = defaultNullOpts.mkListOf types.str [ ] ''
        Blocked retrigger characters.
      '';

      show_on_insert_on_trigger_character = defaultNullOpts.mkBool true ''
        When `true`, will show the signature help window when the cursor comes after a trigger
        character when entering insert mode.
      '';
    };

    window = {
      min_width = defaultNullOpts.mkUnsignedInt 1 ''
        Minimum width of the signature window.
      '';

      max_width = defaultNullOpts.mkUnsignedInt 100 ''
        Maximum width of the signature window.
      '';

      max_height = defaultNullOpts.mkUnsignedInt 10 ''
        Maximum height of the signature window.
      '';

      border = defaultNullOpts.mkNullable types.anything "padded" ''
        Border settings for the signature window.
      '';

      winblend = defaultNullOpts.mkUnsignedInt 0 ''
        `winblend` value for the signature window.
      '';

      winhighlight = defaultNullOpts.mkStr "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder" ''
        Highlight groups for the signature window.
      '';

      scrollbar = defaultNullOpts.mkBool false ''
        Note that the gutter will be disabled when `border != "none"`.
      '';

      direction_priority =
        defaultNullOpts.mkListOf
          (types.enum [
            "n"
            "s"
          ])
          [ "n" "s" ]
          ''
            Which directions to show the window, falling back to the next direction when there's not
            enough space, or another window is in the way.
          '';

      treesitter_highlighting = defaultNullOpts.mkBool true ''
        Disable if you run into performance issues.
      '';
    };
  };

  snippets = {
    expand = defaultNullOpts.mkRaw "function(snippet) vim.snippet.expand(snippet) end" ''
      Function to use when expanding LSP provided snippets.
    '';

    active = defaultNullOpts.mkRaw "function(filter) return vim.snippet.active(filter) end" ''
      Function to use when checking if a snippet is active.
    '';

    jump = defaultNullOpts.mkRaw "function(direction) vim.snippet.jump(direction) end" ''
      Function to use when jumping between tab stops in a snippet, where direction can be negative
      or positive.
    '';
  };

  appearance = {
    highlight_ns = defaultNullOpts.mkUnsignedInt (literalLua "vim.api.nvim_create_namespace('blink_cmp')") ''
      Highlight namespace.
    '';

    use_nvim_cmp_as_default = defaultNullOpts.mkBool false ''
      Sets the fallback highlight groups to `nvim-cmp`'s highlight groups.

      Useful for when your theme doesn't support `blink.cmp`, will be removed in a future release.
    '';

    nerd_font_variant = defaultNullOpts.mkEnumFirstDefault [ "mono" "normal" ] ''
      Set to `"mono"` for _Nerd Font Mono_ or `"normal"` for _Nerd Font_.

      Adjusts spacing to ensure icons are aligned.
    '';

    kind_icons =
      defaultNullOpts.mkAttrsOf types.str
        {
          Text = "󰉿";
          Method = "󰊕";
          Function = "󰊕";
          Constructor = "󰒓";
          Field = "󰜢";
          Variable = "󰆦";
          Property = "󰖷";
          Class = "󱡠";
          Interface = "󱡠";
          Struct = "󱡠";
          Module = "󰅩";
          Unit = "󰪚";
          Value = "󰦨";
          Enum = "󰦨";
          EnumMember = "󰦨";
          Keyword = "󰻾";
          Constant = "󰏿";
          Snippet = "󱄽";
          Color = "󰏘";
          File = "󰈔";
          Reference = "󰬲";
          Folder = "󰉋";
          Event = "󱐋";
          Operator = "󰪚";
          TypeParameter = "󰬛";
        }
        ''
          Kind icons definitions.
        '';
  };
}
