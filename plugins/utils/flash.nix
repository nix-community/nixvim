{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.flash;
in
{
  options.plugins.flash =
    let
      configOpts = {
        labels = helpers.defaultNullOpts.mkStr "asdfghjklqwertyuiopzxcvbnm" ''
          Labels appear next to the matches, allowing you to quickly jump to any location. Labels are
          guaranteed not to exist as a continuation of the search pattern.
        '';

        search = {
          automatic = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Automatically set the values according to context. Same as passing `search = {}` in lua
            '';
          };

          multiWindow = helpers.defaultNullOpts.mkBool true "search/jump in all windows";

          forward = helpers.defaultNullOpts.mkBool true "search direction";

          wrap = helpers.defaultNullOpts.mkBool true ''
            when `false`, find only matches in the given direction
          '';

          mode =
            helpers.defaultNullOpts.mkEnumFirstDefault
              [
                "exact"
                "search"
                "fuzzy"
              ]
              ''
                - exact: exact match
                - search: regular search
                - fuzzy: fuzzy search
                - fun(str): custom search function that returns a pattern
                  For example, to only match at the beginning of a word:
                  function(str)
                    return "\\<" .. str
                  end
              '';

          incremental = helpers.defaultNullOpts.mkBool false "behave like `incsearch`";

          exclude =
            helpers.defaultNullOpts.mkListOf types.str
              [
                "notify"
                "cmp_menu"
                "noice"
                "flash_prompt"
                {
                  __raw = ''
                    function(win)
                      return not vim.api.nvim_win_get_config(win).focusable
                    end
                  '';
                }
              ]
              ''
                Excluded filetypes and custom window filters
              '';

          trigger = helpers.defaultNullOpts.mkStr "" ''
            Optional trigger character that needs to be typed before a jump label can be used.
            It's NOT recommended to set this, unless you know what you're doing
          '';

          maxLength =
            helpers.defaultNullOpts.mkNullable (with types; either (enum [ false ]) types.int) false
              ''
                max pattern length. If the pattern length is equal to this labels will no longer be
                skipped. When it exceeds this length it will either end in a jump or terminate the search
              '';
        };

        jump = {
          jumplist = helpers.defaultNullOpts.mkBool true "save location in the jumplist";

          pos = helpers.defaultNullOpts.mkEnumFirstDefault [
            "start"
            "end"
            "range"
          ] "jump position";

          history = helpers.defaultNullOpts.mkBool false "add pattern to search history";

          register = helpers.defaultNullOpts.mkBool false "add pattern to search register";

          nohlsearch = helpers.defaultNullOpts.mkBool false "clear highlight after jump";

          autojump = helpers.defaultNullOpts.mkBool false ''
            automatically jump when there is only one match
          '';

          inclusive = helpers.mkNullOrOption types.bool ''
            You can force inclusive/exclusive jumps by setting the `inclusive` option. By default it
            will be automatically set based on the mode.
          '';

          offset = helpers.mkNullOrOption types.int ''
            jump position offset. Not used for range jumps.
              0: default
              1: when pos == "end" and pos < current position
          '';
        };

        label = {
          uppercase = helpers.defaultNullOpts.mkBool true "allow uppercase labels";

          exclude = helpers.defaultNullOpts.mkStr "" ''
            add any labels with the correct case here, that you want to exclude
          '';

          current = helpers.defaultNullOpts.mkBool true ''
            add a label for the first match in the current window.
            you can always jump to the first match with `<CR>`
          '';

          after = helpers.defaultNullOpts.mkNullable (with types; either bool (listOf int)) true ''
            show the label after the match
          '';

          before = helpers.defaultNullOpts.mkNullable (with types; either bool (listOf int)) false ''
            show the label before the match
          '';

          style =
            helpers.defaultNullOpts.mkEnum
              [
                "eol"
                "overlay"
                "right_align"
                "inline"
              ]
              "overlay"
              ''
                position of the label extmark
              '';

          reuse =
            helpers.defaultNullOpts.mkEnumFirstDefault
              [
                "lowercase"
                "all"
                "none"
              ]
              ''
                flash tries to re-use labels that were already assigned to a position,
                when typing more characters. By default only lower-case labels are re-used.
              '';

          distance = helpers.defaultNullOpts.mkBool true ''
            for the current window, label targets closer to the cursor first
          '';

          minPatternLength = helpers.defaultNullOpts.mkInt 0 ''
            minimum pattern length to show labels
            Ignored for custom labelers.
          '';

          rainbow = {
            enabled = helpers.defaultNullOpts.mkBool false ''
              Enable this to use rainbow colors to highlight labels
              Can be useful for visualizing Treesitter ranges.
            '';

            shade = helpers.defaultNullOpts.mkNullable (types.ints.between 1 9) 5 "";
          };

          format =
            helpers.defaultNullOpts.mkLuaFn
              ''
                format = function(opts)
                  return { { opts.match.label, opts.hl_group } }
                end
              ''
              ''
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
          backdrop = helpers.defaultNullOpts.mkBool true "show a backdrop with hl FlashBackdrop";

          matches = helpers.defaultNullOpts.mkBool true "Highlight the search matches";

          priority = helpers.defaultNullOpts.mkPositiveInt 5000 "extmark priority";

          groups = builtins.mapAttrs (_: default: helpers.defaultNullOpts.mkStr default "") {
            match = "FlashMatch";
            current = "FlashCurrent";
            backdrop = "FlashBackdrop";
            label = "FlashLabel";
          };
        };

        action = helpers.defaultNullOpts.mkLuaFn "nil" ''
          action to perform when picking a label.
          defaults to the jumping logic depending on the mode.
          @type fun(match:Flash.Match, state:Flash.State)
        '';

        pattern = helpers.defaultNullOpts.mkStr "" "initial pattern to use when opening flash";

        continue = helpers.defaultNullOpts.mkBool false ''
          When `true`, flash will try to continue the last search
        '';

        config = helpers.defaultNullOpts.mkLuaFn "nil" ''
          Set config to a function to dynamically change the config
          @type fun(opts:Flash.Config)
        '';

        prompt = {
          enabled = helpers.defaultNullOpts.mkBool true ''
            options for the floating window that shows the prompt, for regular jumps
          '';

          # Not sure what is the type...
          prefix = helpers.defaultNullOpts.mkListOf types.anything [
            [
              "⚡"
              "FlashPromptIcon"
            ]
          ] "";
          winConfig = helpers.defaultNullOpts.mkAttrsOf types.anything {
            relative = "editor";
            width = 1;
            height = 1;
            row = -1;
            col = 0;
            zindex = 1000;
          } "See nvim_open_win for more details";
        };

        remoteOp = {
          restore = helpers.defaultNullOpts.mkBool false ''
            restore window views and cursor position after doing a remote operation
          '';

          motion = helpers.defaultNullOpts.mkBool false ''
            For `jump.pos = "range"`, this setting is ignored.
            - `true`: always enter a new motion when doing a remote operation
            - `false`: use the window's cursor position and jump target
            - `nil`: act as `true` for remote windows, `false` for the current window
          '';
        };
      };
    in
    helpers.neovim-plugin.extraOptionsOptions
    // {
      enable = mkEnableOption "flash.nvim";

      package = helpers.mkPluginPackageOption "flash.nvim" pkgs.vimPlugins.flash-nvim;

      modes =
        let
          mkModeConfig =
            {
              extra ? { },
              default,
              description ? "",
            }:
            helpers.defaultNullOpts.mkNullable (types.submodule {
              options = configOpts // extra;
            }) default description;
        in
        {
          search = mkModeConfig {
            description = ''
              options used when flash is activated through a regular search with `/` or `?`
            '';
            extra = {
              enabled = helpers.defaultNullOpts.mkBool true ''
                when `true`, flash will be activated during regular search by default.
                You can always toggle when searching with `require("flash").toggle()`
              '';
            };
            default = {
              enabled = true;
              highlight = {
                backdrop = false;
              };
              jump = {
                history = true;
                register = true;
                nohlsearch = true;
              };
              /*
                forward will be automatically set to the search direction
                mode is always set to 'search'
                incremental is set to 'true' when 'incsearch' is enabled
              */
              search.automatic = true;
            };
          };
          char = mkModeConfig {
            description = "options used when flash is activated through a regular search with `/` or `?`";
            extra = {
              enabled = helpers.defaultNullOpts.mkBool true "";

              autohide = helpers.defaultNullOpts.mkBool false ''
                hide after jump when not using jump labels
              '';

              jumpLabels = helpers.defaultNullOpts.mkBool false "show jump labels";

              multiLine = helpers.defaultNullOpts.mkBool true ''
                set to `false` to use the current line only
              '';

              keys =
                helpers.defaultNullOpts.mkAttrsOf types.str
                  # FIXME can't show helper func in docs
                  (helpers.listToUnkeyedAttrs [
                    "f"
                    "F"
                    "t"
                    "T"
                    ";"
                    ","
                  ])
                  ''
                    by default all keymaps are enabled, but you can disable some of them,
                    by removing them from the list.
                    If you rather use another key, you can map them
                    to something else, e.g., `{ ";" = "L"; "," = "H"; }`
                  '';

              charActions =
                helpers.defaultNullOpts.mkLuaFn
                  ''
                    function(motion)
                      return {
                        [";"] = "next", -- set to right to always go right
                        [","] = "prev", -- set to left to always go left
                        -- clever-f style
                        [motion:lower()] = "next",
                        [motion:upper()] = "prev",
                        -- jump2d style: same case goes next, opposite case goes prev
                        -- [motion] = "next",
                        -- [motion:match("%l") and motion:upper() or motion:lower()] = "prev",
                      }
                    end
                  ''
                  ''
                    The direction for `prev` and `next` is determined by the motion.
                    `left` and `right` are always left and right.
                  '';
            };
            default = {
              enabled = true;
              # dynamic configuration for ftFT motions
              config = ''
                function(opts)
                  -- autohide flash when in operator-pending mode
                  opts.autohide = vim.fn.mode(true):find("no") and vim.v.operator == "y"

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
              jumpLabels = false;
              multiLine = false;
              label = {
                exclude = "hjkliardc";
              };
              # FIXME can't show the function call in the docs...
              keys = helpers.listToUnkeyedAttrs [
                "f"
                "F"
                "t"
                "T"
                ";"
                ","
              ];
              charActions = ''
                function(motion)
                  return {
                    [";"] = "next", -- set to right to always go right
                    [","] = "prev", -- set to left to always go left
                    -- clever-f style
                    [motion:lower()] = "next",
                    [motion:upper()] = "prev",
                    -- jump2d style: same case goes next, opposite case goes prev
                    -- [motion] = "next",
                    -- [motion:match("%l") and motion:upper() or motion:lower()] = "prev",
                  }
                end
              '';
              search = {
                wrap = false;
              };
              highlight = {
                backdrop = true;
              };
              jump = {
                register = false;
              };
            };
          };
          treesitter = mkModeConfig {
            description = ''
              options used for treesitter selections `require("flash").treesitter()`
            '';
            default = {
              labels = "abcdefghijklmnopqrstuvwxyz";
              jump = {
                pos = "range";
              };
              search = {
                incremental = false;
              };
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
          treesitterSearch = mkModeConfig {
            default = {
              jump = {
                pos = "range";
              };
              search = {
                multiWindow = true;
                wrap = true;
                incremental = false;
              };
              remoteOp = {
                restore = true;
              };
              label = {
                before = true;
                after = true;
                style = "inline";
              };
            };
          };
          remote = mkModeConfig {
            default = {
              remoteOp = {
                restore = true;
                motion = true;
              };
            };
            description = "options used for remote flash";
          };
        };
    }
    // configOpts;

  config =
    let
      mkGlobalConfig = c: {
        inherit (c) labels;
        search =
          if c.search.automatic then
            helpers.emptyTable
          else
            {
              multi_window = c.search.multiWindow;
              inherit (c.search)
                forward
                wrap
                mode
                incremental
                exclude
                trigger
                ;
              max_length = c.search.maxLength;
            };
        jump = {
          inherit (c.jump)
            jumplist
            pos
            history
            register
            nohlsearch
            autojump
            inclusive
            offset
            ;
        };
        label = {
          inherit (c.label)
            uppercase
            exclude
            current
            after
            before
            style
            reuse
            distance
            ;
          min_pattern_length = c.label.minPatternLength;
          rainbow = {
            inherit (c.label.rainbow) enabled shade;
          };
          inherit (c.label) format;
        };
        highlight = {
          inherit (c.highlight)
            backdrop
            matches
            priority
            groups
            ;
        };
        inherit (c)
          action
          pattern
          continue
          config
          ;
        prompt = {
          inherit (c.prompt) enabled prefix;
          win_config = c.prompt.winConfig;
        };
        remote_op = {
          inherit (c.remoteOp) restore motion;
        };
      };

      options =
        (mkGlobalConfig cfg)
        // {
          modes =
            let
              mkModeConfig = c: extra: helpers.ifNonNull' c ((mkGlobalConfig c) // (extra c));
            in
            {
              search = mkModeConfig cfg.modes.search (c: {
                inherit (c) enabled;
              });
              char = mkModeConfig cfg.modes.char (c: {
                inherit (c) enabled autohide;
                jump_labels = c.jumpLabels;
                multi_line = c.multiLine;
                inherit (c) keys charActions;
              });
              treesitter = mkModeConfig cfg.modes.treesitter (c: { });
              treesitter_search = mkModeConfig cfg.modes.treesitterSearch (c: { });
              remote = mkModeConfig cfg.modes.remote (c: { });
            };
        }
        // cfg.extraOptions;
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      extraConfigLua = ''
        require('flash').setup(${helpers.toLuaObject options})
      '';
    };
}
