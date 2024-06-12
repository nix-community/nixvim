{
  config,
  lib,
  helpers,
  pkgs,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "dressing";
  originalName = "dressing.nvim";
  defaultPackage = pkgs.vimPlugins.dressing-nvim;

  maintainers = [ helpers.maintainers.AndresBermeoMarinelli ];

  settingsOptions =
    let
      intOrRatio = with types; either ints.unsigned (numbers.between 0.0 1.0);
    in
    {
      input = {
        enabled = helpers.defaultNullOpts.mkBool true ''
          Enable the `vim.ui.input` implementation.
        '';

        default_prompt = helpers.defaultNullOpts.mkStr "Input" ''
          Default prompt string for `vim.ui.input`.
        '';

        trim_prompt = helpers.defaultNullOpts.mkBool true ''
          Trim trailing `:` from prompt.
        '';

        title_pos =
          helpers.defaultNullOpts.mkEnumFirstDefault
            [
              "left"
              "right"
              "center"
            ]
            ''
              Position of title.
            '';

        insert_only = helpers.defaultNullOpts.mkBool true ''
          When true, `<Esc>` will close the modal.
        '';

        start_in_insert = helpers.defaultNullOpts.mkBool true ''
          When true, input will start in insert mode.
        '';

        border = helpers.defaultNullOpts.mkBorder "rounded" "the input window" "";

        relative =
          helpers.defaultNullOpts.mkEnumFirstDefault
            [
              "cursor"
              "win"
              "editor"
            ]
            ''
              Affects the dimensions of the window with respect to this setting.
              If 'editor' or 'win', will default to being centered.
            '';

        prefer_width = helpers.defaultNullOpts.mkNullable intOrRatio "40" ''
          Can be an integer or a float between 0 and 1 (e.g. 0.4 for 40%).
        '';

        width = helpers.defaultNullOpts.mkNullable intOrRatio null ''
          Can be an integer or a float between 0 and 1 (e.g. 0.4 for 40%).
        '';

        max_width =
          helpers.defaultNullOpts.mkNullable (with types; either intOrRatio (listOf intOrRatio)) "[140 0.9]"
            ''
              Max width of window.

              Can be a list of mixed types, e.g. `[140 0.9]` means "less than 140 columns or 90% of
              total."
            '';

        min_width =
          helpers.defaultNullOpts.mkNullable (with types; either intOrRatio (listOf intOrRatio)) "[20 0.2]"
            ''
              Min width of window.

              Can be a list of mixed types, e.g. `[140 0.9]` means "less than 140 columns or 90% of
              total."
            '';

        buf_options = helpers.defaultNullOpts.mkAttrsOf types.anything "{}" ''
          An attribute set of neovim buffer options.
        '';

        win_options = helpers.defaultNullOpts.mkAttrsOf types.anything ''
          {
            wrap = false;
            list = true;
            listchars = "precedes:...,extends:...";
            sidescrolloff = 0;
          }
        '' "An attribute set of window options.";

        mappings =
          helpers.defaultNullOpts.mkAttrsOf (with types; attrsOf (either str (enum [ false ])))
            ''
              {
                n = {
                  "<Esc>" = "Close";
                  "<CR>" = "Confirm";
                };
                i = {
                  "<C-c>" = "Close";
                  "<CR>" = "Confirm";
                  "<Up>" = "HistoryPrev";
                  "<Down>" = "HistoryNext";
                };
              }
            ''
            ''
              Mappings for defined modes.

              To disable a default mapping in a specific mode, set it to `false`.
            '';

        override = helpers.defaultNullOpts.mkLuaFn "function(conf) return conf end" ''
          Lua function that takes config that is passed to nvim_open_win.
          Used to customize the layout.
        '';

        get_config = helpers.defaultNullOpts.mkLuaFn null ''
          This can be a function that accepts the opts parameter that is passed in to 'vim.select'
          or 'vim.input'. It must return either nil or config values to use in place of the global
          config values for that module.

          See `:h dressing_get_config` for more info.
        '';
      };

      select = {
        enabled = helpers.defaultNullOpts.mkBool true ''
          Enable the vim.ui.select implementation.
        '';

        backend = helpers.defaultNullOpts.mkListOf types.str ''
          ["telescope" "fzf_lua" "fzf" "builtin" "nui"]
        '' "Priority list of preferred vim.select implementations. ";

        trim_prompt = helpers.defaultNullOpts.mkBool true ''
          Trim trailing `:` from prompt.
        '';

        telescope =
          helpers.defaultNullOpts.mkNullable (with helpers.nixvimTypes; either strLua (attrsOf anything)) null
            ''
              Options for telescope selector.

              Can be a raw lua string like:

              `telescope = \'\'require("telescope.themes").get_ivy({})\'\'`

              or an attribute set of telescope settings.
            '';

        fzf = {
          window = helpers.defaultNullOpts.mkAttrsOf types.anything ''
            {
              width = 0.5;
              height = 0.4;
            }
          '' "Window options for fzf selector. ";
        };

        fzf_lua = helpers.defaultNullOpts.mkAttrsOf types.anything "{}" ''
          Options for fzf-lua selector.
        '';

        nui = helpers.defaultNullOpts.mkAttrsOf types.anything ''
          {
            position = "50%";
            size = null;
            relative = "editor";
            border = {
              style = "rounded";
            };
            buf_options = {
              swapfile = false;
              filetype = "DressingSelect";
            };
            win_options = {
              winblend = 0;
            };
            max_width = 80;
            max_height = 40;
            min_width = 40;
            min_height = 10;
          }
        '' "Options for nui selector. ";

        builtin = {
          show_numbers = helpers.defaultNullOpts.mkBool true ''
            Display numbers for options and set up keymaps.
          '';

          border = helpers.defaultNullOpts.mkBorder "rounded" "the select window" "";

          relative =
            helpers.defaultNullOpts.mkEnumFirstDefault
              [
                "editor"
                "win"
                "cursor"
              ]
              ''
                Affects the dimensions of the window with respect to this setting.
                If 'editor' or 'win', will default to being centered.
              '';

          buf_options = helpers.defaultNullOpts.mkAttrsOf types.anything "{}" ''
            An attribute set of buffer options.
          '';

          win_options = helpers.defaultNullOpts.mkAttrsOf types.anything ''
            {
              cursorline = true;
              cursorlineopt = "both";
            }
          '' "An attribute set of window options.";

          width = helpers.defaultNullOpts.mkNullable intOrRatio null ''
            Can be an integer or a float between 0 and 1 (e.g. 0.4 for 40%).
          '';

          max_width =
            helpers.defaultNullOpts.mkNullable (with types; either intOrRatio (listOf intOrRatio)) "[140 0.8]"
              ''
                Max width of window.

                Can be a list of mixed types, e.g. `[140 0.8]` means "less than 140 columns or 80%
                of total."
              '';

          min_width =
            helpers.defaultNullOpts.mkNullable (with types; either intOrRatio (listOf intOrRatio)) "[40 0.2]"
              ''
                Min width of window.

                Can be a list of mixed types, e.g. `[40 0.2]` means "less than 40 columns or 20%
                of total."
              '';

          height = helpers.defaultNullOpts.mkNullable intOrRatio null ''
            Can be an integer or a float between 0 and 1 (e.g. 0.4 for 40%).
          '';

          max_height =
            helpers.defaultNullOpts.mkNullable (with types; either intOrRatio (listOf intOrRatio)) "0.9"
              ''
                Max height of window.

                Can be a list of mixed types, e.g. `[140 0.8]` means "less than 140 rows or 80%
                of total."
              '';

          min_height =
            helpers.defaultNullOpts.mkNullable (with types; either intOrRatio (listOf intOrRatio)) "[10 0.2]"
              ''
                Min height of window.

                Can be a list of mixed types, e.g. `[10 0.2]` means "less than 10 rows or 20%
                of total."
              '';

          mappings =
            helpers.defaultNullOpts.mkAttrsOf (with types; either str (enum [ false ]))
              ''
                {
                  "<Esc>" = "Close";
                  "<C-c>" = "Close";
                  "<CR>" = "Confirm";
                }
              ''
              ''
                Mappings in normal mode for the builtin selector.

                To disable a default mapping in a specific mode, set it to `false`.
              '';

          override = helpers.defaultNullOpts.mkLuaFn "function(conf) return conf end" ''
            Lua function that takes config that is passed to nvim_open_win.
            Used to customize the layout.
          '';
        };

        format_item_override = helpers.defaultNullOpts.mkAttrsOf helpers.nixvimTypes.strLuaFn "{}" ''
          Override the formatting/display for a specific "kind" when using vim.ui.select.
          For example, code actions from vim.lsp.buf.code_action use a kind="codeaction".
          You can override the format function when selecting for that kind, e.g.

          ```nix
          {
            codeaction = \'\'
              function(action_tuple)
                local title = action_tuple[2].title:gsub("\r\n", "\\r\\n")
                local client = vim.lsp.get_client_by_id(action_tuple[1])
                return string.format("%s\t[%s]", title:gsub("\n", "\\n"), client.name)
              end
             \'\';
          }
          ```
        '';

        get_config = helpers.defaultNullOpts.mkLuaFn null ''
          This can be a function that accepts the opts parameter that is passed in to 'vim.select'
          or 'vim.input'. It must return either nil or config values to use in place of the global
          config values for that module.

          See `:h dressing_get_config` for more info.
        '';
      };
    };

  settingsExample = {
    input = {
      enabled = true;
      mappings = {
        n = {
          "<Esc>" = "Close";
          "<CR>" = "Confirm";
        };
        i = {
          "<C-c>" = "Close";
          "<CR>" = "Confirm";
          "<Up>" = "HistoryPrev";
          "<Down>" = "HistoryNext";
        };
      };
    };
    select = {
      enabled = true;
      backend = [
        "telescope"
        "fzf_lua"
        "fzf"
        "builtin"
        "nui"
      ];
      builtin = {
        mappings = {
          "<Esc>" = "Close";
          "<C-c>" = "Close";
          "<CR>" = "Confirm";
        };
      };
    };
  };
}
