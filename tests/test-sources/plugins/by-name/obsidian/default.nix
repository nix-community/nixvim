{
  # Note: we can only use `~/` as a workspace as the workspace folder need to exist in the sandbox.

  empty = {
    plugins.obsidian = {
      enable = true;

      # TODO 2025-07-25 explicitly disable legacy commands to suppress deprecation warning
      settings.legacy_commands = false;

      # At least one workspaces is needed for the plugin to work
      settings.workspaces = [
        {
          name = "foo";
          path = "~/";
        }
      ];
    };
  };

  simple-example = {
    plugins = {
      cmp.enable = true;

      obsidian = {
        enable = true;

        settings = {
          # TODO 2025-07-25 explicitly disable legacy commands to suppress deprecation warning
          legacy_commands = false;

          dir.__raw = "nil";
          workspaces = [
            {
              name = "work";
              path = "~";
            }
          ];
          new_notes_location = "current_dir";
          completion = {
            nvim_cmp = true;
            blink = false;
            min_chars = 2;
          };
        };
      };
    };
  };

  blink-cmp = {
    # Issue within the obsidian.nvim plugin itself:
    # ERROR: cmp.add_provider is deprecated, use cmp.add_source_provider instead.
    test.runNvim = false;

    plugins = {
      blink-cmp.enable = true;
      obsidian = {
        enable = true;
        settings = {
          completion.blink = true;
          workspaces = [
            {
              name = "foo";
              path = "~/";
            }
          ];
        };
      };
    };
  };

  complete-example = {
    plugins = {
      cmp.enable = true;

      obsidian = {
        enable = false;

        settings = {
          dir.__raw = "nil";
          workspaces = [
            {
              name = "work";
              path = "~/";
              overrides = {
                notes_subdir = "notes";
              };
            }
          ];
          log_level = "info";
          notes_subdir = "notes";
          templates = {
            # We cannot set this as it doesn't exist in the testing environment
            # subdir = "templates";
            date_format = "%Y-%m-%d";
            time_format = "%H:%M";
            substitutions.__empty = { };
          };
          new_notes_location = "current_dir";
          note_id_func = ''
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
          note_path_func = ''
            function(spec)
              -- This is equivalent to the default behavior.
              local path = spec.dir / tostring(spec.id)
              return path:with_suffix(".md")
            end
          '';
          wiki_link_func = ''
            function(opts)
              if opts.id == nil then
                return string.format("[[%s]]", opts.label)
              elseif opts.label ~= opts.id then
                return string.format("[[%s|%s]]", opts.id, opts.label)
              else
                return string.format("[[%s]]", opts.id)
              end
            end
          '';
          markdown_link_func = ''
            function(opts)
              return string.format("[%s](%s)", opts.label, opts.path)
            end
          '';
          preferred_link_style = "wiki";
          follow_url_func = ''
            function(url)
              -- Open the URL in the default web browser.
              vim.fn.jobstart({"open", url})  -- Mac OS
              -- vim.fn.jobstart({"xdg-open", url})  -- linux
            end
          '';
          image_name_func = ''
            function()
              -- Prefix image names with timestamp.
              return string.format("%s-", os.time())
            end
          '';
          note_frontmatter_func = ''
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
          '';
          disable_frontmatter = false;
          completion = {
            nvim_cmp = true;
            min_chars = 2;
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
          picker = {
            name = "telescope.nvim";
            note_mappings = {
              new = "<C-x>";
              insert_link = "<C-l>";
            };
            tag_mappings = {
              tag_note = "<C-x>";
              insert_tag = "<C-l>";
            };
          };
          daily_notes = {
            folder = "notes";
            date_format = "%Y-%m-%d";
            alias_format = "%B %-d, %Y";
            template = "daily.md";
          };
          use_advanced_uri = false;
          open_app_foreground = false;
          sort_by = "modified";
          sort_reversed = true;
          open_notes_in = "current";
          ui = {
            enable = true;
            update_debounce = 200;
            checkboxes = {
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
            };
            bullets = {
              char = "•";
              hl_group = "ObsidianBullet";
            };
            external_link_icon = {
              char = "";
              hl_group = "ObsidianExtLinkIcon";
            };
            reference_text = {
              hl_group = "ObsidianRefText";
            };
            highlight_text = {
              hl_group = "ObsidianHighlightText";
            };
            tags = {
              hl_group = "ObsidianTag";
            };
            hl_groups = {
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
            img_folder = "assets/imgs";
            img_text_func = ''
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
            confirm_img_paste = true;
          };
          callbacks = {
            post_setup = "function(client) end";
            enter_note = "function(client, note) end";
            leave_note = "function(client, note) end";
            pre_write_note = "function(client, note) end";
            post_set_workspace = "function(client, workspace) end";
          };
          yaml_parser = "native";
        };
      };
    };
  };
}
