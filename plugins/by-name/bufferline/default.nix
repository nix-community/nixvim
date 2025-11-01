{ lib, config, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "bufferline";
  package = "bufferline-nvim";
  description = "A snazzy bufferline plugin for Neovim.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsOptions = {
    options = {
      custom_filter = defaultNullOpts.mkLuaFn null ''
        ```
        fun(buf: number, bufnums: number[]): boolean
        ```

        NOTE: this will be called a lot so don't do any heavy processing here.
      '';

      name_formatter = defaultNullOpts.mkLuaFn null ''
        A lua function that can be used to modify the buffer's label.
        The argument 'buf' containing a name, path and bufnr is supplied.
      '';

      get_element_icon = defaultNullOpts.mkLuaFn null ''
        Lua function returning an element icon.

        ```
        fun(opts: IconFetcherOpts): string?, string?
        ```
      '';

      diagnostics_indicator = defaultNullOpts.mkLuaFn null ''
        Either `null` or a function that returns the diagnostics indicator.
      '';
    };
  };

  settingsExample = {
    options = {
      mode = "buffers";
      always_show_bufferline = true;
      buffer_close_icon = "󰅖";
      close_icon = "";
      diagnostics = "nvim_lsp";
      diagnostics_indicator = # Lua
        ''
          function(count, level, diagnostics_dict, context)
            local s = ""
            for e, n in pairs(diagnostics_dict) do
              local sym = e == "error" and " "
                or (e == "warning" and " " or "" )
              if(sym ~= "") then
                s = s .. " " .. n .. sym
              end
            end
            return s
          end
        '';
      enforce_regular_tabs = false;
      groups = {
        options = {
          toggle_hidden_on_enter = true;
        };
        items = [
          {
            name = "Tests";
            highlight = {
              underline = true;
              fg = "#a6da95";
              sp = "#494d64";
            };
            priority = 2;
            matcher.__raw = # Lua
              ''
                function(buf)
                  return buf.name:match('%test') or buf.name:match('%.spec')
                end
              '';
          }
          {
            name = "Docs";
            highlight = {
              undercurl = true;
              fg = "#ffffff";
              sp = "#494d64";
            };
            auto_close = false;
            matcher.__raw = # Lua
              ''
                function(buf)
                  return buf.name:match('%.md') or buf.name:match('%.txt')
                end
              '';
          }
        ];
      };
      indicator = {
        style = "icon";
        icon = "▎";
      };
      left_trunc_marker = "";
      max_name_length = 18;
      max_prefix_length = 15;
      modified_icon = "●";
      numbers.__raw = # Lua
        ''
          function(opts)
            return string.format('%s·%s', opts.raise(opts.id), opts.lower(opts.ordinal))
          end
        '';
      persist_buffer_sort = true;
      right_trunc_marker = "";
      show_buffer_close_icons = true;
      show_buffer_icons = true;
      show_close_icon = true;
      show_tab_indicators = true;
      tab_size = 18;
      offsets = [
        {
          filetype = "neo-tree";
          text = "File Explorer";
          text_align = "center";
          highlight = "Directory";
        }
      ];
      custom_filter = # Lua
        ''
          function(buf_number, buf_numbers)
            -- filter out filetypes you don't want to see
            if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
                return true
            end
            -- filter out by buffer name
            if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
                return true
            end
            -- filter out based on arbitrary rules
            -- e.g. filter out vim wiki buffer from tabline in your work repo
            if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
                return true end -- filter out by it's index number in list (don't show first buffer)
            if buf_numbers[1] ~= buf_number then
                return true
            end
          end
        '';
      get_element_icon = # Lua
        ''
          function(element)
            -- element consists of {filetype: string, path: string, extension: string, directory: string}
            -- This can be used to change how bufferline fetches the icon
            -- for an element e.g. a buffer or a tab.
            -- e.g.
            local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(element.filetype, { default = false })
            return icon, hl
          end
        '';
      separator_style = [
        "|"
        "|"
      ];
      sort_by.__raw = ''
        function(buffer_a, buffer_b)
            local modified_a = vim.fn.getftime(buffer_a.path)
            local modified_b = vim.fn.getftime(buffer_b.path)
            return modified_a > modified_b
        end
      '';
    };
    highlights =
      let
        commonBgColor = "#363a4f";
        commonFgColor = "#1e2030";
        commonSelectedAttrs = {
          bg = commonBgColor;
        };
        selectedAttrsSet = builtins.listToAttrs (
          map
            (name: {
              inherit name;
              value = commonSelectedAttrs;
            })
            [
              "buffer_selected"
              "tab_selected"
              "numbers_selected"
            ]
        );
      in
      selectedAttrsSet
      // {
        fill = {
          bg = commonFgColor;
        };
        separator = {
          fg = commonFgColor;
        };
        separator_visible = {
          fg = commonFgColor;
        };
        separator_selected = {
          bg = commonBgColor;
          fg = commonFgColor;
        };
      };
  };

  extraConfig = {
    # TODO: added 2024-09-20 remove after 24.11
    plugins.web-devicons = lib.mkIf (
      !(
        (
          config.plugins.mini.enable
          && config.plugins.mini.modules ? icons
          && config.plugins.mini.mockDevIcons
        )
        || (config.plugins.mini-icons.enable && config.plugins.mini-icons.mockDevIcons)
      )
    ) { enable = lib.mkOverride 1490 true; };

    opts.termguicolors = true;
  };
}
