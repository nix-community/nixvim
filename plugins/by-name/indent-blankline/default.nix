{
  lib,
  helpers,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "indent-blankline";
  moduleName = "ibl";
  package = "indent-blankline-nvim";
  description = "This plugin adds indentation guides to Neovim.";

  maintainers = [ maintainers.GaetanLepage ];

  settingsOptions = {
    debounce = helpers.defaultNullOpts.mkUnsignedInt 200 ''
      Sets the amount indent-blankline debounces refreshes in milliseconds.
    '';

    viewport_buffer = {
      min = helpers.defaultNullOpts.mkUnsignedInt 30 ''
        Minimum number of lines above and below of what is currently visible in the window for
        which indentation guides will be generated.
      '';

      max = helpers.defaultNullOpts.mkUnsignedInt 500 ''
        Maximum number of lines above and below of what is currently visible in the window for
        which indentation guides will be generated.
      '';
    };

    indent = {
      char = helpers.defaultNullOpts.mkNullable (with types; either str (listOf str)) "▎" ''
        Character, or list of characters, that get used to display the indentation guide.
        Each character has to have a display width of 0 or 1.
      '';

      tab_char = helpers.mkNullOrOption (with types; either str (listOf str)) ''
        Character, or list of characters, that get used to display the indentation guide for tabs.
        Each character has to have a display width of 0 or 1.

        Default: uses `|lcs-tab|` if `|'list'|` is set, otherwise, uses
        `|ibl.config.indent.char|`.
      '';

      highlight = helpers.mkNullOrOption (with types; either str (listOf str)) ''
        Highlight group, or list of highlight groups, that get applied to the indentation guide.

        Default: `|hl-IblIndent|`
      '';

      smart_indent_cap = helpers.defaultNullOpts.mkBool true ''
        Caps the number of indentation levels by looking at the surrounding code.
      '';

      priority = helpers.defaultNullOpts.mkUnsignedInt 1 ''
        Virtual text priority for the indentation guide.
      '';
    };

    whitespace = {
      highlight = helpers.mkNullOrOption (with types; either str (listOf str)) ''
        Highlight group, or list of highlight groups, that get applied to the whitespace.

        Default: `|hl-IblWhitespace|`
      '';

      remove_blankline_trail = helpers.defaultNullOpts.mkBool true ''
        Removes trailing whitespace on blanklines.

        Turn this off if you want to add background color to the whitespace highlight group.
      '';
    };

    scope = {
      enabled = helpers.defaultNullOpts.mkBool true "Enables or disables scope.";

      char = helpers.mkNullOrOption (with types; either str (listOf str)) ''
        Character, or list of characters, that get used to display the scope indentation guide.

        Each character has to have a display width of 0 or 1.

        Default: `indent.char`
      '';

      show_start = helpers.defaultNullOpts.mkBool true ''
        Shows an underline on the first line of the scope.
      '';

      show_end = helpers.defaultNullOpts.mkBool true ''
        Shows an underline on the last line of the scope.
      '';

      show_exact_scope = helpers.defaultNullOpts.mkBool false ''
        Shows an underline on the first line of the scope starting at the exact start of the scope
        (even if this is to the right of the indent guide) and an underline on the last line of
        the scope ending at the exact end of the scope.
      '';

      injected_languages = helpers.defaultNullOpts.mkBool true ''
        Checks for the current scope in injected treesitter languages.
        This also influences if the scope gets excluded or not.
      '';

      highlight = helpers.mkNullOrOption (with types; either str (listOf str)) ''
        Highlight group, or list of highlight groups, that get applied to the scope.

        Default: `|hl-IblScope|`
      '';

      priority = helpers.defaultNullOpts.mkUnsignedInt 1024 ''
        Virtual text priority for the scope.
      '';

      include = {
        node_type = helpers.defaultNullOpts.mkAttrsOf (with types; listOf str) { } ''
          Map of language to a list of node types which can be used as scope.

          - Use `*` as the language to act as a wildcard for all languages.
          - Use `*` as a node type to act as a wildcard for all node types.
        '';
      };

      exclude = {
        language = helpers.defaultNullOpts.mkListOf types.str [ ] ''
          List of treesitter languages for which scope is disabled.
        '';

        node_type =
          helpers.defaultNullOpts.mkAttrsOf (with types; (listOf str))
            {
              "*" = [
                "source_file"
                "program"
              ];
              lua = [ "chunk" ];
              python = [ "module" ];
            }
            ''
              Map of language to a list of node types which should not be used as scope.

              Use `*` as a wildcard for all languages.
            '';
      };
    };

    exclude = {
      filetypes = helpers.defaultNullOpts.mkListOf types.str [
        "lspinfo"
        "packer"
        "checkhealth"
        "help"
        "man"
        "gitcommit"
        "TelescopePrompt"
        "TelescopeResults"
        "''"
      ] "List of filetypes for which indent-blankline is disabled.";

      buftypes = helpers.defaultNullOpts.mkListOf types.str [
        "terminal"
        "nofile"
        "quickfix"
        "prompt"
      ] "List of buftypes for which indent-blankline is disabled.";
    };
  };

  settingsExample = {
    indent = {
      char = "│";
    };
    scope = {
      show_start = false;
      show_end = false;
      show_exact_scope = true;
    };
    exclude = {
      filetypes = [
        ""
        "checkhealth"
        "help"
        "lspinfo"
        "packer"
        "TelescopePrompt"
        "TelescopeResults"
        "yaml"
      ];
      buftypes = [
        "terminal"
        "quickfix"
      ];
    };
  };
}
