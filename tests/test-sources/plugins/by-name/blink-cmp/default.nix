{
  empty = {
    test.runNvim = false;
    plugins.blink-cmp.enable = true;
  };

  defaults = {
    test.runNvim = false;
    plugins.blink-cmp = {
      enable = true;

      settings = {
        keymap = {
          preset = "default";
        };
        completion = {
          keyword = {
            range = "prefix";
            regex = "[-_]\\|\\k";
            exclude_from_prefix_regex = "-";
          };
          trigger = {
            prefetch_on_insert = false;
            show_in_snippet = true;
            show_on_keyword = true;
            show_on_trigger_character = true;
            show_on_blocked_trigger_characters.__raw = ''
              function()
                if vim.api.nvim_get_mode().mode == 'c' then return {} end
                  return { ' ', '\n', '\t' }
                end
            '';
            show_on_accept_on_trigger_character = true;
            show_on_insert_on_trigger_character = true;
            show_on_x_blocked_trigger_characters = [
              "'"
              ''"''
              "("
              "{"
              "["
            ];
          };
          list = {
            max_items = 200;
            selection = "preselect";
            cycle = {
              from_bottom = true;
              from_top = true;
            };
          };
          accept = {
            create_undo_point = true;
            auto_brackets = {
              enabled = true;
              default_brackets = [
                "("
                ")"
              ];
              override_brackets_for_filetypes = { };
              force_allow_filetypes = [ ];
              blocked_filetypes = [ ];
              kind_resolution = {
                enabled = true;
                blocked_filetypes = [
                  "typescriptreact"
                  "javascriptreact"
                  "vue"
                  "rust"
                ];
              };
              semantic_token_resolution = {
                enabled = true;
                blocked_filetypes = [
                  "java"
                ];
                timeout_ms = 400;
              };
            };
          };
          menu = {
            enabled = true;
            min_width = 15;
            max_height = 10;
            border = "none";
            winblend = 0;
            winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None";
            scrolloff = 2;
            scrollbar = true;
            direction_priority = [
              "s"
              "n"
            ];
            order = {
              n = "bottom_up";
              s = "top_down";
            };
            auto_show = true;
            cmdline_position.__raw = ''
              function()
                if vim.g.ui_cmdline_pos ~= nil then
                  local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
                  return { pos[1] - 1, pos[2] }
                end
                local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
                return { vim.o.lines - height, 0 }
              end
            '';
            draw = {
              align_to = "label";
              padding = 1;
              gap = 1;
              treesitter = { };
              columns = [
                [ "kind_icon" ]
                {
                  __unkeyed-1 = "label";
                  __unkeyed-2 = "label_description";
                  gap = 1;
                }
              ];
              components = {
                kind_icon = {
                  ellipsis = false;
                  text.__raw = "function(ctx) return ctx.kind_icon .. ctx.icon_gap end";
                  highlight.__raw = ''
                    function(ctx)
                      return require('blink.cmp.completion.windows.render.tailwind').get_hl(ctx) or ('BlinkCmpKind' .. ctx.kind)
                    end
                  '';
                };
                kind = {
                  ellipsis = false;
                  width.fill = true;
                  text.__raw = "function(ctx) return ctx.kind end";
                  highlight.__raw = ''
                    function(ctx)
                      return require('blink.cmp.completion.windows.render.tailwind').get_hl(ctx) or ('BlinkCmpKind' .. ctx.kind)
                    end
                  '';
                };
                label = {
                  width = {
                    fill = true;
                    max = 60;
                  };
                  text.__raw = "function(ctx) return ctx.label .. ctx.label_detail end";
                  highlight.__raw = ''
                    function(ctx)
                      -- label and label details
                      local label = ctx.label
                      local highlights = {
                        { 0, #label, group = ctx.deprecated and 'BlinkCmpLabelDeprecated' or 'BlinkCmpLabel' },
                      }
                      if ctx.label_detail then
                        table.insert(highlights, { #label, #label + #ctx.label_detail, group = 'BlinkCmpLabelDetail' })
                      end

                      if vim.list_contains(ctx.self.treesitter, ctx.source_id) then
                        -- add treesitter highlights
                        vim.list_extend(highlights, require('blink.cmp.completion.windows.render.treesitter').highlight(ctx))
                      end

                      -- characters matched on the label by the fuzzy matcher
                      for _, idx in ipairs(ctx.label_matched_indices) do
                        table.insert(highlights, { idx, idx + 1, group = 'BlinkCmpLabelMatch' })
                      end

                      return highlights
                    end
                  '';
                };
                label_description = {
                  width.max = 30;
                  text.__raw = "function(ctx) return ctx.label_description end";
                  highlight = "BlinkCmpLabelDescription";
                };
                source_name = {
                  width.max = 30;
                  text.__raw = "function(ctx) return ctx.source_name end";
                  highlight = "BlinkCmpSource";
                };
              };
            };
          };
          documentation = {
            auto_show = false;
            auto_show_delay_ms = 500;
            update_delay_ms = 50;
            treesitter_highlighting = true;
            window = {
              min_width = 10;
              max_width = 80;
              max_height = 20;
              desired_min_width = 50;
              desired_min_height = 10;
              border = "padded";
              winblend = 0;
              winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc";
              scrollbar = true;
              direction_priority = {
                menu_north = [
                  "e"
                  "w"
                  "n"
                  "s"
                ];
                menu_south = [
                  "e"
                  "w"
                  "s"
                  "n"
                ];
              };
            };
          };
          ghost_text = {
            enabled = false;
          };
        };
        fuzzy = {
          use_typo_resistance = true;
          use_frecency = true;
          use_proximity = true;
          use_unsafe_no_lock = false;
          sorts = [
            "score"
            "sort_text"
          ];
          prebuilt_binaries = {
            download = true;
            ignore_version_mismatch = false;
            force_version = null;
            force_system_triple = null;
            extra_curl_args = [ ];
          };
        };
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
          ];
          per_filetype = { };
          cmdline.__raw = ''
            function()
              local type = vim.fn.getcmdtype()
              -- Search forward and backward
              if type == '/' or type == '?' then return { 'buffer' } end
              -- Commands
              if type == ':' then return { 'cmdline' } end
              return {}
            end
          '';
          transform_items.__raw = "function(_, items) return items end";
          min_keyword_length = 0;
          providers = {
            lsp = {
              name = "LSP";
              module = "blink.cmp.sources.lsp";
              fallbacks = [ "buffer" ];
              transform_items.__raw = ''
                function(_, items)
                  -- demote snippets
                  for _, item in ipairs(items) do
                    if item.kind == require('blink.cmp.types').CompletionItemKind.Snippet then
                      item.score_offset = item.score_offset - 3
                    end
                  end

                  -- filter out text items, since we have the buffer source
                  return vim.tbl_filter(
                    function(item) return item.kind ~= require('blink.cmp.types').CompletionItemKind.Text end,
                    items
                  )
                end
              '';
            };
            path = {
              name = "Path";
              module = "blink.cmp.sources.path";
              score_offset = 3;
              fallbacks = [ "buffer" ];
            };
            snippets = {
              name = "Snippets";
              module = "blink.cmp.sources.snippets";
              score_offset = -3;
            };
            luasnip = {
              name = "Luasnip";
              module = "blink.cmp.sources.luasnip";
              score_offset = -3;
            };
            buffer = {
              name = "Buffer";
              module = "blink.cmp.sources.buffer";
              score_offset = -3;
            };
            cmdline = {
              name = "cmdline";
              module = "blink.cmp.sources.cmdline";
            };
          };
        };
        signature = {
          enabled = false;
          trigger = {
            enabled = true;
            blocked_trigger_characters = [ ];
            blocked_retrigger_characters = [ ];
            show_on_insert_on_trigger_character = true;
          };
          window = {
            min_width = 1;
            max_width = 100;
            max_height = 10;
            border = "padded";
            winblend = 0;
            winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder";
            scrollbar = false;
            direction_priority = [
              "n"
              "s"
            ];
            treesitter_highlighting = true;
          };
        };
        snippets = {
          expand.__raw = "function(snippet) vim.snippet.expand(snippet) end";
          active.__raw = "function(filter) return vim.snippet.active(filter) end";
          jump.__raw = "function(direction) vim.snippet.jump(direction) end";
        };
        appearance = {
          highlight_ns.__raw = "vim.api.nvim_create_namespace('blink_cmp')";
          use_nvim_cmp_as_default = false;
          nerd_font_variant = "mono";
          kind_icons = {
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
          };
        };
      };
    };
  };

  example = {
    plugins.blink-cmp = {
      enable = true;
      settings = {
        keymap.preset = "super-tab";
        sources = {
          providers = {
            buffer.score_offset = -7;
            lsp.fallbacks = [ ];
          };
          cmdline = [ ];
        };
        completion = {
          accept = {
            auto_brackets = {
              enabled = true;
              semantic_token_resolution.enabled = false;
            };
          };
          documentation.auto_show = true;
        };
        appearance = {
          use_nvim_cmp_as_default = true;
          nerd_font_variant = "normal";
        };
        signature.enabled = true;
      };
    };
  };
}
