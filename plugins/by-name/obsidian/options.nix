{ lib, helpers }:
with lib;
{
  # https://github.com/epwalsh/obsidian.nvim/blob/main/lua/obsidian/config.lua

  log_level = helpers.defaultNullOpts.mkLogLevel "info" ''
    Set the log level for obsidian.nvim.
  '';

  notes_subdir = helpers.mkNullOrStr ''
    If you keep notes in a specific subdirectory of your vault.
  '';

  templates = {
    subdir = helpers.mkNullOrStr ''
      The name of the directory where templates are stored.

      Example: "templates"
    '';

    date_format = helpers.mkNullOrStr ''
      Which date format to use.

      Example: "%Y-%m-%d"
    '';

    time_format = helpers.mkNullOrStr ''
      Which time format to use.

      Example: "%H:%M"
    '';

    substitutions = helpers.defaultNullOpts.mkAttrsOf (
      with lib.types; either str rawLua
    ) { } "A map for custom variables, the key should be the variable and the value a function.";
  };

  new_notes_location =
    helpers.defaultNullOpts.mkEnumFirstDefault
      [
        "current_dir"
        "notes_subdir"
      ]
      ''
        Where to put new notes created from completion.

        Valid options are
        - "current_dir" - put new notes in same directory as the current buffer.
        - "notes_subdir" - put new notes in the default notes subdirectory.
      '';

  note_id_func = helpers.mkNullOrLuaFn ''
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

  note_path_func = helpers.mkNullOrLuaFn ''
    Customize how note file names are generated given the ID, target directory, and title.

    ```lua
      ---@param spec { id: string, dir: obsidian.Path, title: string|? }
      ---@return string|obsidian.Path The full path to the new note.
    ```

    Example:
    ```lua
      function(spec)
        -- This is equivalent to the default behavior.
        local path = spec.dir / tostring(spec.id)
        return path:with_suffix(".md")
      end
    ```
  '';

  wiki_link_func = helpers.mkNullOrLuaFn ''
    Customize how wiki links are formatted.

    ```lua
      ---@param opts {path: string, label: string, id: string|?}
      ---@return string
    ```

    Example:
    ```lua
      function(opts)
        if opts.id == nil then
          return string.format("[[%s]]", opts.label)
        elseif opts.label ~= opts.id then
          return string.format("[[%s|%s]]", opts.id, opts.label)
        else
          return string.format("[[%s]]", opts.id)
        end
      end
    ```

    Default: See source
  '';

  markdown_link_func = helpers.mkNullOrLuaFn ''
    Customize how markdown links are formatted.

    ```lua
      ---@param opts {path: string, label: string, id: string|?}
      ---@return string links are formatted.
    ```

    Example:
    ```lua
      function(opts)
        return string.format("[%s](%s)", opts.label, opts.path)
      end
    ```

    Default: See source
  '';

  preferred_link_style =
    helpers.defaultNullOpts.mkEnumFirstDefault
      [
        "wiki"
        "markdown"
      ]
      ''
        Either 'wiki' or 'markdown'.
      '';

  follow_url_func = helpers.mkNullOrLuaFn ''
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

  image_name_func = helpers.mkNullOrLuaFn ''
    Customize the default name or prefix when pasting images via `:ObsidianPasteImg`.

    Example:
    ```lua
      function()
        -- Prefix image names with timestamp.
        return string.format("%s-", os.time())
      end
    ```
  '';

  note_frontmatter_func = helpers.mkNullOrLuaFn ''
    You can customize the frontmatter data.

    Example:
    ```lua
      function(note)
        -- Add the title of the note as an alias.
        if note.title then
          note:add_alias(note.title)
        end

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

  disable_frontmatter = helpers.mkNullOrStrLuaFnOr types.bool ''
    Boolean or a function that takes a filename and returns a boolean.
    `true` indicates that you don't want obsidian.nvim to manage frontmatter.

    Default: `false`
  '';

  completion = {
    # FIXME should this accept raw types?
    nvim_cmp = helpers.mkNullOrOption' {
      type = types.bool;
      description = ''
        Set to false to disable completion.
      '';
      defaultText = literalMD "`true` if `plugins.cmp.enable` is enabled (otherwise `null`).";
    };

    min_chars = helpers.defaultNullOpts.mkUnsignedInt 2 ''
      Trigger completion at this many chars.
    '';
  };

  mappings =
    helpers.defaultNullOpts.mkNullable
      (
        with types;
        attrsOf (submodule {
          options = {
            action = mkOption {
              type = lib.types.strLua;
              description = "The lua code for this keymap action.";
              apply = helpers.mkRaw;
            };
            opts = helpers.keymaps.mapConfigOptions // {
              buffer = helpers.defaultNullOpts.mkBool false ''
                If true, the mapping will be effective in the current buffer only.
              '';
            };
          };
        })
      )
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
        Configure key mappings.
      '';

  picker = {
    name =
      helpers.mkNullOrOption
        (types.enum [
          "telescope.nvim"
          "fzf-lua"
          "mini.pick"
        ])
        ''
          Set your preferred picker.
        '';

    note_mappings =
      helpers.defaultNullOpts.mkAttrsOf types.str
        {
          new = "<C-x>";
          insert_link = "<C-l>";
        }
        ''
          Optional, configure note mappings for the picker. These are the defaults.
          Not all pickers support all mappings.
        '';

    tag_mappings =
      helpers.defaultNullOpts.mkAttrsOf types.str
        {
          tag_note = "<C-x>";
          insert_tag = "<C-l>";
        }
        ''
          Optional, configure tag mappings for the picker. These are the defaults.
          Not all pickers support all mappings.
        '';
  };

  daily_notes = {
    folder = helpers.mkNullOrStr ''
      Optional, if you keep daily notes in a separate directory.
    '';

    date_format = helpers.mkNullOrStr ''
      Optional, if you want to change the date format for the ID of daily notes.

      Example: "%Y-%m-%d"
    '';

    alias_format = helpers.mkNullOrStr ''
      Optional, if you want to change the date format of the default alias of daily notes.

      Example: "%B %-d, %Y"
    '';

    template = helpers.mkNullOrStr ''
      Optional, if you want to automatically insert a template from your template directory like
      'daily.md'.
    '';
  };

  use_advanced_uri = helpers.defaultNullOpts.mkBool false ''
    Set to true to force ':ObsidianOpen' to bring the app to the foreground.
  '';

  open_app_foreground = helpers.defaultNullOpts.mkBool false ''
    Set to true to force `:ObsidianOpen` to bring the app to the foreground.
  '';

  sort_by =
    helpers.defaultNullOpts.mkEnum
      [
        "path"
        "modified"
        "accessed"
        "created"
      ]
      "modified"
      ''
        Sort search results by "path", "modified", "accessed", or "created".
        The recommend value is "modified" and `true` for `sortReversed`, which means, for example,
        that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time.
      '';

  sort_reversed = helpers.defaultNullOpts.mkBool true ''
    Whether search results should be reversed.
  '';

  open_notes_in =
    helpers.defaultNullOpts.mkEnumFirstDefault
      [
        "current"
        "vsplit"
        "hsplit"
      ]
      ''
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

    update_debounce = helpers.defaultNullOpts.mkUnsignedInt 200 ''
      Update delay after a text change (in milliseconds).
    '';

    checkboxes =
      helpers.defaultNullOpts.mkAttrsOf
        (
          with types;
          submodule {
            options = {
              char = mkOption {
                type = with lib.types; maybeRaw str;
                description = "The character to use for this checkbox.";
              };

              hl_group = mkOption {
                type = with lib.types; maybeRaw str;
                description = "The name of the highlight group to use for this checkbox.";
              };
            };
          }
        )
        {
          " " = {
            char = "󰄱";
            hl_group = "ObsidianTodo";
          };
          "x" = {
            char = "";
            hl_group = "ObsidianDone";
          };
          ">" = {
            char = "";
            hl_group = "ObsidianRightArrow";
          };
          "~" = {
            char = "󰰱";
            hl_group = "ObsidianTilde";
          };
        }
        ''
          Define how various check-boxes are displayed.
          You can also add more custom ones...

          NOTE: the 'char' value has to be a single character, and the highlight groups are defined
          in the `ui.hl_groups` option.
        '';

    bullets = {
      char = helpers.defaultNullOpts.mkStr "•" ''
        Which character to use for the bullets.
      '';

      hl_group = helpers.defaultNullOpts.mkStr "ObsidianBullet" ''
        The name of the highlight group to use for the bullets.
      '';
    };

    external_link_icon = {
      char = helpers.defaultNullOpts.mkStr "" ''
        Which character to use for the external link icon.
      '';

      hl_group = helpers.defaultNullOpts.mkStr "ObsidianExtLinkIcon" ''
        The name of the highlight group to use for the external link icon.
      '';
    };

    reference_text = {
      hl_group = helpers.defaultNullOpts.mkStr "ObsidianRefText" ''
        The name of the highlight group to use for reference text.
      '';
    };

    highlight_text = {
      hl_group = helpers.defaultNullOpts.mkStr "ObsidianHighlightText" ''
        The name of the highlight group to use for highlight text.
      '';
    };

    tags = {
      hl_group = helpers.defaultNullOpts.mkStr "ObsidianTag" ''
        The name of the highlight group to use for tags.
      '';
    };

    hl_groups = helpers.defaultNullOpts.mkAttrsOf lib.types.highlight {
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
    } "Highlight group definitions.";
  };

  attachments = {
    img_folder = helpers.defaultNullOpts.mkStr "assets/imgs" ''
      The default folder to place images in via `:ObsidianPasteImg`.

      If this is a relative path it will be interpreted as relative to the vault root.
      You can always override this per image by passing a full path to the command instead of just
      a filename.
    '';

    img_text_func =
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

    confirm_img_paste = helpers.defaultNullOpts.mkBool true ''
      Whether to prompt for confirmation when pasting an image.
    '';
  };

  callbacks = {
    post_setup = helpers.mkNullOrLuaFn ''
      `fun(client: obsidian.Client)`

      Runs right after the `obsidian.Client` is initialized.
    '';

    enter_note = helpers.mkNullOrLuaFn ''
      `fun(client: obsidian.Client, note: obsidian.Note)`

      Runs when entering a note buffer.
    '';

    leave_note = helpers.mkNullOrLuaFn ''
      `fun(client: obsidian.Client, note: obsidian.Note)`

      Runs when leaving a note buffer.
    '';

    pre_write_note = helpers.mkNullOrLuaFn ''
      `fun(client: obsidian.Client, note: obsidian.Note)`

      Runs right before writing a note buffer.
    '';

    post_set_workspace = helpers.mkNullOrLuaFn ''
      `fun(client: obsidian.Client, workspace: obsidian.Workspace)`

      Runs anytime the workspace is set/changed.
    '';
  };

  yaml_parser =
    helpers.defaultNullOpts.mkEnumFirstDefault
      [
        "native"
        "yq"
      ]
      ''
        Set the YAML parser to use.

        The valid options are:
        - "native" - uses a pure Lua parser that's fast but potentially misses some edge cases.
        - "yq" - uses the command-line tool yq (https://github.com/mikefarah/yq), which is more robust
          but much slower and needs to be installed separately.

        In general you should be using the native parser unless you run into a bug with it, in which
        case you can temporarily switch to the "yq" parser until the bug is fixed.
      '';
}
