{
  empty = {
    # TODO fix the plugin tests
    plugins.obsidian.enable = false;
  };

  example = {
    plugins = {
      nvim-cmp.enable = true;

      obsidian = {
        enable = false;

        dir = null;
        workspaces = [
          {
            name = "personal";
            path = "~/vaults/personal";
          }
          {
            name = "work";
            path = "~/vaults/work";
            overrides = {
              notesSubdir = "notes";
            };
          }
        ];
        detectCwd = false;

        logLevel = "info";
        notesSubdir = "notes";
        templates = {
          # We cannot set this as it doesn't exist in the testing environment
          # subdir = "templates";
          dateFormat = "%Y-%m-%d";
          timeFormat = "%H:%M";
          substitutions = {};
        };
        noteIdFunc = ''
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
        '';
        followUrlFunc = ''
          function(url)
            -- Open the URL in the default web browser.
            vim.fn.jobstart({"open", url})  -- Mac OS
            -- vim.fn.jobstart({"xdg-open", url})  -- linux
          end
        '';
        noteFrontmatterFunc = ''
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
        '';
        disableFrontmatter = false;
        backlinks = {
          height = 10;
          wrap = true;
        };
        completion = {
          nvimCmp = true;
          minChars = 2;
          newNotesLocation = "current_dir";
          prependNoteId = true;
          prependNotePath = false;
          usePathOnly = false;
        };
        mappings = {
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
        };
        dailyNotes = {
          folder = "notes";
          dateFormat = "%Y-%m-%d";
          aliasFormat = "%B %-d, %Y";
          template = "daily.md";
        };
        useAdvancedUri = false;
        openAppForeground = false;
        finder = "telescope.nvim";
        sortBy = "modified";
        sortReversed = true;
        openNotesIn = "current";
        ui = {
          enable = true;
          updateDebounce = 200;
          checkboxes = {
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
          };
          externalLinkIcon = {
            char = "";
            hlGroup = "ObsidianExtLinkIcon";
          };
          referenceText = {
            hlGroup = "ObsidianRefText";
          };
          highlightText = {
            hlGroup = "ObsidianHighlightText";
          };
          tags = {
            hlGroup = "ObsidianTag";
          };
          hlGroups = {
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
          };
        };
        attachments = {
          imgFolder = "assets/imgs";
          imgTextFunc = ''
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
          '';
        };
        yamlParser = "native";
      };
    };
  };
}
