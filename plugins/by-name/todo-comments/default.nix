{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  inherit (lib) types;
  inherit (lib.nixvim)
    defaultNullOpts
    keymaps
    mkNullOrOption'
    transitionType
    ;

in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "todo-comments";
  originalName = "todo-comments.nvim";
  package = "todo-comments-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  # TODO: Added 2023-11-06, remove after 24.11
  imports = [
    (mkRemovedOptionModule [
      "plugins"
      "todo-comments"
      "keymapsSilent"
    ] "Use `plugins.todo-comments.keymaps.<COMMAND>.options.silent`.")
  ];

  # TODO: Added 2024-08-16, remove after 24.11
  deprecateExtraOptions = true;
  optionsRenamedToSettings = [
    "signs"
    "signPriority"
    "keywords"
    [
      "guiStyle"
      "bg"
    ]
    [
      "guiStyle"
      "fg"
    ]
    "mergeKeywords"
    [
      "highlight"
      "multiline"
    ]
    [
      "highlight"
      "multilinePattern"
    ]
    [
      "highlight"
      "multilineContext"
    ]
    [
      "highlight"
      "before"
    ]
    [
      "highlight"
      "keyword"
    ]
    [
      "highlight"
      "after"
    ]
    [
      "highlight"
      "pattern"
    ]
    [
      "highlight"
      "commentsOnly"
    ]
    [
      "highlight"
      "maxLineLen"
    ]
    [
      "highlight"
      "exclude"
    ]
    [
      "colors"
      "error"
    ]
    [
      "colors"
      "warning"
    ]
    [
      "colors"
      "info"
    ]
    [
      "colors"
      "hint"
    ]
    [
      "colors"
      "default"
    ]
    [
      "colors"
      "test"
    ]
    [
      "search"
      "command"
    ]
    [
      "search"
      "args"
    ]
    [
      "search"
      "pattern"
    ]
  ];

  settingsOptions = {
    signs = defaultNullOpts.mkBool true "Show icons in the signs column.";

    sign_priority = defaultNullOpts.mkInt 8 "Sign priority.";

    keywords =
      defaultNullOpts.mkAttrsOf
        (
          with types;
          submodule {
            freeformType = attrsOf anything;
            options = {
              icon = defaultNullOpts.mkStr null ''
                Icon used for the sign, and in search results.
              '';

              color = defaultNullOpts.mkStr null ''
                Can be a hex color, or a named color.
              '';

              alt = defaultNullOpts.mkListOf types.str null ''
                A set of other keywords that all map to this FIX keywords.
              '';

              signs = defaultNullOpts.mkBool null ''
                Configure signs for some keywords individually.
              '';
            };
          }
        )
        {
          FIX = {
            icon = " ";
            color = "error";
            alt = [
              "FIXME"
              "BUG"
              "FIXIT"
              "ISSUE"
            ];
          };
          TODO = {
            icon = " ";
            color = "info";
          };
          HACK = {
            icon = " ";
            color = "warning";
          };
          WARN = {
            icon = " ";
            color = "warning";
            alt = [
              "WARNING"
              "XXX"
            ];
          };
          PERF = {
            icon = " ";
            alt = [
              "OPTIM"
              "PERFORMANCE"
              "OPTIMIZE"
            ];
          };
          NOTE = {
            icon = " ";
            color = "hint";
            alt = [ "INFO" ];
          };
          TEST = {
            icon = "⏲ ";
            color = "test";
            alt = [
              "TESTING"
              "PASSED"
              "FAILED"
            ];
          };
        }
        ''
          Configurations for keywords to be recognized as todo comments.
        '';

    gui_style = {
      fg = defaultNullOpts.mkStr "NONE" ''
        The gui style to use for the fg highlight group.
      '';

      bg = defaultNullOpts.mkStr "BOLD" ''
        The gui style to use for the bg highlight group.
      '';
    };

    merge_keywords = defaultNullOpts.mkBool true ''
      When true, custom keywords will be merged with the default.
    '';

    highlight = {
      multiline = defaultNullOpts.mkBool true ''
        Enable multiline todo comments.
      '';

      multiline_pattern = defaultNullOpts.mkStr "^." ''
        Lua pattern to match the next multiline from the start of the
        matched keyword.
      '';

      multiline_context = defaultNullOpts.mkInt 10 ''
        Extra lines that will be re-evaluated when changing a line.
      '';

      before =
        defaultNullOpts.mkEnumFirstDefault
          [
            ""
            "fg"
            "bg"
          ]
          ''
            Whether to apply the before highlight to the foreground or background.
          '';

      keyword =
        defaultNullOpts.mkEnumFirstDefault
          [
            "wide"
            "fg"
            "bg"
            "wide_bg"
            "wide_fg"
            ""
          ]
          ''
            How highlighting is applied to the keyword.

            `wide` and `wide_bg` are the same as `bg`, but will also highlight
            surrounding characters, `wide_fg` acts accordingly but with `fg`.
          '';

      after =
        defaultNullOpts.mkEnumFirstDefault
          [
            "fg"
            "bg"
            ""
          ]
          ''
            Whether to apply the after highlight to the foreground or background.
          '';

      pattern = defaultNullOpts.mkNullable' {
        type = with types; either str (listOf str);
        pluginDefault = ".*<(KEYWORDS)\\s*:";
        description = ''
          Pattern or list of patterns, used for highlighting (vim regex).
        '';
      };

      comments_only = defaultNullOpts.mkBool true ''
        Uses treesitter to match keywords in comments only.
      '';

      max_line_len = defaultNullOpts.mkInt 400 ''
        Ignore lines longer than this.
      '';

      exclude = defaultNullOpts.mkListOf types.str [ ] ''
        List of file types to exclude highlighting.
      '';
    };

    colors =
      defaultNullOpts.mkAttrsOf (types.listOf types.str)
        {
          error = [
            "DiagnosticError"
            "ErrorMsg"
            "#DC2626"
          ];
          warning = [
            "DiagnosticWarn"
            "WarningMsg"
            "#FBBF24"
          ];
          info = [
            "DiagnosticInfo"
            "#2563EB"
          ];
          hint = [
            "DiagnosticHint"
            "#10B981"
          ];
          default = [
            "Identifier"
            "#7C3AED"
          ];
          test = [
            "Identifier"
            "#FF00FF"
          ];
        }
        ''
          List of named colors where we try to extract the guifg from the list
          of highlight groups or use the hex color if hl not found as a fallback.
        '';

    search = {
      command = defaultNullOpts.mkStr "rg" "Command to use for searching for keywords.";

      args =
        defaultNullOpts.mkListOf types.str
          [
            "--color=never"
            "--no-heading"
            "--with-filename"
            "--line-number"
            "--column"
          ]
          ''
            Arguments to use for the search command in list form.
          '';

      pattern = defaultNullOpts.mkStr "\\b(KEYWORDS):" ''
        Regex that will be used to match keywords.
        Don't replace the (KEYWORDS) placeholder.
      '';
    };
  };

  settingsExample = {
    highlight = {
      pattern = [
        ".*<(KEYWORDS)\s*:"
        ".*<(KEYWORDS)\s*"
      ];
    };
  };

  extraOptions = {
    keymaps =
      mapAttrs
        (
          optionName: action:
          mkNullOrOption' {
            type = keymaps.mkMapOptionSubmodule {
              defaults = {
                inherit action;
                mode = "n";
                key = null;
              };

              key.type = with types; nullOr str;

              extraOptions = {
                cwd = mkOption {
                  type = types.nullOr types.str;
                  description = "Specify the directory to search for comments";
                  default = null;
                  example = "~/projects/foobar";
                };

                keywords = mkOption {
                  type = with types; transitionType str (splitString ",") (nullOr (listOf str));
                  description = ''
                    Comma separated list of keywords to filter results by.
                    Keywords are case-sensitive.
                  '';
                  default = null;
                  example = "TODO,FIX";
                };
              };
            };
            description = "Keymap for function ${action}";
          }
        )
        {
          todoQuickFix = "TodoQuickFix";
          todoLocList = "TodoLocList";
          todoTrouble = "TodoTrouble";
          todoTelescope = "TodoTelescope";
        };

    ripgrepPackage = lib.mkPackageOption pkgs "ripgrep" {
      nullable = true;
    };
  };

  extraConfig = cfg: {
    assertions = [
      {
        assertion = cfg.keymaps.todoTelescope.key or null != null -> config.plugins.telescope.enable;
        message = ''
          Nixvim(plugins.todo-comments): You have enabled todo-comment's `telescope` integration.
          However, you have not enabled the `telescope` plugin itself (`plugins.telescope.enable = true`).
        '';
      }
      {
        assertion = cfg.keymaps.todoTrouble.key or null != null -> config.plugins.trouble.enable;
        message = ''
          Nixvim(plugins.todo-comments): You have enabled todo-comment's `trouble` integration.
          However, you have not enabled the `trouble` plugin itself (`plugins.trouble.enable = true`).
        '';
      }
    ];

    extraPackages = [ cfg.ripgrepPackage ];

    keymaps = lib.pipe cfg.keymaps [
      (filterAttrs (n: keymap: keymap != null && keymap.key != null))
      (mapAttrsToList (
        name: keymap: {
          inherit (keymap) key mode options;
          action =
            let
              cwd = optionalString (keymap.cwd != null) " cwd=${keymap.cwd}";
              keywords = optionalString (
                keymap.keywords != null && keymap.keywords != [ ]
              ) " keywords=${concatStringsSep "," keymap.keywords}";
            in
            "<cmd>${keymap.action}${cwd}${keywords}<cr>";
        }
      ))
    ];
  };
}
