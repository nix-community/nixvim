{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.obsidian;

  configOptions = {
    logLevel = helpers.defaultNullOpts.mkLogLevel "info" ''
      Set the log level for obsidian.nvim.
    '';

    notesSubdir = helpers.mkNullOrStr ''
      If you keep notes in a specific subdirectory of your vault.
    '';

    templates = {
      subdir = helpers.mkNullOrStr ''
        The name of the directory where templates are stored.

        Example: "templates"
      '';

      dateFormat = helpers.mkNullOrStr ''
        Which date format to use.

        Example: "%Y-%m-%d"
      '';

      timeFormat = helpers.mkNullOrStr ''
        Which time format to use.

        Example: "%H:%M"
      '';

      substitutions =
        helpers.defaultNullOpts.mkNullable
        (with helpers.nixvimTypes; attrsOf (either str rawLua))
        "{}"
        "A map for custom variables, the key should be the variable and the value a function.";
    };

    noteIdFunc = helpers.mkNullOrLuaFn ''
      Customize how names/IDs for new notes are created.

      Example:
      ```lua
        function(title)
          -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
          -- In this case a note with the title 'My new note' will be given an ID that looks
          -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
          local suffix = ""
          if title ~= nil then
            -- If title is given, transform it into valid file name.
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
          else
            -- If title is nil, just add 4 random uppercase letters to the suffix.
            for _ = 1, 4 do
              suffix = suffix .. string.char(math.random(65, 90))
            end
          end
          return tostring(os.time()) .. "-" .. suffix
        end
      ```
    '';

    followUrlFunc = helpers.mkNullOrLuaFn ''
      By default when you use `:ObsidianFollowLink` on a link to an external URL it will be
      ignored but you can customize this behavior here.

      Example:
      ```lua
        function(url)
          -- Open the URL in the default web browser.
          vim.fn.jobstart({"open", url})  -- Mac OS
          -- vim.fn.jobstart({"xdg-open", url})  -- linux
        end
      ```
    '';

    noteFrontmatterFunc = helpers.mkNullOrLuaFn ''
      You can customize the frontmatter data.

      Example:
      ```lua
        function(note)
          -- This is equivalent to the default frontmatter function.
          local out = { id = note.id, aliases = note.aliases, tags = note.tags }
          -- `note.metadata` contains any manually added fields in the frontmatter.
          -- So here we just make sure those fields are kept in the frontmatter.
          if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
            for k, v in pairs(note.metadata) do
              out[k] = v
            end
          end
          return out
        end
      ```
    '';

    disableFrontmatter = helpers.mkNullOrStrLuaFnOr types.bool ''
      Boolean or a function that takes a filename and returns a boolean.
      `true` indicates that you don't want obsidian.nvim to manage frontmatter.

      Default: `false`
    '';

    backlinks = {
      height = helpers.defaultNullOpts.mkUnsignedInt 10 ''
        The default height of the backlinks pane.
      '';

      wrap = helpers.defaultNullOpts.mkBool true ''
        Whether or not to wrap lines.
      '';
    };

    completion = {
      nvimCmp = helpers.mkNullOrOption types.bool ''
        Set to false to disable completion.

        Default: `true` if `nvim-cmp` is enabled.
      '';

      minChars = helpers.defaultNullOpts.mkUnsignedInt 2 ''
        Trigger completion at this many chars.
      '';

      newNotesLocation = helpers.defaultNullOpts.mkEnumFirstDefault ["current_dir" "notes_subdir"] ''
        Where to put new notes created from completion.

        Valid options are
        - "current_dir" - put new notes in same directory as the current buffer.
        - "notes_subdir" - put new notes in the default notes subdirectory.
      '';

      prependNoteId = helpers.defaultNullOpts.mkBool true ''
        Whether to add the note ID during completion.

        E.g. "[[Foo" completes to "[[foo|Foo]]" assuming "foo" is the ID of the note.
        Mutually exclusive with 'prependNotePath' and 'usePathOnly'.
      '';

      prependNotePath = helpers.defaultNullOpts.mkBool false ''
        Whether to add the note path during completion.

        E.g. "[[Foo" completes to "[[notes/foo|Foo]]" assuming "notes/foo.md" is the path of the note.
        Mutually exclusive with 'prependNoteId' and 'usePathOnly'.
      '';

      usePathOnly = helpers.defaultNullOpts.mkBool false ''
        Whether to only use paths during completion.

        E.g. "[[Foo" completes to "[[notes/foo]]" assuming "notes/foo.md" is the path of the note.
        Mutually exclusive with 'prependNoteId' and 'prependNotePath'.
      '';
    };

    mappings =
      helpers.defaultNullOpts.mkNullable
      (
        with types;
          attrsOf (submodule {
            options = {
              action = mkOption {
                type = helpers.nixvimTypes.strLua;
                description = "The lua code for this keymap action.";
                apply = helpers.mkRaw;
              };
              opts =
                helpers.keymaps.mapConfigOptions
                // {
                  buffer = helpers.defaultNullOpts.mkBool false ''
                    If true, the mapping will be effective in the current buffer only.
                  '';
                };
            };
          })
      )
      ''
        {
          gf = {
            action = "require('obsidian').util.gf_passthrough";
            opts = {
              noremap = false;
              expr = true;
              buffer = true;
            };
          };

          "<leader>ch" = {
            action = "require('obsidian').util.toggle_checkbox";
            opts.buffer = true;
          };
        }
      ''
      ''
        Configure key mappings.
      '';

    dailyNotes = {
      folder = helpers.mkNullOrStr ''
        Optional, if you keep daily notes in a separate directory.
      '';

      dateFormat = helpers.mkNullOrStr ''
        Optional, if you want to change the date format for the ID of daily notes.

        Example: "%Y-%m-%d"
      '';

      aliasFormat = helpers.mkNullOrStr ''
        Optional, if you want to change the date format of the default alias of daily notes.

        Example: "%B %-d, %Y"
      '';

      template = helpers.mkNullOrStr ''
        Optional, if you want to automatically insert a template from your template directory like
        'daily.md'.
      '';
    };

    useAdvancedUri = helpers.mkNullOrOption types.bool ''
      Set to true if you use the Obsidian Advanced URI plugin.
      https://github.com/Vinzent03/obsidian-advanced-uri
    '';

    openAppForeground = helpers.defaultNullOpts.mkBool false ''
      Set to true to force `:ObsidianOpen` to bring the app to the foreground.
    '';

    finder = helpers.mkNullOrStr ''
      By default commands like `:ObsidianSearch` will attempt to use `telescope.nvim`, `fzf-lua`,
      `fzf.vim`, or `mini.pick` (in that order), and use the first one they find.
      You can set this option to tell `obsidian.nvim` to always use this finder.
    '';

    sortBy = helpers.defaultNullOpts.mkEnum ["path" "modified" "accessed" "created"] "modified" ''
      Sort search results by "path", "modified", "accessed", or "created".
      The recommend value is "modified" and `true` for `sortReversed`, which means, for example,
      that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time.
    '';

    sortReversed = helpers.defaultNullOpts.mkBool true ''
      Whether search results should be reversed.
    '';

    openNotesIn = helpers.defaultNullOpts.mkEnumFirstDefault ["current" "vsplit" "hsplit"] ''
      Determines how certain commands open notes.

      The valid options are:
      - "current" (the default) - to always open in the current window
      - "vsplit" - to open in a vertical split if there's not already a vertical split
      - "hsplit" - to open in a horizontal split if there's not already a horizontal split
    '';

    ui = {
      enable = helpers.defaultNullOpts.mkBool true ''
        Set to false to disable all additional syntax features.
      '';

      updateDebounce = helpers.defaultNullOpts.mkUnsignedInt 200 ''
        Update delay after a text change (in milliseconds).
      '';

      checkboxes =
        helpers.defaultNullOpts.mkNullable
        (
          with types;
            attrsOf (
              submodule {
                options = {
                  char = mkOption {
                    type = with helpers.nixvimTypes; maybeRaw str;
                    description = "The character to use for this checkbox.";
                  };

                  hlGroup = mkOption {
                    type = with helpers.nixvimTypes; maybeRaw str;
                    description = "The name of the highlight group to use for this checkbox.";
                  };
                };
              }
            )
        )
        ''
          {
            " " = {
              char = "󰄱";
              hlGroup = "ObsidianTodo";
            };
            "x" = {
              char = "";
              hlGroup = "ObsidianDone";
            };
            ">" = {
              char = "";
              hlGroup = "ObsidianRightArrow";
            };
            "~" = {
              char = "󰰱";
              hlGroup = "ObsidianTilde";
            };
          }
        ''
        ''
          Define how various check-boxes are displayed.
          You can also add more custom ones...

          NOTE: the 'char' value has to be a single character, and the highlight groups are defined
          in the `ui.hlGroups` option.
        '';

      externalLinkIcon = {
        char = helpers.defaultNullOpts.mkStr "" ''
          Which character to use for the external link icon.
        '';

        hlGroup = helpers.defaultNullOpts.mkStr "ObsidianExtLinkIcon" ''
          The name of the highlight group to use for the external link icon.
        '';
      };

      referenceText = {
        hlGroup = helpers.defaultNullOpts.mkStr "ObsidianRefText" ''
          The name of the highlight group to use for reference text.
        '';
      };

      highlightText = {
        hlGroup = helpers.defaultNullOpts.mkStr "ObsidianHighlightText" ''
          The name of the highlight group to use for highlight text.
        '';
      };

      tags = {
        hlGroup = helpers.defaultNullOpts.mkStr "ObsidianTag" ''
          The name of the highlight group to use for tags.
        '';
      };

      hlGroups =
        helpers.defaultNullOpts.mkNullable
        (with helpers.nixvimTypes; attrsOf highlight)
        ''
          {
            ObsidianTodo = {
              bold = true;
              fg = "#f78c6c";
            };
            ObsidianDone = {
              bold = true;
              fg = "#89ddff";
            };
            ObsidianRightArrow = {
              bold = true;
              fg = "#f78c6c";
            };
            ObsidianTilde = {
              bold = true;
              fg = "#ff5370";
            };
            ObsidianRefText = {
              underline = true;
              fg = "#c792ea";
            };
            ObsidianExtLinkIcon = {
              fg = "#c792ea";
            };
            ObsidianTag = {
              italic = true;
              fg = "#89ddff";
            };
            ObsidianHighlightText = {
              bg = "#75662e";
            };
          }
        ''
        "Highlight group definitions.";
    };

    attachments = {
      imgFolder = helpers.defaultNullOpts.mkStr "assets/imgs" ''
        The default folder to place images in via `:ObsidianPasteImg`.

        If this is a relative path it will be interpreted as relative to the vault root.
        You can always override this per image by passing a full path to the command instead of just
        a filename.
      '';

      imgTextFunc =
        helpers.defaultNullOpts.mkLuaFn
        ''
          function(client, path)
            ---@type string
            local link_path
            local vault_relative_path = client:vault_relative_path(path)
            if vault_relative_path ~= nil then
              -- Use relative path if the image is saved in the vault dir.
              link_path = vault_relative_path
            else
              -- Otherwise use the absolute path.
              link_path = tostring(path)
            end
            local display_name = vim.fs.basename(link_path)
            return string.format("![%s](%s)", display_name, link_path)
          end
        ''
        ''
          A function that determines the text to insert in the note when pasting an image.
          It takes two arguments, the `obsidian.Client` and a plenary `Path` to the image file.

          ```lua
            @param client obsidian.Client
            @param path Path the absolute path to the image file
            @return string
          ```
        '';
    };

    yamlParser = helpers.defaultNullOpts.mkEnumFirstDefault ["native" "yq"] ''
      Set the YAML parser to use.

      The valid options are:
      - "native" - uses a pure Lua parser that's fast but potentially misses some edge cases.
      - "yq" - uses the command-line tool yq (https://github.com/mikefarah/yq), which is more robust
        but much slower and needs to be installed separately.

      In general you should be using the native parser unless you run into a bug with it, in which
      case you can temporarily switch to the "yq" parser until the bug is fixed.
    '';
  };
in {
  meta.maintainers = [maintainers.GaetanLepage];

  options.plugins.obsidian =
    helpers.neovim-plugin.extraOptionsOptions
    // {
      enable = mkEnableOption "obsidian.nvim";

      package = helpers.mkPackageOption "obsidian.nvim" pkgs.vimPlugins.obsidian-nvim;

      dir = helpers.mkNullOrOption types.str ''
        Alternatively to `workspaces` - and for backwards compatibility - you can set `dir` to a
        single path instead of `workspaces`.

        For example:
        ```nix
          dir = "~/vaults/work";
        ```
      '';

      workspaces =
        helpers.defaultNullOpts.mkNullable
        (
          with types;
            listOf
            (types.submodule {
              options = {
                name = mkOption {
                  type = with helpers.nixvimTypes; maybeRaw str;
                  description = "The name for this workspace";
                };

                path = mkOption {
                  type = with helpers.nixvimTypes; maybeRaw str;
                  description = "The of the workspace.";
                };

                overrides = configOptions;
              };
            })
        )
        "[]"
        ''
          A list of vault names and paths.
          Each path should be the path to the vault root.
          If you use the Obsidian app, the vault root is the parent directory of the `.obsidian`
          folder.
          You can also provide configuration overrides for each workspace through the `overrides`
          field.
        '';

      detectCwd = helpers.defaultNullOpts.mkBool false ''
        Set to true to use the current directory as a vault; otherwise the first workspace
        is opened by default.
      '';
    }
    // configOptions;

  config = mkIf cfg.enable {
    extraPlugins = [cfg.package];

    assertions = [
      {
        assertion = let
          nvimCmpEnabled = isBool cfg.completion.nvimCmp && cfg.completion.nvimCmp;
        in
          nvimCmpEnabled -> config.plugins.nvim-cmp.enable;
        message = ''
          Nixvim (plugins.obsidian): You have enabled `completion.nvimCmp` but `plugins.nvim-cmp.enable` is `false`.
          You need to enable `nvim-cmp` to use this setting.
        '';
      }
    ];

    extraConfigLua = let
      processConfigOptions = configOptions:
        with configOptions; {
          log_level = logLevel;
          notes_subdir = notesSubdir;
          templates = with templates; {
            inherit subdir;
            date_format = dateFormat;
            time_format = timeFormat;
            inherit substitutions;
          };
          note_id_func = noteIdFunc;
          follow_url_func = followUrlFunc;
          note_formatter_func = noteFrontmatterFunc;
          disable_frontmatter = disableFrontmatter;
          backlinks = with backlinks; {
            inherit
              height
              wrap
              ;
          };
          completion = with completion; {
            nvim_cmp = nvimCmp;
            min_chars = minChars;
            new_notes_location = newNotesLocation;
            prepend_note_id = prependNoteId;
            prepend_note_path = prependNotePath;
            use_path_only = usePathOnly;
          };
          inherit mappings;
          daily_notes = with dailyNotes; {
            inherit folder;
            date_format = dateFormat;
            alias_format = aliasFormat;
            inherit template;
          };
          use_advanced_uri = useAdvancedUri;
          open_app_foreground = openAppForeground;
          inherit finder;
          sort_by = sortBy;
          sort_reversed = sortReversed;
          open_notes_in = openNotesIn;
          ui = with ui; {
            inherit enable;
            update_debounce = updateDebounce;
            checkboxes =
              helpers.ifNonNull' checkboxes
              (
                mapAttrs
                (
                  _: checkbox: {
                    inherit (checkbox) char;
                    hl_group = checkbox.hlGroup;
                  }
                )
                checkboxes
              );
            external_link_icon = with externalLinkIcon; {
              inherit char;
              hl_group = hlGroup;
            };
            reference_text = with referenceText; {
              hl_group = hlGroup;
            };
            highlight_text = with highlightText; {
              hl_group = hlGroup;
            };
            tags = with tags; {
              hl_group = hlGroup;
            };
            hl_groups = hlGroups;
          };
          attachments = with attachments; {
            img_folder = imgFolder;
            img_text_func = imgTextFunc;
          };
          yaml_parser = yamlParser;
        };

      setupOptions = with cfg;
        {
          inherit dir;
          workspaces =
            helpers.ifNonNull' workspaces
            (
              map
              (
                workspaceConfig: {
                  inherit
                    (workspaceConfig)
                    name
                    path
                    ;
                  overrides = processConfigOptions workspaceConfig.overrides;
                }
              )
              workspaces
            );
          detect_cwd = detectCwd;
        }
        // (processConfigOptions cfg)
        // cfg.extraOptions;
    in ''
      require('obsidian').setup(${helpers.toLuaObject setupOptions})
    '';
  };
}
