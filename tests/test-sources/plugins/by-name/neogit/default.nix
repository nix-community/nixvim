{ pkgs }:
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
        use_default_keymaps = true;
        disable_hint = false;
        disable_context_highlighting = false;
        disable_signs = false;
        prompt_force_push = true;
        graph_style = "ascii";
        commit_date_format.__raw = "nil";
        log_date_format.__raw = "nil";
        process_spinner = false;
        filewatcher.enabled = true;
        telescope_sorter.__raw = ''
          function()
            return nil
          end
        '';
        git_services = {
          "github.com" = {
            pull_request = "https://github.com/$\{owner}/$\{repository}/compare/$\{branch_name}?expand=1";
            commit = "https://github.com/$\{owner}/$\{repository}/commit/$\{oid}";
            tree = "https://$\{host}/$\{owner}/$\{repository}/tree/$\{branch_name}";
          };
          "bitbucket.org" = {
            pull_request = "https://bitbucket.org/\${owner}/$\{repository}/pull-requests/new?source=$\{branch_name}&t=1";
            commit = "https://bitbucket.org/$\{owner}/$\{repository}/commits/$\{oid}";
            tree = "https://bitbucket.org/$\{owner}/$\{repository}/branch/$\{branch_name}";
          };
          "gitlab.com" = {
            pull_request = "https://gitlab.com/$\{owner}/$\{repository}/merge_requests/new?merge_request[source_branch]=$\{branch_name}";
            commit = "https://gitlab.com/$\{owner}/$\{repository}/-/commit/$\{oid}";
            tree = "https://gitlab.com/$\{owner}/$\{repository}/-/tree/$\{branch_name}?ref_type=heads";
          };
          "azure.com" = {
            pull_request = "https://dev.azure.com/$\{owner}/_git/$\{repository}/pullrequestcreate?sourceRef=$\{branch_name}&targetRef=$\{target}";
            commit = "";
            tree = "";
          };
        };
        highlight.__empty = { };
        disable_insert_on_commit = "auto";
        use_per_project_settings = true;
        remember_settings = true;
        fetch_after_checkout = false;
        sort_branches = "-committerdate";
        commit_order = "topo";
        kind = "tab";
        floating = {
          relative = "editor";
          width = 0.8;
          height = 0.7;
          style = "minimal";
          border = "rounded";
        };
        initial_branch_name = "";
        disable_line_numbers = true;
        disable_relative_line_numbers = true;
        console_timeout = 2000;
        auto_show_console = true;
        auto_show_console_on = "output";
        auto_close_console = true;
        notification_icon = "󰊢";
        status = {
          show_head_commit_hash = true;
          recent_commit_count = 10;
          HEAD_padding = 10;
          HEAD_folded = false;
          mode_padding = 3;
          mode_text = {
            M = "modified";
            N = "new file";
            A = "added";
            D = "deleted";
            C = "copied";
            U = "updated";
            R = "renamed";
            T = "changed";
            DD = "unmerged";
            AU = "unmerged";
            UD = "unmerged";
            UA = "unmerged";
            DU = "unmerged";
            AA = "unmerged";
            UU = "unmerged";
            "?" = "";
          };
        };
        commit_editor = {
          kind = "tab";
          show_staged_diff = true;
          staged_diff_split_kind = "split";
          spell_check = true;
        };
        commit_select_view.kind = "tab";
        commit_view = {
          kind = "vsplit";
          verify_commit.__raw = "vim.fn.executable('gpg') == 1";
        };
        log_view.kind = "tab";
        rebase_editor.kind = "auto";
        reflog_view.kind = "tab";
        merge_editor.kind = "auto";
        preview_buffer.kind = "floating_console";
        popup.kind = "split";
        stash.kind = "tab";
        refs_view.kind = "tab";
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
          telescope.__raw = "nil";
          diffview.__raw = "nil";
          fzf_lua.__raw = "nil";
          mini_pick.__raw = "nil";
          snacks.__raw = "nil";
        };
        sections = {
          sequencer = {
            folded = false;
            hidden = false;
          };
          bisect = {
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
        ignored_settings.__empty = { };
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
            "<tab>" = "InsertCompletion";
            "<c-y>" = "CopySelection";
            "<space>" = "MultiselectToggleNext";
            "<s-space>" = "MultiselectTogglePrevious";
            "<c-j>" = "NOP";
            "<ScrollWheelDown>" = "ScrollWheelDown";
            "<ScrollWheelUp>" = "ScrollWheelUp";
            "<ScrollWheelLeft>" = "NOP";
            "<ScrollWheelRight>" = "NOP";
            "<LeftMouse>" = "MouseClick";
            "<2-LeftMouse>" = "NOP";
          };
          refs_view.x = "DeleteBranch";
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
            L = "MarginPopup";
            m = "MergePopup";
            p = "PullPopup";
            r = "RebasePopup";
            v = "RevertPopup";
          };
          status = {
            j = "MoveDown";
            k = "MoveUp";
            o = "OpenTree";
            q = "Close";
            I = "InitRepo";
            "1" = "Depth1";
            "2" = "Depth2";
            "3" = "Depth3";
            "4" = "Depth4";
            Q = "Command";
            "<tab>" = "Toggle";
            za = "Toggle";
            zo = "OpenFold";
            zc = "CloseFold";
            zC = "Depth1";
            zO = "Depth4";
            x = "Discard";
            s = "Stage";
            S = "StageUnstaged";
            "<c-s>" = "StageAll";
            u = "Unstage";
            K = "Untrack";
            R = "Rename";
            U = "UnstageStaged";
            y = "ShowRefs";
            "$" = "CommandHistory";
            Y = "YankSelected";
            "<c-r>" = "RefreshBuffer";
            "<cr>" = "GoToFile";
            "<s-cr>" = "PeekFile";
            "<c-v>" = "VSplitOpen";
            "<c-x>" = "SplitOpen";
            "<c-t>" = "TabOpen";
            "{" = "GoToPreviousHunkHeader";
            "}" = "GoToNextHunkHeader";
            "[c" = "OpenOrScrollUp";
            "]c" = "OpenOrScrollDown";
            "<c-k>" = "PeekUp";
            "<c-j>" = "PeekDown";
            "<c-n>" = "NextSection";
            "<c-p>" = "PreviousSection";
          };
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
    plugins.neogit.enable = true;

    dependencies = {
      git.enable = false;
      which.enable = false;
    };
  };
}
