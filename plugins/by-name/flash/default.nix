{
  lib,
  helpers,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "flash";
  package = "flash-nvim";
  description = "`flash.nvim` lets you navigate your code with search labels, enhanced character motions, and Treesitter integration.";

  maintainers = with maintainers; [
    traxys
    MattSturgeon
  ];

  imports = [
    # TODO: check automatic search config still works
    (mkRemovedOptionModule [
      "plugins"
      "flash"
      "search"
      "automatic"
    ] "You can configure `plugins.flash.settings.modes.search.search.*` directly.")
  ];

  settingsOptions =
    let
      # Default values used for the top-level settings options,
      # also used as secondary defaults for mode options.
      configDefaults = {
        labels = "asdfghjklqwertyuiopzxcvbnm";
        search = {
          multi_window = true;
          forward = true;
          wrap = true;
          mode = "exact";
          incremental = false;
          exclude = [
            "notify"
            "cmp_menu"
            "noice"
            "flash_prompt"
            (helpers.mkRaw ''
              function(win)
                -- exclude non-focusable windows
                return not vim.api.nvim_win_get_config(win).focusable
              end
            '')
          ];
          trigger = "";
          max_length = false;
        };
        jump = {
          jumplist = true;
          pos = "start";
          history = false;
          register = false;
          nohlsearch = false;
          autojump = false;
          inclusive = null;
          offset = null;
        };
        label = {
          uppercase = true;
          exclude = "";
          current = true;
          after = true;
          before = false;
          style = "overlay";
          reuse = "lowercase";
          distance = true;
          min_pattern_length = 0;
          rainbow = {
            enabled = false;
            shade = 5;
          };
          format = ''
            function(opts)
              return { { opts.match.label, opts.hl_group } }
            end
          '';
        };
        highlight = {
          backdrop = true;
          matches = true;
          priority = 5000;
          groups = {
            match = "FlashMatch";
            current = "FlashCurrent";
            backdrop = "FlashBackdrop";
            label = "FlashLabel";
          };
        };
        action = null;
        pattern = "";
        continue = false;
        config = null;
        prompt = {
          enabled = true;
          prefix = [
            [
              "⚡"
              "FlashPromptIcon"
            ]
          ];
          win_config = {
            relative = "editor";
            width = 1;
            height = 1;
            row = -1;
            col = 0;
            zindex = 1000;
          };
        };
        remote_op = {
          restore = false;
          motion = false;
        };
      };

      # Shared config options, used by the top-level settings, as well as modes.
      # Each usage has different default values.
      configOpts =
        defaultOverrides:
        let
          defaults = recursiveUpdate configDefaults defaultOverrides;
        in
        {
          labels = helpers.defaultNullOpts.mkStr defaults.labels ''
            Labels appear next to the matches, allowing you to quickly jump to any location. Labels are
            guaranteed not to exist as a continuation of the search pattern.
          '';

          search = {
            multi_window = helpers.defaultNullOpts.mkBool defaults.search.multi_window ''
              Search/jump in all windows
            '';

            forward = helpers.defaultNullOpts.mkBool defaults.search.forward ''
              Search direction
            '';

            wrap = helpers.defaultNullOpts.mkBool defaults.search.wrap ''
              Continue searching after reaching the start/end of the file.
              When `false`, find only matches in the given direction
            '';

            mode =
              helpers.defaultNullOpts.mkEnum
                [
                  "exact"
                  "search"
                  "fuzzy"
                ]
                defaults.search.mode
                ''
                  Each mode will take `ignorecase` and `smartcase` into account.
                  - `exact`: exact match
                  - `search`: regular search
                  - `fuzzy`: fuzzy search
                  - `__raw` fun(str): custom search function that returns a pattern

                  For example, to only match at the beginning of a word:
                  ```lua
                    function(str)
                      return "\\<" .. str
                    end
                  ```
                '';

            incremental = helpers.defaultNullOpts.mkBool defaults.search.incremental ''
              Behave like `incsearch`.
            '';

            exclude = helpers.defaultNullOpts.mkListOf types.str defaults.search.exclude ''
              Excluded filetypes and custom window filters.
            '';

            trigger = helpers.defaultNullOpts.mkStr defaults.search.trigger ''
              Optional trigger character that needs to be typed before a jump label can be used.
              It's NOT recommended to set this, unless you know what you're doing.
            '';

            max_length =
              helpers.defaultNullOpts.mkNullable (with types; either (enum [ false ]) int)
                defaults.search.max_length
                ''
                  Max pattern length. If the pattern length is equal to this labels will no longer be skipped.
                  When it exceeds this length it will either end in a jump or terminate the search.
                '';
          };

          jump = {
            jumplist = helpers.defaultNullOpts.mkBool defaults.jump.jumplist ''
              Save location in the jumplist.
            '';

            pos =
              helpers.defaultNullOpts.mkEnum
                [
                  "start"
                  "end"
                  "range"
                ]
                defaults.jump.pos
                ''
                  Jump position
                '';

            history = helpers.defaultNullOpts.mkBool defaults.jump.history ''
              Add pattern to search history.
            '';

            register = helpers.defaultNullOpts.mkBool defaults.jump.register ''
              Add pattern to search register.
            '';

            nohlsearch = helpers.defaultNullOpts.mkBool defaults.jump.nohlsearch ''
              Clear highlight after jump
            '';

            autojump = helpers.defaultNullOpts.mkBool defaults.jump.autojump ''
              Automatically jump when there is only one match
            '';

            inclusive = helpers.defaultNullOpts.mkBool defaults.jump.inclusive ''
              You can force inclusive/exclusive jumps by setting the `inclusive` option. By default it
              will be automatically set based on the mode.
            '';

            offset = helpers.defaultNullOpts.mkInt defaults.jump.offset ''
              jump position offset. Not used for range jumps.
                0: default
                1: when pos == "end" and pos < current position
            '';
          };

          label = {
            uppercase = helpers.defaultNullOpts.mkBool defaults.label.uppercase ''
              Allow uppercase labels.
            '';

            exclude = helpers.defaultNullOpts.mkStr defaults.label.exclude ''
              add any labels with the correct case here, that you want to exclude
            '';

            current = helpers.defaultNullOpts.mkBool true ''
              Add a label for the first match in the current window.
              You can always jump to the first match with `<CR>`
            '';

            after =
              helpers.defaultNullOpts.mkNullableWithRaw (with types; either bool (listOf int))
                defaults.label.after
                ''
                  Show the label after the match
                '';

            before =
              helpers.defaultNullOpts.mkNullableWithRaw (with types; either bool (listOf int))
                defaults.label.before
                ''
                  Show the label before the match
                '';

            style =
              helpers.defaultNullOpts.mkEnum
                [
                  "eol"
                  "overlay"
                  "right_align"
                  "inline"
                ]
                defaults.label.style
                ''
                  position of the label extmark
                '';

            reuse =
              helpers.defaultNullOpts.mkEnum
                [
                  "lowercase"
                  "all"
                  "none"
                ]
                defaults.label.reuse
                ''
                  flash tries to re-use labels that were already assigned to a position,
                  when typing more characters. By default only lower-case labels are re-used.
                '';

            distance = helpers.defaultNullOpts.mkBool defaults.label.distance ''
              for the current window, label targets closer to the cursor first
            '';

            min_pattern_length = helpers.defaultNullOpts.mkInt defaults.label.min_pattern_length ''
              minimum pattrn length to show labels
              Ignored for custom labelers.
            '';

            rainbow = {
              enabled = helpers.defaultNullOpts.mkBool defaults.label.rainbow.enabled ''
                Enable this to use rainbow colors to highlight labels
                Can be useful for visualizing Treesitter ranges.
              '';

              shade = helpers.defaultNullOpts.mkNullable (types.ints.between 1 9) defaults.label.rainbow.shade "";
            };

            format = helpers.defaultNullOpts.mkLuaFn defaults.label.format ''
              With `format`, you can change how the label is rendered.
              Should return a list of `[text, highlight]` tuples.

              @class Flash.Format
              @field state Flash.State
              @field match Flash.Match
              @field hl_group string
              @field after boolean
              @type fun(opts:Flash.Format): string[][]
            '';
          };

          highlight = {
            backdrop = helpers.defaultNullOpts.mkBool defaults.highlight.backdrop ''
              Show a backdrop with hl FlashBackdrop.
            '';

            matches = helpers.defaultNullOpts.mkBool defaults.highlight.matches ''
              Highlight the search matches.
            '';

            priority = helpers.defaultNullOpts.mkPositiveInt defaults.highlight.priority ''
              Extmark priority.
            '';

            groups = mapAttrs (name: helpers.defaultNullOpts.mkStr defaults.highlight.groups.${name}) {
              # opt = description
              match = "FlashMatch";
              current = "FlashCurrent";
              backdrop = "FlashBackdrop";
              label = "FlashLabel";
            };
          };

          action = helpers.defaultNullOpts.mkLuaFn defaults.action ''
            action to perform when picking a label.
            defaults to the jumping logic depending on the mode.

            @type fun(match:Flash.Match, state:Flash.State)
          '';

          pattern = helpers.defaultNullOpts.mkStr defaults.pattern ''
            Initial pattern to use when opening flash.
          '';

          continue = helpers.defaultNullOpts.mkBool defaults.continue ''
            When `true`, flash will try to continue the last search.
          '';

          config = helpers.defaultNullOpts.mkLuaFn defaults.config ''
            Set config to a function to dynamically change the config.

            @type fun(opts:Flash.Config)
          '';

          prompt = {
            enabled = helpers.defaultNullOpts.mkBool defaults.prompt.enabled ''
              Options for the floating window that shows the prompt, for regular jumps.
            '';

            # Not sure what the type is...
            # Think it's listOf (maybeRaw (listOf (maybeRaw str)))?
            prefix = helpers.defaultNullOpts.mkListOf types.anything defaults.prompt.prefix "";

            win_config = helpers.defaultNullOpts.mkAttrsOf types.anything defaults.prompt.win_config ''
              See `:h nvim_open_win` for more details.
            '';
          };

          remote_op = {
            restore = helpers.defaultNullOpts.mkBool defaults.remote_op.restore ''
              Restore window views and cursor position after doing a remote operation.
            '';

            motion = helpers.defaultNullOpts.mkBool defaults.remote_op.motion ''
              For `jump.pos = "range"`, this setting is ignored.
              - `true`: always enter a new motion when doing a remote operation
              - `false`: use the window's cursor position and jump target
              - `nil`: act as `true` for remote windows, `false` for the current window
            '';
          };
        };

      # The `mode`s have all the same options as top-level settings,
      # but with different defaults and some additional options.
      mkModeConfig =
        {
          defaults ? { },
          options ? { },
          ...
        }@args:
        # FIXME: use mkNullableWithRaw when #1618 is fixed
        helpers.defaultNullOpts.mkNullable' (
          (removeAttrs args [
            "options"
            "defaults"
          ])
          // {
            type =
              with types;
              submodule {
                freeformType = attrsOf anything;
                options = recursiveUpdate (configOpts defaults) options;
              };
          }
        );
    in
    (configOpts { })
    // {
      modes = {
        search = mkModeConfig rec {
          description = ''
            Options used when flash is activated through a regular search,
            e.g. with `/` or `?`.
          '';
          defaults = {
            enabled = false;
            highlight = {
              backdrop = false;
            };
            jump = {
              history = true;
              register = true;
              nohlsearch = true;
            };
            search = {
              forward.__raw = "vim.fn.getcmdtype() == '/'";
              mode = "search";
              incremental.__raw = "vim.go.incsearch";
            };
          };
          options = {
            enabled = helpers.defaultNullOpts.mkBool defaults.enabled ''
              When `true`, flash will be activated during regular search by default.
              You can always toggle when searching with `require("flash").toggle()`
            '';
          };
        };
        char = mkModeConfig rec {
          description = ''
            Options used when flash is activated through
            `f`, `F`, `t`, `T`, `;` and `,` motions.
          '';
          defaults = {
            enabled = true;
            config = ''
              -- dynamic configuration for ftFT motions
              function(opts)
                -- autohide flash when in operator-pending mode
                opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")

                -- disable jump labels when not enabled, when using a count,
                -- or when recording/executing registers
                opts.jump_labels = opts.jump_labels
                  and vim.v.count == 0
                  and vim.fn.reg_executing() == ""
                  and vim.fn.reg_recording() == ""

                -- Show jump labels only in operator-pending mode
                -- opts.jump_labels = vim.v.count == 0 and vim.fn.mode(true):find("o")
              end
            '';
            autohide = false;
            jump_labels = false;
            multi_line = true;
            label = {
              exclude = "hjkliardc";
            };
            keys = helpers.listToUnkeyedAttrs (lib.stringToCharacters "fFtT;,");
            char_actions = ''
              function(motion)
                return {
                  [";"] = "next", -- set to `right` to always go right
                  [","] = "prev", -- set to `left` to always go left
                  -- clever-f style
                  [motion:lower()] = "next",
                  [motion:upper()] = "prev",
                  -- jump2d style: same case goes next, opposite case goes prev
                  -- [motion] = "next",
                  -- [motion:match("%l") and motion:upper() or motion:lower()] = "prev",
                }
              end
            '';
            search.wrap = false;
            highlight.backdrop = true;
            jump.register = false;
          };
          options = {
            enabled = helpers.defaultNullOpts.mkBool defaults.enabled "";

            autohide = helpers.defaultNullOpts.mkBool defaults.autohide ''
              Hide after jump when not using jump labels.
            '';

            jump_labels = helpers.defaultNullOpts.mkBool defaults.jump_labels ''
              Show jump labels.
            '';

            multi_line = helpers.defaultNullOpts.mkBool defaults.multi_line ''
              Set to `false` to use the current line only.
            '';

            keys = helpers.defaultNullOpts.mkAttrsOf' {
              type = types.str;
              pluginDefault = defaults.keys;
              description = ''
                By default all keymaps are enabled, but you can disable some of them,
                by removing them from the list.

                If you rather use another key, you can map them to something else.
              '';
              example = {
                ";" = "L";
                "," = "H";
              };
            };

            char_actions = helpers.defaultNullOpts.mkLuaFn defaults.char_actions ''
              The direction for `prev` and `next` is determined by the motion.
              `left` and `right` are always left and right.
            '';
          };
        };
        treesitter = mkModeConfig {
          description = ''
            Options used for treesitter selections in `require("flash").treesitter()`.
          '';
          defaults = {
            labels = "abcdefghijklmnopqrstuvwxyz";
            jump.pos = "range";
            search.incremental = false;
            label = {
              before = true;
              after = true;
              style = "inline";
            };
            highlight = {
              backdrop = false;
              matches = false;
            };
          };
        };
        treesitter_search = mkModeConfig {
          description = ''
            Options used when flash is activated through `require("flash").treesitter_search()`.
          '';
          defaults = {
            jump.pos = "range";
            search = {
              multi_window = true;
              wrap = true;
              incremental = false;
            };
            remote_op.restore = true;
            label = {
              before = true;
              after = true;
              style = "inline";
            };
          };
        };
        remote = mkModeConfig {
          description = "Options used for remote flash.";
          defaults = {
            remote_op = {
              restore = true;
              motion = true;
            };
          };
        };
      };
    };
}
