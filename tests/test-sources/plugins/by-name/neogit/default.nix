{ pkgs, ... }:
{
  empty = {
    plugins.neogit.enable = true;
  };

  defaults = {
    # Otherwise `os.execute('which gpg')` returns an error and make the whole test derivation fail
    # (option `settings.commit_view.verify_commit`)
    extraPackages = [ pkgs.gnupg ];

    plugins.neogit = {
      enable = true;

      settings = {
        filewatcher = {
          enabled = true;
        };
        graph_style = "ascii";
        disable_hint = false;
        disable_context_highlighting = false;
        disable_signs = false;
        git_services = {
          "github.com" = "https://github.com/$\{owner}/$\{repository}/compare/$\{branch_name}?expand=1";
          "bitbucket.org" =
            "https://bitbucket.org/$\{owner}/$\{repository}/pull-requests/new?source=$\{branch_name}&t=1";
          "gitlab.com" =
            "https://gitlab.com/$\{owner}/$\{repository}/merge_requests/new?merge_request[source_branch]=$\{branch_name}";
        };
        telescope_sorter = null;
        disable_insert_on_commit = "auto";
        use_per_project_settings = true;
        remember_settings = true;
        auto_refresh = true;
        sort_branches = "-committerdate";
        kind = "tab";
        disable_line_numbers = true;
        console_timeout = 2000;
        auto_show_console = true;
        status = {
          recent_commit_count = 10;
        };
        commit_editor = {
          kind = "auto";
        };
        commit_select_view = {
          kind = "tab";
        };
        commit_view = {
          kind = "vsplit";
          verify_commit = "os.execute('which gpg') == 0";
        };
        log_view = {
          kind = "tab";
        };
        rebase_editor = {
          kind = "auto";
        };
        reflog_view = {
          kind = "tab";
        };
        merge_editor = {
          kind = "auto";
        };
        description_editor = {
          kind = "auto";
        };
        tag_editor = {
          kind = "auto";
        };
        preview_buffer = {
          kind = "split";
        };
        popup = {
          kind = "split";
        };
        signs = {
          hunk = [
            ""
            ""
          ];
          item = [
            ">"
            "v"
          ];
          section = [
            ">"
            "v"
          ];
        };
        integrations = {
          telescope = null;
          diffview = null;
          fzf-lua = null;
        };
        sections = {
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
        ignored_settings = [
          "NeogitPushPopup--force-with-lease"
          "NeogitPushPopup--force"
          "NeogitPullPopup--rebase"
          "NeogitCommitPopup--allow-empty"
          "NeogitRevertPopup--no-edit"
        ];

        mappings = {
          commit_editor = {
            q = "Close";
            "<c-c><c-c>" = "Submit";
            "<c-c><c-k>" = "Abort";
            "<m-p>" = "PrevMessage";
            "<m-n>" = "NextMessage";
            "<m-r>" = "ResetMessage";
          };
          commit_editor_I = {
            "<c-c><c-c>" = "Submit";
            "<c-c><c-k>" = "Abort";
          };
          rebase_editor = {
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
          };
          rebase_editor_I = {
            "<c-c><c-c>" = "Submit";
            "<c-c><c-k>" = "Abort";
          };
          finder = {
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
          };
          popup = {
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
          };
          status = {
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
          };
        };
        notification_icon = "󰊢";
        use_default_keymaps = true;
        highlight = {
          italic = true;
          bold = true;
          underline = true;
        };
      };
    };
  };

  example = {
    plugins.neogit = {
      enable = true;

      settings = {
        kind = "floating";
        commit_popup.kind = "floating";
        preview_buffer.kind = "floating";
        popup.kind = "floating";
        integrations.diffview = false;
        disable_commit_confirmation = true;
        disable_builtin_notifications = true;
        sections = {
          untracked = {
            folded = true;
            hidden = true;
          };
          unmerged = {
            folded = true;
            hidden = false;
          };
        };
        mappings = {
          status = {
            l = "Toggle";
            a = "Stage";
          };
        };
      };
    };
  };

  no-packages = {
    plugins.neogit = {
      enable = true;
      whichPackage = null;
    };

    dependencies.git.enable = false;
  };
}
