{ lib, helpers }:
with lib;
let
  mkKindOption = helpers.defaultNullOpts.mkEnum [
    "split"
    "vsplit"
    "split_above"
    "tab"
    "floating"
    "replace"
    "auto"
  ];
in
{
  filewatcher = {
    enabled = helpers.defaultNullOpts.mkBool true ''
      When enabled, will watch the `.git/` directory for changes and refresh the status buffer
      in response to filesystem events.
    '';
  };

  graph_style =
    helpers.defaultNullOpts.mkEnumFirstDefault
      [
        "ascii"
        "unicode"
        "kitty"
      ]
      ''
        - "ascii"   is the graph the git CLI generates
        - "unicode" is the graph like https://github.com/rbong/vim-flog
        - "kitty"   is the graph like https://github.com/isakbm/gitgraph.nvim
      '';

  disable_hint = helpers.defaultNullOpts.mkBool false ''
    Hides the hints at the top of the status buffer.
  '';

  disable_context_highlighting = helpers.defaultNullOpts.mkBool false ''
    Disables changing the buffer highlights based on where the cursor is.
  '';

  disable_signs = helpers.defaultNullOpts.mkBool false ''
    Disables signs for sections/items/hunks.
  '';

  git_services = helpers.defaultNullOpts.mkAttrsOf types.str {
    "github.com" = "https://github.com/$\{owner}/$\{repository}/compare/$\{branch_name}?expand=1";
    "bitbucket.org" =
      "https://bitbucket.org/$\{owner}/$\{repository}/pull-requests/new?source=$\{branch_name}&t=1";
    "gitlab.com" =
      "https://gitlab.com/$\{owner}/$\{repository}/merge_requests/new?merge_request[source_branch]=$\{branch_name}";
  } "Used to generate URL's for branch popup action 'pull request'.";

  fetch_after_checkout = helpers.defaultNullOpts.mkBool false ''
    Perform a fetch if the newly checked out branch has an upstream or pushRemote set.
  '';

  telescope_sorter = helpers.mkNullOrLuaFn ''
    Allows a different telescope sorter.
    Defaults to 'fuzzy_with_index_bias'.
    The example below will use the native fzf sorter instead.
    By default, this function returns `nil`.

    Example:
    ```lua
      require("telescope").extensions.fzf.native_fzf_sorter
    ```
  '';

  disable_insert_on_commit =
    helpers.defaultNullOpts.mkNullable (with types; either bool (enum [ "auto" ])) "auto"
      ''
        Changes what mode the Commit Editor starts in.
        `true` will leave nvim in normal mode, `false` will change nvim to insert mode, and `"auto"`
        will change nvim to insert mode IF the commit message is empty, otherwise leaving it in normal
        mode.
      '';

  use_per_project_settings = helpers.defaultNullOpts.mkBool true ''
    Scope persisted settings on a per-project basis.
  '';

  remember_settings = helpers.defaultNullOpts.mkBool true ''
    Persist the values of switches/options within and across sessions.
  '';

  auto_refresh = helpers.defaultNullOpts.mkBool true ''
    Neogit refreshes its internal state after specific events, which can be expensive depending on
    the repository size.
    Disabling `auto_refresh` will make it so you have to manually refresh the status after you open
    it.
  '';

  sort_branches = helpers.defaultNullOpts.mkStr "-committerdate" ''
    Value used for `--sort` option for `git branch` command.
    By default, branches will be sorted by commit date descending.
    Flag description: https://git-scm.com/docs/git-branch#Documentation/git-branch.txt---sortltkeygt
    Sorting keys: https://git-scm.com/docs/git-for-each-ref#_options
  '';

  kind = mkKindOption "tab" ''
    Change the default way of opening neogit.
  '';

  disable_line_numbers = helpers.defaultNullOpts.mkBool true ''
    Disable line numbers and relative line numbers.
  '';

  console_timeout = helpers.defaultNullOpts.mkUnsignedInt 2000 ''
    The time after which an output console is shown for slow running commands.
  '';

  auto_show_console = helpers.defaultNullOpts.mkBool true ''
    Automatically show console if a command takes more than `consoleTimeout` milliseconds.
  '';

  status = {
    recent_commit_count = helpers.defaultNullOpts.mkUnsignedInt 10 ''
      Recent commit count in the status buffer.
    '';
  };

  commit_editor = {
    kind = mkKindOption "auto" "The type of window that should be opened.";
  };

  commit_select_view = {
    kind = mkKindOption "tab" "The type of window that should be opened.";
  };

  commit_view = {
    kind = mkKindOption "vsplit" "The type of window that should be opened.";

    verify_commit = helpers.mkNullOrStrLuaOr types.bool ''
      Show commit signature information in the buffer.
      Can be set to true or false, otherwise we try to find the binary.

      Default: "os.execute('which gpg') == 0"
    '';
  };

  log_view = {
    kind = mkKindOption "tab" "The type of window that should be opened.";
  };

  rebase_editor = {
    kind = mkKindOption "auto" "The type of window that should be opened.";
  };

  reflog_view = {
    kind = mkKindOption "tab" "The type of window that should be opened.";
  };

  merge_editor = {
    kind = mkKindOption "auto" "The type of window that should be opened.";
  };

  description_editor = {
    kind = mkKindOption "auto" "The type of window that should be opened.";
  };

  tag_editor = {
    kind = mkKindOption "auto" "The type of window that should be opened.";
  };

  preview_buffer = {
    kind = mkKindOption "split" "The type of window that should be opened.";
  };

  popup = {
    kind = mkKindOption "split" "The type of window that should be opened.";
  };

  signs =
    mapAttrs
      (
        n: v:
        helpers.defaultNullOpts.mkListOf types.str
          [
            "${v.closed}"
            "${v.opened}"
          ]
          ''
            The icons to use for open and closed ${n}s.
          ''
      )
      {
        hunk = {
          closed = "";
          opened = "";
        };
        item = {
          closed = ">";
          opened = "v";
        };
        section = {
          closed = ">";
          opened = "v";
        };
      };

  integrations = {
    telescope = helpers.mkNullOrOption types.bool ''
      If enabled, use telescope for menu selection rather than `vim.ui.select`.
      Allows multi-select and some things that `vim.ui.select` doesn't.
    '';

    diffview = helpers.mkNullOrOption types.bool ''
      Neogit only provides inline diffs.
      If you want a more traditional way to look at diffs, you can use `diffview`.
      The diffview integration enables the diff popup.
    '';

    fzf-lua = helpers.mkNullOrOption types.bool ''
      If enabled, uses fzf-lua for menu selection.
      If the telescope integration is also selected then telescope is used instead.
    '';
  };

  sections =
    mapAttrs
      (
        name: default:
        mkOption {
          type =
            with types;
            nullOr (submodule {
              options = {
                folded = mkOption {
                  type = types.bool;
                  description = "Whether or not this section should be open or closed by default.";
                };

                hidden = mkOption {
                  type = types.bool;
                  description = "Whether or not this section should be shown.";
                };
              };
            });
          inherit default;
          description = "Settings for the ${name} section";
        }
      )
      {
        sequencer = {
          folded = false;
          hidden = false;
        };
        untracked = {
          folded = false;
          hidden = false;
        };
        unstaged = {
          folded = false;
          hidden = false;
        };
        staged = {
          folded = false;
          hidden = false;
        };
        stashes = {
          folded = true;
          hidden = false;
        };
        unpulled_upstream = {
          folded = true;
          hidden = false;
        };
        unmerged_upstream = {
          folded = false;
          hidden = false;
        };
        unpulled_pushRemote = {
          folded = true;
          hidden = false;
        };
        unmerged_pushRemote = {
          folded = false;
          hidden = false;
        };
        recent = {
          folded = true;
          hidden = false;
        };
        rebase = {
          folded = true;
          hidden = false;
        };
      };

  ignored_settings =
    helpers.defaultNullOpts.mkListOf types.str
      [
        "NeogitPushPopup--force-with-lease"
        "NeogitPushPopup--force"
        "NeogitPullPopup--rebase"
        "NeogitCommitPopup--allow-empty"
        "NeogitRevertPopup--no-edit"
      ]
      ''
        Table of settings to never persist.
        Uses format "Filetype--cli-value".
      '';

  mappings =
    let
      mkMappingOption = helpers.defaultNullOpts.mkAttrsOf (with types; either str (enum [ false ]));
    in
    {
      commit_editor = mkMappingOption {
        q = "Close";
        "<c-c><c-c>" = "Submit";
        "<c-c><c-k>" = "Abort";
        "<m-p>" = "PrevMessage";
        "<m-n>" = "NextMessage";
        "<m-r>" = "ResetMessage";
      } "Mappings for the commit editor.";

      commit_editor_I = mkMappingOption {
        "<c-c><c-c>" = "Submit";
        "<c-c><c-k>" = "Abort";
      } "Mappings for the commit editor (insert mode)";

      rebase_editor = mkMappingOption {
        p = "Pick";
        r = "Reword";
        e = "Edit";
        s = "Squash";
        f = "Fixup";
        x = "Execute";
        d = "Drop";
        b = "Break";
        q = "Close";
        "<cr>" = "OpenCommit";
        gk = "MoveUp";
        gj = "MoveDown";
        "<c-c><c-c>" = "Submit";
        "<c-c><c-k>" = "Abort";
        "[c" = "OpenOrScrollUp";
        "]c" = "OpenOrScrollDown";
      } "Mappings for the rebase editor.";

      rebase_editor_I = mkMappingOption {
        "<c-c><c-c>" = "Submit";
        "<c-c><c-k>" = "Abort";
      } "Mappings for the rebase editor (insert mode).";

      finder = mkMappingOption {
        "<cr>" = "Select";
        "<c-c>" = "Close";
        "<esc>" = "Close";
        "<c-n>" = "Next";
        "<c-p>" = "Previous";
        "<down>" = "Next";
        "<up>" = "Previous";
        "<tab>" = "MultiselectToggleNext";
        "<s-tab>" = "MultiselectTogglePrevious";
        "<c-j>" = "NOP";
        "<ScrollWheelDown>" = "ScrollWheelDown";
        "<ScrollWheelUp>" = "ScrollWheelUp";
        "<ScrollWheelLeft>" = "NOP";
        "<ScrollWheelRight>" = "NOP";
        "<LeftMouse>" = "MouseClick";
        "<2-LeftMouse>" = "NOP";
      } "Mappings for the finder.";

      popup = mkMappingOption {
        "?" = "HelpPopup";
        A = "CherryPickPopup";
        d = "DiffPopup";
        M = "RemotePopup";
        P = "PushPopup";
        X = "ResetPopup";
        Z = "StashPopup";
        i = "IgnorePopup";
        t = "TagPopup";
        b = "BranchPopup";
        B = "BisectPopup";
        w = "WorktreePopup";
        c = "CommitPopup";
        f = "FetchPopup";
        l = "LogPopup";
        m = "MergePopup";
        p = "PullPopup";
        r = "RebasePopup";
        v = "RevertPopup";
      } "Mappings for popups.";

      status = mkMappingOption {
        q = "Close";
        I = "InitRepo";
        "1" = "Depth1";
        "2" = "Depth2";
        "3" = "Depth3";
        "4" = "Depth4";
        "<tab>" = "Toggle";
        x = "Discard";
        s = "Stage";
        S = "StageUnstaged";
        "<c-s>" = "StageAll";
        u = "Unstage";
        K = "Untrack";
        U = "UnstageStaged";
        y = "ShowRefs";
        "$" = "CommandHistory";
        Y = "YankSelected";
        "<c-r>" = "RefreshBuffer";
        "<cr>" = "GoToFile";
        "<c-v>" = "VSplitOpen";
        "<c-x>" = "SplitOpen";
        "<c-t>" = "TabOpen";
        "{" = "GoToPreviousHunkHeader";
        "}" = "GoToNextHunkHeader";
        "[c" = "OpenOrScrollUp";
        "]c" = "OpenOrScrollDown";
      } "Mappings for status.";
    };

  notification_icon = helpers.defaultNullOpts.mkStr "󰊢" ''
    Icon for notifications.
  '';

  use_default_keymaps = helpers.defaultNullOpts.mkBool true ''
    Set to false if you want to be responsible for creating _ALL_ keymappings.
  '';

  highlight = genAttrs [
    "italic"
    "bold"
    "underline"
  ] (n: helpers.defaultNullOpts.mkBool true "Set the ${n} property of the highlight group.");
}
