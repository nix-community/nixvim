{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  basePluginPath = ["plugins" "indent-blankline"];
in {
  # TODO: Those warnings were introduced on 2023/10/17.
  # Please, remove in early December 2023.
  imports =
    # Removed options
    (
      map
      (
        optionName:
          mkRemovedOptionModule
          (basePluginPath ++ [optionName])
          ''
            Please use the new options.
            See https://github.com/lukas-reineke/indent-blankline.nvim.
          ''
      )
      [
        "charBlankline"
        "charList"
        "charListBlankline"
        "charHighlightList"
        "spaceCharBlankline"
        "spaceCharHighlightList"
        "spaceCharBlanklineHighlightList"
        "useTreesitter"
        "indentLevel"
        "maxIndentIncrease"
        "showFirstIndentLevel"
        "showEndOfLine"
        "showFoldtext"
        "disableWithNolist"
        "filetype"
        "bufnameExclude"
        "strictTabs"
        "showCurrentContextStartOnCurrentLine"
        "contextCharBlankline"
        "contextCharListBlankline"
        "charPriority"
        "contextStartPriority"
        "contextPatterns"
        "useTreesitterScope"
        "contextPatternHighlight"
        "disableWarningMessage"
      ]
    )
    # New options
    ++ (
      mapAttrsToList
      (
        oldName: newPath:
          mkRenamedOptionModule
          (basePluginPath ++ [oldName])
          (basePluginPath ++ newPath)
      )
      {
        char = ["indent" "char"];
        showCurrentContext = ["scope" "enabled"];
        showTrailingBlanklineIndent = ["whitespace" "removeBlanklineTrail"];
        filetypeExclude = ["exclude" "filetypes"];
        buftypeExclude = ["exclude" "buftypes"];
        showCurrentContextStart = ["scope" "showStart"];
        contextChar = ["scope" "char"];
        contextCharList = ["scope" "char"];
        contextHighlightList = ["scope" "highlight"];
      }
    );

  options.plugins.indent-blankline =
    helpers.neovim-plugin.extraOptionsOptions
    // {
      enable = mkEnableOption "indent-blankline.nvim";

      package = helpers.mkPackageOption "indent-blankline" pkgs.vimPlugins.indent-blankline-nvim;

      debounce = helpers.defaultNullOpts.mkUnsignedInt 200 ''
        Sets the amount indent-blankline debounces refreshes in milliseconds.
      '';

      viewportBuffer = {
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

        tabChar = helpers.mkNullOrOption (with types; either str (listOf str)) ''
          Character, or list of characters, that get used to display the indentation guide for tabs.
          Each character has to have a display width of 0 or 1.

          Default: uses `|lcs-tab|` if `|'list'|` is set, otherwise, uses
          `|ibl.config.indent.char|`.
        '';

        highlight = helpers.mkNullOrOption (with types; either str (listOf str)) ''
          Highlight group, or list of highlight groups, that get applied to the indentation guide.

          Default: `|hl-IblIndent|`
        '';

        smartIndentCap = helpers.defaultNullOpts.mkBool true ''
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

        removeBlanklineTrail = helpers.defaultNullOpts.mkBool true ''
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

        showStart = helpers.defaultNullOpts.mkBool true ''
          Shows an underline on the first line of the scope.
        '';

        showEnd = helpers.defaultNullOpts.mkBool true ''
          Shows an underline on the last line of the scope.
        '';

        showExactScope = helpers.defaultNullOpts.mkBool false ''
          Shows an underline on the first line of the scope starting at the exact start of the scope
          (even if this is to the right of the indent guide) and an underline on the last line of
          the scope ending at the exact end of the scope.
        '';

        injectedLanguages = helpers.defaultNullOpts.mkBool true ''
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
          nodeType = helpers.defaultNullOpts.mkNullable (with types; attrsOf (listOf str)) "{}" ''
            Map of language to a list of node types which can be used as scope.

            - Use `*` as the language to act as a wildcard for all languages.
            - Use `*` as a node type to act as a wildcard for all node types.
          '';
        };

        exclude = {
          language = helpers.defaultNullOpts.mkNullable (with types; listOf str) "[]" ''
            List of treesitter languages for which scope is disabled.
          '';

          nodeType =
            helpers.defaultNullOpts.mkNullable
            (with types; attrsOf (listOf str))
            ''
              {
                "*" = ["source_file" "program"];
                lua = ["chunk"];
                python = ["module"];
              }
            ''
            ''
              Map of language to a list of node types which should not be used as scope.

              Use `*` as a wildcard for all languages.
            '';
        };
      };

      exclude = {
        filetypes =
          helpers.defaultNullOpts.mkNullable
          (with types; listOf str)
          ''
            [
              "lspinfo"
              "packer"
              "checkhealth"
              "help"
              "man"
              "gitcommit"
              "TelescopePrompt"
              "TelescopeResults"
              "\'\'"
            ]
          ''
          "List of filetypes for which indent-blankline is disabled.";

        buftypes =
          helpers.defaultNullOpts.mkNullable
          (with types; listOf str)
          ''
            [
              "terminal"
              "nofile"
              "quickfix"
              "prompt"
            ]
          ''
          "List of buftypes for which indent-blankline is disabled.";
      };
    };

  config = let
    cfg = config.plugins.indent-blankline;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = let
        setupOptions = with cfg;
          {
            enabled = true;
            inherit debounce;
            viewport_buffer = with viewportBuffer; {
              inherit
                min
                max
                ;
            };
            indent = with indent; {
              inherit char;
              tab_char = tabChar;
              inherit highlight;
              smart_indent_cap = smartIndentCap;
              inherit priority;
            };
            whitespace = with whitespace; {
              inherit highlight;
              remove_blankline_trail = removeBlanklineTrail;
            };
            scope = with scope; {
              inherit
                enabled
                char
                ;
              show_start = showStart;
              show_end = showEnd;
              show_exact_scope = showExactScope;
              injected_languages = injectedLanguages;
              inherit
                highlight
                priority
                ;
              include = with include; {
                node_type = nodeType;
              };
              exclude = with exclude; {
                inherit language;
                node_type = nodeType;
              };
            };
            exclude = with exclude; {
              inherit
                filetypes
                buftypes
                ;
            };
          }
          // cfg.extraOptions;
      in ''
        require("ibl").setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
