{
  empty = {
    plugins.papis.enable = true;
  };

  defaults = {
    plugins.papis = {
      enable = true;

      settings = {
        search.enable = true;
        completion.enable = true;
        at-cursor.enable = true;
        formatter.enable = true;
        colors.enable = true;
        base.enable = true;
        debug.enable = true;
        cite_formats = {
          tex = {
            start_str = "[[\cite{]]";
            end_str = "}";
            separator_str = ", ";
          };
          markdown = {
            ref_prefix = "@";
            separator_str = "; ";
          };
          rmd = {
            ref_prefix = "@";
            separator_str = "; ";
          };
          plain = {
            separator_str = ", ";
          };
          org = {
            start_str = "[cite:";
            end_str = "]";
            ref_prefix = "@";
            separator_str = ";";
          };
          norg = {
            start_str = "{= ";
            end_str = "}";
            separator_str = "; ";
          };
          typst = {
            ref_prefix = "@";
            separator_str = " ";
          };
        };
        cite_formats_fallback = "plain";
        enable_keymaps = false;
        enable_fs_watcher = true;
        data_tbl_schema = {
          id = {
            __unkeyed-type = "integer";
            pk = true;
          };
          papis_id = {
            __unkeyed-type = "text";
            required = true;
            unique = true;
          };
          ref = {
            __unkeyed-type = "text";
            required = true;
            unique = true;
          };
          author = "text";
          editor = "text";
          year = "text";
          title = "text";
          shorttitle = "text";
          type = "text";
          abstract = "text";
          time_added = "text";
          notes = "luatable";
          journal = "text";
          volume = "text";
          number = "text";
          author_list = "luatable";
          tags = "luatable";
          files = "luatable";
        };
        db_path.__raw = "vim.fn.stdpath('data') .. '/papis_db/papis-nvim.sqlite3'";
        yq_bin = "yq";
        create_new_note_fn.__raw = ''
          function(papis_id, notes_name)
            vim.fn.system(
              string.format(
                "papis update --set notes %s papis_id:%s",
                vim.fn.shellescape(notes_name),
                vim.fn.shellescape(papis_id)
              )
            )
          end
        '';
        init_filetypes = [
          "markdown"
          "norg"
          "yaml"
          "typst"
        ];
        papis_conf_keys = [
          "info-name"
          "notes-name"
          "dir"
          "opentool"
        ];
        enable_icons = true;
        search = {
          wrap = true;
          initial_sort_by_time_added = true;
          search_keys = [
            "author"
            "editor"
            "year"
            "title"
            "tags"
          ];
          preview_format = [
            [
              "author"
              "%s"
              "PapisPreviewAuthor"
            ]
            [
              "year"
              "%s"
              "PapisPreviewYear"
            ]
            [
              "title"
              "%s"
              "PapisPreviewTitle"
            ]
            [ "empty_line" ]
            [
              "journal"
              "%s"
              "PapisPreviewValue"
              "show_key"
              [
                "󱀁  "
                "%s: "
              ]
              "PapisPreviewKey"
            ]
            [
              "type"
              "%s"
              "PapisPreviewValue"
              "show_key"
              [
                "  "
                "%s: "
              ]
              "PapisPreviewKey"
            ]
            [
              "ref"
              "%s"
              "PapisPreviewValue"
              "show_key"
              [
                "  "
                "%s: "
              ]
              "PapisPreviewKey"
            ]
            [
              "tags"
              "%s"
              "PapisPreviewValue"
              "show_key"
              [
                "  "
                "%s: "
              ]
              "PapisPreviewKey"
            ]
            [
              "abstract"
              "%s"
              "PapisPreviewValue"
              "show_key"
              [
                "󰭷  "
                "%s: "
              ]
              "PapisPreviewKey"
            ]
          ];
          results_format = [
            [
              "files"
              [
                " "
                "F "
              ]
              "PapisResultsFiles"
              "force_space"
            ]
            [
              "notes"
              [
                "󰆈 "
                "N "
              ]
              "PapisResultsNotes"
              "force_space"
            ]
            [
              "author"
              "%s "
              "PapisResultsAuthor"
            ]
            [
              "year"
              "(%s) "
              "PapisResultsYear"
            ]
            [
              "title"
              "%s"
              "PapisResultsTitle"
            ]
          ];
        };
        at-cursor = {
          popup_format = [
            [
              "author"
              "%s"
              "PapisPopupAuthor"
            ]
            [
              "vspace"
              "vspace"
            ]
            [
              "files"
              [
                " "
                "F "
              ]
              "PapisResultsFiles"
            ]
            [
              "notes"
              [
                "󰆈 "
                "N "
              ]
              "PapisResultsNotes"
            ]
            [
              "year"
              "%s"
              "PapisPopupYear"
            ]
            [
              "title"
              "%s"
              "PapisPopupTitle"
            ]
          ];
        };
        formatter = {
          format_notes.__raw = ''
            function(entry)
              -- Some string formatting templates (see above `results_format` option for
              -- more details)
              local title_format = {
                { "author", "%s ", "" },
                { "year", "(%s) ", "" },
                { "title", "%s", "" },
              }
              -- Format the strings with information in the entry
              local title = require("papis.utils"):format_display_strings(entry, title_format, true)
              -- Grab only the strings (and disregard highlight groups)
              for k, v in ipairs(title) do
                title[k] = v[1]
              end
              -- Define all the lines to be inserted
              local lines = {
                "---",
                'title: "Notes -- ' .. table.concat(title) .. '"',
                "---",
                "",
              }
              return lines
            end
          '';
          format_references.__raw = ''
            function(entry)
              local reference_format = {
                { "author",  "%s ",   "" },
                { "year",    "(%s). ", "" },
                { "title",   "%s. ",  "" },
                { "journal", "%s. ",    "" },
                { "volume",  "%s",    "" },
                { "number",  "(%s)",  "" },
              }
              local reference_data = require("papis.utils"):format_display_strings(entry, reference_format)
              for k, v in ipairs(reference_data) do
                reference_data[k] = v[1]
              end
              local lines = { table.concat(reference_data) }
              return lines
            end
          '';
        };
        papis-storage = {
          key_name_conversions = {
            time_added = "time-added";
          };
          tag_format.__raw = "nil";
          required_keys = [
            "papis_id"
            "ref"
          ];
        };
      };
    };
  };

  example = {
    plugins.papis = {
      enable = true;

      settings = {
        enable_keymaps = true;
        papis_python = {
          dir = "~/Documents/papers";
          info_name = "info.yaml";
          notes_name.__raw = "[[notes.norg]]";
        };
        search.enable = true;
        completion.enable = true;
        cursor-actions.enable = true;
        formatter.enable = true;
        colors.enable = true;
        base.enable = true;
        debug.enable = true;
        cite_formats = {
          tex = [
            "\\cite{%s}"
            "\\cite[tp]?%*?{%s}"
          ];
          markdown = "@%s";
          rmd = "@%s";
          plain = "%s";
          org = [
            "[cite:@%s]"
            "%[cite:@%s]"
          ];
          norg = "{= %s}";
        };
      };
    };
  };
}
