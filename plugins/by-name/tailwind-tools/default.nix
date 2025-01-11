{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "tailwind-tools";
  packPathName = "tailwind-tools.nvim";
  package = "tailwind-tools-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    server = {
      override = defaultNullOpts.mkBool true ''
        Setup the server from the plugin if true
      '';

      settings = defaultNullOpts.mkAttrsOf types.anything { } ''
        Shortcut for `settings.tailwindCSS`.
      '';

      on_attach = defaultNullOpts.mkRaw "function(client, bufnr) end" ''
        Callback triggered when the server attaches to a buffer.
      '';
    };

    document_color = {
      enabled = defaultNullOpts.mkBool true ''
        Can also be toggled by commands.
      '';

      kind = defaultNullOpts.mkEnumFirstDefault [ "inline" "foreground" "background" ] ''
        The kind of coloring to use for documents.
      '';

      inline_symbol = defaultNullOpts.mkStr "󰝤 " ''
        Inline symbol (only used in inline mode).
      '';

      debounce = defaultNullOpts.mkUnsignedInt 200 ''
        Debounce timeout (in milliseconds).
        Only applied in insert mode.
      '';
    };

    conceal = {
      enabled = defaultNullOpts.mkBool false ''
        Can also be toggled by commands.
      '';

      min_length = defaultNullOpts.mkUnsignedInt null ''
        Only conceal classes exceeding the provided length.
      '';

      symbol = defaultNullOpts.mkStr "󱏿" ''
        Conceal symbol.
        Only a single character is allowed
      '';

      highlight =
        defaultNullOpts.mkNullable (with types; maybeRaw highlight)
          {
            fg = "#38BDF8";
          }
          ''
            Extmark highlight options, see `:h highlight`.
          '';
    };

    cmp = {
      highlight = defaultNullOpts.mkEnumFirstDefault [ "foreground" "background" ] ''
        Color preview style.
      '';
    };

    telescope = {
      utilities = {
        callback = defaultNullOpts.mkRaw "function(name, class) end" ''
          Callback used when selecting an utility class in telescope.
        '';
      };
    };

    extension = {
      queries = defaultNullOpts.mkListOf types.str [ ] ''
        A list of filetypes having custom `class` queries.
      '';

      patterns = defaultNullOpts.mkAttrsOf' {
        type = with types; listOf str;
        description = ''
          A map of filetypes to Lua pattern lists.
        '';
        pluginDefault = { };
        example = {
          rust = [ "class=[\"']([^\"']+)[\"']" ];
          javascript = [ "clsx%(([^)]+)%)" ];
        };
      };
    };
  };

  settingsExample = {
    document_color = {
      conceal = {
        enabled = true;
        symbol = "…";
      };
      document_color.kind = "background";
    };
  };
}
