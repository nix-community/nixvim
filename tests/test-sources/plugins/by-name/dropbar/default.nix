{
  empty = {
    plugins.dropbar.enable = true;
  };

  example = {
    plugins.dropbar = {
      enable = true;

      settings = {
        bar = {
          enable = true;
          sources.__raw = ''
            function(buf, _)
              local sources = require('dropbar.sources')
              return {
                require('dropbar.utils').source.fallback({
                  sources.lsp,
                  sources.treesitter,
                  sources.markdown,
                })
              }
            end
          '';
        };
        menu.keymaps = {
          h = "<C-w>q";
          l.__raw = ''
            function()
              local dropbar = require('dropbar')
              local utils = require('dropbar.utils')
              local menu = utils.menu.get_current()
              if not menu then
                return
              end
              local cursor = vim.api.nvim_win_get_cursor(menu.win)
              local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
              if component then
                menu:click_on(component, nil, 1, 'l')
              end
            end
          '';
        };
      };
    };
  };

  defaults = {
    plugins.dropbar = {
      enable = true;

      settings = {
        bar = {
          enable.__raw = ''
            function(buf, win, _)
              if
                not vim.api.nvim_buf_is_valid(buf)
                or not vim.api.nvim_win_is_valid(win)
                or vim.fn.win_gettype(win) ~= ""
                or vim.wo[win].winbar ~= ""
                or vim.bo[buf].ft == 'help'
              then
                return false
              end

              local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
              if stat and stat.size > 1024 * 1024 then
                return false
              end

              return vim.bo[buf].ft == 'markdown'
                or pcall(vim.treesitter.get_parser, buf)
                or not vim.tbl_isempty(vim.lsp.get_clients({
                  bufnr = buf,
                  method = 'textDocument/documentSymbol',
                }))
              end
          '';
          attach_events = [
            "OptionSet"
            "BufWinEnter"
            "BufWritePost"
          ];
          update_debounce = 0;
          update_events = {
            win = [
              "CursorMoved"
              "WinEnter"
              "WinResized"
            ];
            buf = [
              "BufModifiedSet"
              "FileChangedShellPost"
              "TextChanged"
              "ModeChanged"
            ];
            global = [
              "DirChanged"
              "VimResized"
            ];
          };
          hover = true;
          sources.__raw = ''
            function(buf, _)
              local sources = require('dropbar.sources')
              local utils = require('dropbar.utils')
              if vim.bo[buf].ft == 'markdown' then
                return {
                  sources.path,
                  sources.markdown,
                }
              end
              if vim.bo[buf].buftype == 'terminal' then
                return {
                  sources.terminal,
                }
              end
              return {
                sources.path,
                utils.source.fallback({
                  sources.lsp,
                  sources.treesitter,
                }),
              }
            end
          '';
          padding = {
            left = 1;
            right = 1;
          };
          pick = {
            pivots = "abcdefghijklmnopqrstuvwxyz";
          };
          truncate = true;
        };
        menu = {
          quick_navigation = true;
          entry = {
            padding = {
              left = 1;
              right = 1;
            };
          };
          preview = true;
          keymaps = {
            q = "<C-w>q";
            "<Esc>" = "<C-w>q";
            "<LeftMouse>".__raw = ''
              function()
                local menu = utils.menu.get_current()
                if not menu then
                  return
                end
                local mouse = vim.fn.getmousepos()
                local clicked_menu = utils.menu.get({ win = mouse.winid })
                -- If clicked on a menu, invoke the corresponding click action,
                -- else close all menus and set the cursor to the clicked window
                if clicked_menu then
                  clicked_menu:click_at({
                    mouse.line,
                    mouse.column - 1
                  }, nil, 1, 'l')
                  return
                end
                utils.menu.exec('close')
                utils.bar.exec('update_current_context_hl')
                if vim.api.nvim_win_is_valid(mouse.winid) then
                  vim.api.nvim_set_current_win(mouse.winid)
                end
              end
            '';
            "<CR>".__raw = ''
              function()
                local menu = utils.menu.get_current()
                if not menu then
                  return
                end
                local cursor = vim.api.nvim_win_get_cursor(menu.win)
                local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
                if component then
                  menu:click_on(component, nil, 1, 'l')
                end
              end
            '';
            "<MouseMove>".__raw = ''
              function()
                local menu = utils.menu.get_current()
                if not menu then
                  return
                end
                local mouse = vim.fn.getmousepos()
                utils.menu.update_hover_hl(mouse)
                if M.opts.menu.preview then
                  utils.menu.update_preview(mouse)
                end
              end
            '';
            i.__raw = ''
              function()
                local menu = utils.menu.get_current()
                if not menu then
                  return
                end
                menu:fuzzy_find_open()
              end
            '';
          };
          scrollbar = {
            enable = true;
            background = true;
          };
          win_configs = {
            border = "none";
            style = "minimal";
            row.__raw = ''
              function(menu)
                return menu.prev_menu
                    and menu.prev_menu.clicked_at
                    and menu.prev_menu.clicked_at[1] - vim.fn.line('w')
                  or 0
              end
            '';
            col.__raw = ''
              ---@param menu dropbar_menu_t
              function(menu)
                if menu.prev_menu then
                  return menu.prev_menu._win_configs.width
                    + (menu.prev_menu.scrollbar and 1 or 0)
                end
                local mouse = vim.fn.getmousepos()
                local bar = utils.bar.get({ win = menu.prev_win })
                if not bar then
                  return mouse.wincol
                end
                local _, range = bar:get_component_at(math.max(0, mouse.wincol - 1))
                return range and range.start or mouse.wincol
              end
            '';
            relative = "win";
            win.__raw = ''
              function(menu)
                return menu.prev_menu and menu.prev_menu.win
                  or vim.fn.getmousepos().winid
              end
            '';
            height.__raw = ''
              function(menu)
                return math.max(
                  1,
                  math.min(
                    #menu.entries,
                    vim.go.pumheight ~= 0 and vim.go.pumheight
                      or math.ceil(vim.go.lines / 4)
                  )
                )
              end
            '';
            width.__raw = ''
              function(menu)
                local min_width = vim.go.pumwidth ~= 0 and vim.go.pumwidth or 8
                if vim.tbl_isempty(menu.entries) then
                  return min_width
                end
                return math.max(
                  min_width,
                  math.max(unpack(vim.tbl_map(function(entry)
                    return entry:displaywidth()
                  end, menu.entries)))
                )
              end
            '';
            zindex.__raw = ''
              function(menu)
                if menu.prev_menu then
                  if menu.prev_menu.scrollbar and menu.prev_menu.scrollbar.thumb then
                    return vim.api.nvim_win_get_config(menu.prev_menu.scrollbar.thumb).zindex
                  end
                  return vim.api.nvim_win_get_config(menu.prev_win).zindex
                end
              end
            '';
          };
        };
        fzf = {
          win_configs = {
            relative = "win";
            anchor = "NW";
            height = 1;
            win.__raw = ''
              function(menu)
                return menu.win
              end
            '';
            width.__raw = ''
              function(menu)
                local function border_width(border)
                  if type(border) == 'string' then
                    if border == 'none' or border == 'shadow' then
                      return 0
                    end
                    return 2 -- left and right border
                  end

                  local left, right = 1, 1
                  if
                    (#border == 1 and border[1] == "")
                    or (#border == 4 and border[4] == "")
                    or (#border == 8 and border[8] == "")
                  then
                    left = 0
                  end
                  if
                    (#border == 1 and border[1] == "")
                    or (#border == 4 and border[4] == "")
                    or (#border == 8 and border[4] == "")
                  then
                    right = 0
                  end
                  return left + right
                end
                local menu_width = menu._win_configs.width
                  + border_width(menu._win_configs.border)
                local self_width = menu._win_configs.width
                local self_border = border_width(
                  (
                    M.opts.fzf.win_configs
                    and M.eval(M.opts.fzf.win_configs.border, menu)
                  )
                    or (menu.fzf_win_configs and M.eval(
                      menu.fzf_win_configs.border,
                      menu
                    ))
                    or menu._win_configs.border
                )

                if self_width + self_border > menu_width then
                  return self_width - self_border
                else
                  return menu_width - self_border
                end
              end
            '';
            row.__raw = ''
              function(menu)
                local menu_border = menu._win_configs.border
                if
                  type(menu_border) == 'string'
                  and menu_border ~= 'shadow'
                  and menu_border ~= 'none'
                then
                  return menu._win_configs.height + 1
                elseif menu_border == 'none' then
                  return menu._win_configs.height
                end
                local len_menu_border = #menu_border
                if
                  len_menu_border == 1 and menu_border[1] ~= ""
                  or (len_menu_border == 2 or len_menu_border == 4) and menu_border[2] ~= ""
                  or len_menu_border == 8 and menu_border[8] ~= ""
                then
                  return menu._win_configs.height + 1
                else
                  return menu._win_configs.height
                end
              end
            '';
            col.__raw = ''
              function(menu)
                local menu_border = menu._win_configs.border
                if
                  type(menu_border) == 'string'
                  and menu_border ~= 'shadow'
                  and menu_border ~= 'none'
                then
                  return -1
                end
                if
                  type(menu_border) == 'table' and menu_border[#menu_border] ~= ""
                then
                  return -1
                end
                return 0
              end
            '';
          };
          prompt = "%#htmlTag# ";
          char_pattern = "[%w%p]";
          retain_inner_spaces = true;
          fuzzy_find_on_click = true;
        };
        icons = {
          enable = true;
          kinds = {
            dir_icon.__raw = ''
              function(_)
                return M.opts.icons.kinds.symbols.Folder, 'DropBarIconKindFolder'
              end
            '';
            file_icon.__raw = ''
              function(path)
                return M.opts.icons.kinds.symbols.File, 'DropBarIconKindFile'
              end
            '';
            symbols = {
              Array = "󰅪 ";
              Boolean = " ";
              BreakStatement = "󰙧 ";
              Call = "󰃷 ";
              CaseStatement = "󱃙 ";
              Class = " ";
              Color = "󰏘 ";
              Constant = "󰏿 ";
              Constructor = " ";
              ContinueStatement = "→ ";
              Copilot = " ";
              Declaration = "󰙠 ";
              Delete = "󰩺 ";
              DoStatement = "󰑖 ";
              Element = "󰅩 ";
              Enum = " ";
              EnumMember = " ";
              Event = " ";
              Field = " ";
              File = "󰈔 ";
              Folder = "󰉋 ";
              ForStatement = "󰑖 ";
              Function = "󰊕 ";
              H1Marker = "󰉫 ";
              H2Marker = "󰉬 ";
              H3Marker = "󰉭 ";
              H4Marker = "󰉮 ";
              H5Marker = "󰉯 ";
              H6Marker = "󰉰 ";
              Identifier = "󰀫 ";
              IfStatement = "󰇉 ";
              Interface = " ";
              Keyword = "󰌋 ";
              List = "󰅪 ";
              Log = "󰦪 ";
              Lsp = " ";
              Macro = "󰁌 ";
              MarkdownH1 = "󰉫 ";
              MarkdownH2 = "󰉬 ";
              MarkdownH3 = "󰉭 ";
              MarkdownH4 = "󰉮 ";
              MarkdownH5 = "󰉯 ";
              MarkdownH6 = "󰉰 ";
              Method = "󰆧 ";
              Module = "󰏗 ";
              Namespace = "󰅩 ";
              Null = "󰢤 ";
              Number = "󰎠 ";
              Object = "󰅩 ";
              Operator = "󰆕 ";
              Package = "󰆦 ";
              Pair = "󰅪 ";
              Property = " ";
              Reference = "󰦾 ";
              Regex = " ";
              Repeat = "󰑖 ";
              RuleSet = "󰅩 ";
              Scope = "󰅩 ";
              Snippet = "󰩫 ";
              Specifier = "󰦪 ";
              Statement = "󰅩 ";
              String = "󰉾 ";
              Struct = " ";
              SwitchStatement = "󰺟 ";
              Terminal = " ";
              Text = " ";
              Type = " ";
              TypeParameter = "󰆩 ";
              Unit = " ";
              Value = "󰎠 ";
              Variable = "󰀫 ";
              WhileStatement = "󰑖 ";
            };
          };
          ui = {
            bar = {
              separator = " ";
              extends = "…";
            };
            menu = {
              separator = " ";
              indicator = " ";
            };
          };
        };
        symbol = {
          on_click.__raw = ''
            function(symbol)
              -- Update current context highlights if the symbol
              -- is shown inside a menu
              if symbol.entry and symbol.entry.menu then
                symbol.entry.menu:update_current_context_hl(symbol.entry.idx)
              elseif symbol.bar then
                symbol.bar:update_current_context_hl(symbol.bar_idx)
              end

              -- Determine menu configs
              local prev_win = nil ---@type integer?
              local entries_source = nil ---@type dropbar_symbol_t[]?
              local init_cursor = nil ---@type integer[]?
              local win_configs = {}
              if symbol.bar then -- If symbol inside a dropbar
                prev_win = symbol.bar.win
                entries_source = symbol.opts.siblings
                init_cursor = symbol.opts.sibling_idx
                  and { symbol.opts.sibling_idx, 0 }
                if symbol.bar.in_pick_mode then
                  ---@param tbl number[]
                  local function tbl_sum(tbl)
                    local sum = 0
                    for _, v in ipairs(tbl) do
                      sum = sum + v
                    end
                    return sum
                  end
                  win_configs.relative = 'win'
                  win_configs.win = vim.api.nvim_get_current_win()
                  win_configs.row = 0
                  win_configs.col = symbol.bar.padding.left
                    + tbl_sum(vim.tbl_map(
                      function(component)
                        return component:displaywidth()
                          + symbol.bar.separator:displaywidth()
                      end,
                      vim.tbl_filter(function(component)
                        return component.bar_idx < symbol.bar_idx
                      end, symbol.bar.components)
                    ))
                end
              elseif symbol.entry and symbol.entry.menu then -- If inside a menu
                prev_win = symbol.entry.menu.win
                entries_source = symbol.opts.children
              end

              -- Toggle existing menu
              if symbol.menu then
                symbol.menu:toggle({
                  prev_win = prev_win,
                  win_configs = win_configs,
                })
                return
              end

              -- Create a new menu for the symbol
              if not entries_source or vim.tbl_isempty(entries_source) then
                return
              end

              local menu = require('dropbar.menu')
              local configs = require('dropbar.configs')
              symbol.menu = menu.dropbar_menu_t:new({
                prev_win = prev_win,
                cursor = init_cursor,
                win_configs = win_configs,
                ---@param sym dropbar_symbol_t
                entries = vim.tbl_map(function(sym)
                  local menu_indicator_icon = configs.opts.icons.ui.menu.indicator
                  local menu_indicator_on_click = nil
                  if not sym.children or vim.tbl_isempty(sym.children) then
                    menu_indicator_icon =
                      string.rep(' ', vim.fn.strdisplaywidth(menu_indicator_icon))
                    menu_indicator_on_click = false
                  end
                  return menu.dropbar_menu_entry_t:new({
                    components = {
                      sym:merge({
                        name = "",
                        icon = menu_indicator_icon,
                        icon_hl = 'dropbarIconUIIndicator',
                        on_click = menu_indicator_on_click,
                      }),
                      sym:merge({
                        on_click = function()
                          local current_menu = symbol.menu
                          while current_menu and current_menu.prev_menu do
                            current_menu = current_menu.prev_menu
                          end
                          if current_menu then
                            current_menu:close(false)
                          end
                          sym:jump()
                        end,
                      }),
                    },
                  })
                end, entries_source),
              })
              symbol.menu:toggle()
            end
          '';
          preview = {
            reorient.__raw = ''
              function(_, range)
                local invisible = range['end'].line - vim.fn.line('w$') + 1
                if invisible > 0 then
                  local view = vim.fn.winsaveview() --[[@as vim.fn.winrestview.dict]]
                  view.topline = math.min(
                    view.topline + invisible,
                    math.max(1, range.start.line - vim.wo.scrolloff + 1)
                  )
                  vim.fn.winrestview(view)
                end
              end
            '';
          };
          jump = {
            reorient.__raw = ''
              function(win, range)
                local view = vim.fn.winsaveview()
                local win_height = vim.api.nvim_win_get_height(win)
                local topline = range.start.line - math.floor(win_height / 4)
                if
                  topline > view.topline
                  and topline + win_height < vim.fn.line('$')
                then
                  view.topline = topline
                  vim.fn.winrestview(view)
                end
              end
            '';
          };
        };
        sources = {
          path = {
            max_depth = 16;
            relative_to.__raw = ''
              function(_, win)
                -- Workaround for Vim:E5002: Cannot find window number
                local ok, cwd = pcall(vim.fn.getcwd, win)
                return ok and cwd or vim.fn.getcwd()
              end
            '';
            path_filter.__raw = "function(_) return true end";
            modified.__raw = "function(sym) return sym end";
            preview.__raw = ''
              function(path)
                local stat = vim.uv.fs_stat(path)
                if not stat or stat.type ~= 'file' then
                  return false
                end
                if stat.size > 524288 then
                  vim.notify(
                    string.format(
                      '[dropbar.nvim] file "%s" too large to preview',
                      path
                    ),
                    vim.log.levels.WARN
                  )
                  return false
                end
                return true
              end
            '';
          };
          treesitter = {
            max_depth = 16;
            name_regex = "[=[[#~!@\*&.]*[[:keyword:]]\+!\?\(\(\(->\)\+\|-\+\|\.\+\|:\+\|\s\+\)\?[#~!@\*&.]*[[:keyword:]]\+!\?\)*]=]";
            valid_types = [
              "array"
              "boolean"
              "break_statement"
              "call"
              "case_statement"
              "class"
              "constant"
              "constructor"
              "continue_statement"
              "delete"
              "do_statement"
              "element"
              "enum"
              "enum_member"
              "event"
              "for_statement"
              "function"
              "h1_marker"
              "h2_marker"
              "h3_marker"
              "h4_marker"
              "h5_marker"
              "h6_marker"
              "if_statement"
              "interface"
              "keyword"
              "macro"
              "method"
              "module"
              "namespace"
              "null"
              "number"
              "operator"
              "package"
              "pair"
              "property"
              "reference"
              "repeat"
              "rule_set"
              "scope"
              "specifier"
              "struct"
              "switch_statement"
              "type"
              "type_parameter"
              "unit"
              "value"
              "variable"
              "while_statement"
              "declaration"
              "field"
              "identifier"
              "object"
              "statement"
            ];
          };
          lsp = {
            max_depth = 16;
            valid_symbols = [
              "File"
              "Module"
              "Namespace"
              "Package"
              "Class"
              "Method"
              "Property"
              "Field"
              "Constructor"
              "Enum"
              "Interface"
              "Function"
              "Variable"
              "Constant"
              "String"
              "Number"
              "Boolean"
              "Array"
              "Object"
              "Keyword"
              "Null"
              "EnumMember"
              "Struct"
              "Event"
              "Operator"
              "TypeParameter"
            ];
            request = {
              ttl_init = 60;
              interval = 1000;
            };
          };
          markdown = {
            max_depth = 6;
            parse = {
              look_ahead = 200;
            };
          };
          terminal = {
            icon.__raw = ''
              function(_)
                return M.opts.icons.kinds.symbols.Terminal or ' '
              end
            '';
            name.__raw = "vim.api.nvim_buf_get_name";
            show_current = true;
          };
        };
      };
    };
  };
}
