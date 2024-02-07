{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  signOptions = defaults: {
    hl =
      helpers.defaultNullOpts.mkStr defaults.hl
      "Specifies the highlight group to use for the sign";
    text =
      helpers.defaultNullOpts.mkStr defaults.text
      "Specifies the character to use for the sign";
    numhl =
      helpers.defaultNullOpts.mkStr defaults.numhl
      "Specifies the highlight group to use for the number column";
    linehl =
      helpers.defaultNullOpts.mkStr defaults.linehl
      "Specifies the highlight group to use for the line";
    showCount =
      helpers.defaultNullOpts.mkBool false
      "showing count of hunk, e.g. number of deleted lines";
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
in {
  options.plugins.gitsigns = {
    enable = mkEnableOption "gitsigns plugin";

    package = helpers.mkPackageOption "gitsigns" pkgs.vimPlugins.gitsigns-nvim;

    gitPackage = mkOption {
      type = with types; nullOr package;
      default = pkgs.git;
      description = "Which package to use for git.";
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
    worktrees = let
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
        {
          function = \'\'
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
        }
      '';
    };

    watchGitDir = {
      enable =
        helpers.defaultNullOpts.mkBool true
        "Whether the watcher is enabled";
      interval =
        helpers.defaultNullOpts.mkInt 1000
        "Interval the watcher waits between polls of the gitdir in milliseconds";
      followFiles =
        helpers.defaultNullOpts.mkBool true
        "If a file is moved with `git mv`, switch the buffer to the new location";
    };
    signPriority =
      helpers.defaultNullOpts.mkInt 6
      "Priority to use for signs";
    signcolumn =
      helpers.defaultNullOpts.mkBool true
      ''
        Enable/disable symbols in the sign column.

        When enabled the highlights defined in `signs.*.hl` and symbols defined
        in `signs.*.text` are used.
      '';
    numhl = helpers.defaultNullOpts.mkBool false ''
      line number highlights.

      When enabled the highlights defined in `signs.*.numhl` are used. If
      the highlight group does not exist, then it is automatically defined
      and linked to the corresponding highlight group in `signs.*.hl`.
    '';
    linehl = helpers.defaultNullOpts.mkBool false ''
      line highlights.

      When enabled the highlights defined in `signs.*.linehl` are used. If
      the highlight group does not exist, then it is automatically defined
      and linked to the corresponding highlight group in `signs.*.hl`.
    '';
    showDeleted = helpers.defaultNullOpts.mkBool false ''
      showing the old version of hunks inline in the buffer (via virtual lines).

      Note: Virtual lines currently use the highlight `GitSignsDeleteVirtLn`.
    '';
    diffOpts = let
      diffOptModule = {
        options = {
          algorithm =
            helpers.defaultNullOpts.mkEnumFirstDefault ["myers" "minimal" "patience" "histogram"]
            "Diff algorithm to use";
          internal =
            helpers.defaultNullOpts.mkBool false
            "Use Neovim's built in xdiff library for running diffs";
          indentHeuristic =
            helpers.defaultNullOpts.mkBool false
            "Use the indent heuristic for the internal diff library.";
          vertical =
            helpers.defaultNullOpts.mkBool true
            "Start diff mode with vertical splits";
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
    countChars =
      helpers.defaultNullOpts.mkNullable (types.attrsOf types.str) ''
        {
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
        }
      '' ''
        The count characters used when `signs.*.show_count` is enabled. The
        `+` entry is used as a fallback. With the default, any count outside
        of 1-9 uses the `>` character in the sign.

        Possible use cases for this field:
          • to specify unicode characters for the counts instead of 1-9.
          • to define characters to be used for counts greater than 9.
      '';
    statusFormatter = helpers.defaultNullOpts.mkNullable luaFunction ''
      {
        function = \'\'
           function(status)
            local added, changed, removed = status.added, status.changed, status.removed
            local status_txt = {}
            if added   and added   > 0 then table.insert(status_txt, '+'..added  ) end
            if changed and changed > 0 then table.insert(status_txt, '~'..changed) end
            if removed and removed > 0 then table.insert(status_txt, '-'..removed) end
            return table.concat(status_txt, ' ')
          end
        \'\';
      }
    '' "Function used to format `b:gitsigns_status`";
    maxFileLength =
      helpers.defaultNullOpts.mkInt 40000
      "Max file length (in lines) to attach to";
    previewConfig =
      helpers.defaultNullOpts.mkNullable (types.attrsOf types.anything) ''
        {
          border = "single";
          style = "minimal";
          relative = "cursor";
          row = 0;
          col = 1;
        }
      '' ''
        Option overrides for the Gitsigns preview window.
        Table is passed directly to `nvim_open_win`.
      '';
    attachToUntracked =
      helpers.defaultNullOpts.mkBool true
      "Attach to untracked files.";
    updateDebounce =
      helpers.defaultNullOpts.mkInt 100
      "Debounce time for updates (in milliseconds).";
    currentLineBlame = helpers.defaultNullOpts.mkBool false ''
      Adds an unobtrusive and customisable blame annotation at the end of the current line.
    '';
    currentLineBlameOpts = {
      virtText =
        helpers.defaultNullOpts.mkBool true
        "Whether to show a virtual text blame annotation";
      virtTextPos =
        helpers.defaultNullOpts.mkEnumFirstDefault ["eol" "overlay" "right_align"]
        "Blame annotation position";
      delay =
        helpers.defaultNullOpts.mkInt 1000
        "Sets the delay (in milliseconds) before blame virtual text is displayed";
      ignoreWhitespace =
        helpers.defaultNullOpts.mkBool false
        "Ignore whitespace when running blame";
      virtTextPriority =
        helpers.defaultNullOpts.mkInt 100
        "Priority of virtual text";
    };
    currentLineBlameFormatter = {
      normal =
        helpers.defaultNullOpts.mkNullable (types.either types.str luaFunction)
        ''" <author>, <author_time> - <summary>"'' ''
          String or function used to format the virtual text of
          |gitsigns-config-current_line_blame|.

          See |gitsigns-config-current_line_blame_formatter| for more details.
        '';

      nonCommitted =
        helpers.defaultNullOpts.mkNullable (types.either types.str luaFunction)
        ''" <author>"'' ''
          String or function used to format the virtual text of
          |gitsigns-config-current_line_blame| for lines that aren't committed.
        '';
    };
    trouble = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        When using setqflist() or setloclist(), open Trouble instead of the quickfix/location list
        window.
      '';
    };
    yadm.enable = helpers.defaultNullOpts.mkBool false "YADM support";
    wordDiff = helpers.defaultNullOpts.mkBool false ''
      Highlight intra-line word differences in the buffer.
      Requires `config.diff_opts.internal = true`.
    '';
    debugMode = helpers.defaultNullOpts.mkBool false ''
      Enables debug logging and makes the following functions available: `dump_cache`,
      `debug_messages`, `clear_debug`.
    '';
  };

  config = let
    cfg = config.plugins.gitsigns;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraPackages = optional (cfg.gitPackage != null) cfg.gitPackage;

      extraConfigLua = let
        luaFnOrStrToObj = val:
          if val == null
          then null
          else if builtins.isString val
          then val
          else {__raw = val.function;};
        setupOptions = {
          inherit (cfg) worktrees signcolumn numhl linehl trouble yadm;
          signs = mapAttrs (_: signSetupOptions) cfg.signs;
          on_attach =
            if cfg.onAttach != null
            then {__raw = cfg.onAttach.function;}
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
          count_chars = let
            isStrInt = s: (builtins.match "[0-9]+" s) != null;
          in
            if cfg.countChars != null
            then {
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
            }
            else null;
          status_formatter =
            if cfg.statusFormatter != null
            then {__raw = cfg.statusFormatter.function;}
            else null;
          max_file_length = cfg.maxFileLength;
          preview_config = cfg.previewConfig;
          attach_to_untracked = cfg.attachToUntracked;
          update_debounce = cfg.updateDebounce;
          current_line_blame = cfg.currentLineBlame;
          current_line_blame_opts = let
            cfgCl = cfg.currentLineBlameOpts;
          in {
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
      in ''
        require('gitsigns').setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
