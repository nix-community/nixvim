{ config
, lib
, pkgs
, helpers
, ...
}:
with lib; let
  signOptions = defaults:
    with types; {
      hl = mkOption {
        type = str;
        description = "Specifies the highlight group to use for the sign";
        default = defaults.hl;
      };
      text = mkOption {
        type = str;
        description = "Specifies the character to use for the sign";
        default = defaults.text;
      };
      numhl = mkOption {
        type = str;
        description = "Specifies the highlight group to use for the number column";
        default = defaults.numhl;
      };
      linehl = mkOption {
        type = str;
        description = "Specifies the highlight group to use for the line";
        default = defaults.linehl;
      };
      showCount = mkEnableOption "showing count of hunk, e.g. number of deleted lines";
    };
  signSetupOptions = values: {
    inherit (values) hl text numhl linehl;
    show_count = values.showCount;
  };

  luaFunction = types.submodule {
    options.function = mkOption {
      type = types.str;
      description = "Lua function definition";
    };
  };
in
{
  options.plugins.gitsigns = {
    enable = mkEnableOption "Enable gitsigns plugin";
    package = mkOption {
      type = types.package;
      default = pkgs.vimPlugins.gitsigns-nvim;
      description = "Plugin to use for gitsigns";
    };
    signs = {
      add = signOptions {
        hl = "GitSignsAdd";
        text = "┃";
        numhl = "GitSignsAddNr";
        linehl = "GitSignsAddLn";
      };
      change = signOptions {
        hl = "GitSignsChange";
        text = "┃";
        numhl = "GitSignsChangeNr";
        linehl = "GitSignsChangeLn";
      };
      delete = signOptions {
        hl = "GitSignsDelete";
        text = "▁";
        numhl = "GitSignsDeleteNr";
        linehl = "GitSignsDeleteLn";
      };
      topdelete = signOptions {
        hl = "GitSignsDelete";
        text = "▔";
        numhl = "GitSignsDeleteNr";
        linehl = "GitSignsDeleteLn";
      };
      changedelete = signOptions {
        hl = "GitSignsChange";
        text = "~";
        numhl = "GitSignsChangeNr";
        linehl = "GitSignsChangeLn";
      };
      untracked = signOptions {
        hl = "GitSignsAdd";
        text = "┆";
        numhl = "GitSignsAddNr";
        linehl = "GitSignsAddLn";
      };
    };
    worktrees =
      let
        worktreeModule = {
          options = {
            toplevel = mkOption {
              type = types.str;
            };
            gitdir = mkOption {
              type = types.str;
            };
          };
        };
      in
      mkOption {
        type = types.nullOr (types.listOf (types.submodule worktreeModule));
        default = null;
        description = ''
          Detached working trees.
          If normal attaching fails, then each entry in the table is attempted with the work tree
          details set.
        '';
      };
    onAttach = mkOption {
      type = types.nullOr luaFunction;
      default = null;
      description = ''
        Callback called when attaching to a buffer. Mainly used to setup keymaps
        when `config.keymaps` is empty. The buffer number is passed as the first
        argument.

        This callback can return `false` to prevent attaching to the buffer.
      '';
      example = ''
        \'\'
        function(bufnr)
          if vim.api.nvim_buf_get_name(bufnr):match(<PATTERN>) then
            -- Don't attach to specific buffers whose name matches a pattern
            return false
          end
          -- Setup keymaps
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'hs', '<cmd>lua require"gitsigns".stage_hunk()<CR>', {})
          ... -- More keymaps
        end
        \'\'
      '';
    };

    watchGitDir = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether the watcher is enabled";
      };
      interval = mkOption {
        type = types.int;
        default = 1000;
        description = "Interval the watcher waits between polls of the gitdir in milliseconds";
      };
      followFiles = mkOption {
        type = types.bool;
        default = true;
        description = "If a file is moved with `git mv`, switch the buffer to the new location";
      };
    };
    signPriority = mkOption {
      type = types.int;
      default = 6;
      description = "Priority to use for signs";
    };
    signcolumn = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable/disable symbols in the sign column.

        When enabled the highlights defined in `signs.*.hl` and symbols defined
        in `signs.*.text` are used.
      '';
    };
    numhl = mkEnableOption ''
      line number highlights.

      When enabled the highlights defined in `signs.*.numhl` are used. If
      the highlight group does not exist, then it is automatically defined
      and linked to the corresponding highlight group in `signs.*.hl`.
    '';
    linehl = mkEnableOption ''
      line highlights.

      When enabled the highlights defined in `signs.*.linehl` are used. If
      the highlight group does not exist, then it is automatically defined
      and linked to the corresponding highlight group in `signs.*.hl`.
    '';
    showDeleted = mkEnableOption ''
      showing the old version of hunks inline in the buffer (via virtual lines).

      Note: Virtual lines currently use the highlight `GitSignsDeleteVirtLn`.
    '';
    diffOpts =
      let
        diffOptModule = {
          options = {
            algorithm = mkOption {
              type = types.enum [ "myers" "minimal" "patience" "histogram" ];
              default = "myers";
              description = "Diff algorithm to use";
            };
            internal = mkOption {
              type = types.bool;
              default = false;
              description = "Use Neovim's built in xdiff library for running diffs";
            };
            indentHeuristic = mkOption {
              type = types.bool;
              default = false;
              description = "Use the indent heuristic for the internal diff library.";
            };
            vertical = mkOption {
              type = types.bool;
              default = true;
              description = "Start diff mode with vertical splits";
            };
            linematch = mkOption {
              type = types.nullOr types.int;
              default = null;
              description = ''
                Enable second-stage diff on hunks to align lines.
                Requires `internal=true`.
              '';
            };
          };
        };
      in
      mkOption {
        type = types.nullOr (types.submodule diffOptModule);
        default = null;
        description = "Diff options. If set to null they are derived from the vim diffopt";
      };
    base = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "The object/revision to diff against. Default to 'index'";
    };
    countChars = mkOption {
      type = types.attrsOf types.str;
      default = {
        "1" = "1";
        "2" = "2";
        "3" = "3";
        "4" = "4";
        "5" = "5";
        "6" = "6";
        "7" = "7";
        "8" = "8";
        "9" = "9";
        "+" = ">";
      };
      description = ''
        The count characters used when `signs.*.show_count` is enabled. The
        `+` entry is used as a fallback. With the default, any count outside
        of 1-9 uses the `>` character in the sign.

        Possible use cases for this field:
          • to specify unicode characters for the counts instead of 1-9.
          • to define characters to be used for counts greater than 9.
      '';
    };
    statusFormatter = mkOption {
      type = luaFunction;
      default = {
        function = ''
           function(status)
            local added, changed, removed = status.added, status.changed, status.removed
            local status_txt = {}
            if added   and added   > 0 then table.insert(status_txt, '+'..added  ) end
            if changed and changed > 0 then table.insert(status_txt, '~'..changed) end
            if removed and removed > 0 then table.insert(status_txt, '-'..removed) end
            return table.concat(status_txt, ' ')
          end
        '';
      };
      description = "Function used to format `b:gitsigns_status`";
    };
    maxFileLength = mkOption {
      type = types.int;
      default = 40000;
      description = "Max file length (in lines) to attach to";
    };
    previewConfig = mkOption {
      type = types.attrsOf types.anything;
      default = {
        border = "single";
        style = "minimal";
        relative = "cursor";
        row = 0;
        col = 1;
      };
      description = ''
        Option overrides for the Gitsigns preview window.
        Table is passed directly to `nvim_open_win`.
      '';
    };
    attachToUntracked = mkOption {
      type = types.bool;
      default = true;
      description = "Attach to untracked files.";
    };
    updateDebounce = mkOption {
      type = types.number;
      default = 100;
      description = "Debounce time for updates (in milliseconds).";
    };
    currentLineBlame = mkEnableOption ''
      Adds an unobtrusive and customisable blame annotation at the end of the current line.
    '';
    currentLineBlameOpts = {
      virtText = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to show a virtual text blame annotation";
      };
      virtTextPos = mkOption {
        type = types.enum [ "eol" "overlay" "right_align" ];
        default = "eol";
        description = "Blame annotation position";
      };
      delay = mkOption {
        type = types.int;
        default = 1000;
        description = "Sets the delay (in milliseconds) before blame virtual text is displayed";
      };
      ignoreWhitespace = mkEnableOption "Ignore whitespace when running blame";
      virtTextPriority = mkOption {
        type = types.int;
        default = 100;
        description = "Priority of virtual text";
      };
    };
    currentLineBlameFormatter = {
      normal = mkOption {
        type = types.either types.str luaFunction;
        default = " <author>, <author_time> - <summary>";
        description = ''
          String or function used to format the virtual text of
          |gitsigns-config-current_line_blame|.

          See |gitsigns-config-current_line_blame_formatter| for more details.
        '';
      };

      nonCommitted = mkOption {
        type = types.either types.str luaFunction;
        default = " <author>";
        description = ''
          String or function used to format the virtual text of
          |gitsigns-config-current_line_blame| for lines that aren't committed.
        '';
      };
    };
    trouble = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        When using setqflist() or setloclist(), open Trouble instead of the quickfix/location list
        window.
      '';
    };
    yadm.enable = mkEnableOption "YADM support";
    wordDiff = mkEnableOption ''
      Highlight intra-line word differences in the buffer.
      Requires `config.diff_opts.internal = true`.
    '';
    debugMode = mkEnableOption ''
      Enables debug logging and makes the following functions available: `dump_cache`,
      `debug_messages`, `clear_debug`.
    '';
  };

  config =
    let
      cfg = config.plugins.gitsigns;
    in
    mkIf cfg.enable {
      extraPlugins = with pkgs.vimPlugins; [
        cfg.package
      ];
      extraConfigLua =
        let
          luaFnOrStrToObj = val:
            if builtins.isString val
            then val
            else { __raw = val.function; };
          setupOptions = {
            inherit (cfg) worktrees signcolumn numhl linehl trouble yadm;
            signs = mapAttrs (_: signSetupOptions) cfg.signs;
            on_attach =
              if cfg.onAttach != null
              then { __raw = cfg.onAttach.function; }
              else null;
            watch_gitdir = {
              inherit (cfg.watchGitDir) enable interval;
              follow_files = cfg.watchGitDir.followFiles;
            };
            sign_priority = cfg.signPriority;
            show_deleted = cfg.showDeleted;
            diff_opts =
              if cfg.diffOpts == null
              then null
              else {
                inherit (cfg.diffOpts) algorithm internal vertical linematch;
                indent_heuristic = cfg.diffOpts.indentHeuristic;
              };
            count_chars =
              let
                isStrInt = s: (builtins.match "[0-9]+" s) != null;
              in
              {
                __raw =
                  "{"
                  + (concatStringsSep "," (
                    lib.mapAttrsToList
                      (
                        name: value:
                          if isStrInt name
                          then "[${name}] = ${helpers.toLuaObject value}"
                          else "[${helpers.toLuaObject name}] = ${helpers.toLuaObject value}"
                      )
                      cfg.countChars
                  ))
                  + "}";
              };
            status_formatter = { __raw = cfg.statusFormatter.function; };
            max_file_length = cfg.maxFileLength;
            preview_config = cfg.previewConfig;
            attach_to_untracked = cfg.attachToUntracked;
            update_debounce = cfg.updateDebounce;
            current_line_blame = cfg.currentLineBlame;
            current_line_blame_opts =
              let
                cfgCl = cfg.currentLineBlameOpts;
              in
              {
                inherit (cfgCl) delay;
                virt_text = cfgCl.virtText;
                virt_text_pos = cfgCl.virtTextPos;
                ignore_whitespace = cfgCl.ignoreWhitespace;
                virt_text_priority = cfgCl.virtTextPriority;
              };
            current_line_blame_formatter = luaFnOrStrToObj cfg.currentLineBlameFormatter.normal;
            current_line_blame_formatter_nc = luaFnOrStrToObj cfg.currentLineBlameFormatter.nonCommitted;
            word_diff = cfg.wordDiff;
            debug_mode = cfg.debugMode;
          };
        in
        ''
          require('gitsigns').setup(${helpers.toLuaObject setupOptions})
        '';
    };
}
