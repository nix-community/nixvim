{
  empty = {
    plugins.tinygit.enable = true;
  };

  defaults = {
    plugins.tinygit = {
      enable = true;

      settings = {
        stage = {
          contextSize = 1;
          stagedIndicator = "󰐖";
          keymaps = {
            stagingToggle = "<Space>";
            gotoHunk = "<CR>";
            resetHunk = "<C-r>";
          };
          moveToNextHunkOnStagingToggle = false;
          telescopeOpts = {
            layout_strategy = "horizontal";
            layout_config = {
              horizontal = {
                preview_width = 0.65;
                height = {
                  __unkeyed = 0.7;
                  min = 20;
                };
              };
            };
          };
        };
        commit = {
          keepAbortedMsgSecs = 300;
          border = "rounded";
          spellcheck = false;
          wrap = "hard";
          keymaps = {
            normal = {
              abort = "q";
              confirm = "<CR>";
            };
            insert = {
              confirm = "<C-CR>";
            };
          };
          subject = {
            autoFormat.__raw = ''
              function(subject) ---@type nil|fun(subject: string): string
                subject = subject:gsub("%.$", "") -- remove trailing dot https://commitlint.js.org/reference/rules.html#body-full-stop
                return subject
              end
            '';
            enforceType = false;
            types = [
              "fix"
              "feat"
              "chore"
              "docs"
              "refactor"
              "build"
              "test"
              "perf"
              "style"
              "revert"
              "ci"
              "break"
            ];
          };
          body = {
            enforce = false;
          };
        };
        push = {
          preventPushingFixupCommits = true;
          confirmationSound = true;
          openReferencedIssues = false;
        };
        github = {
          icons = {
            openIssue = "🟢";
            closedIssue = "🟣";
            notPlannedIssue = "⚪";
            openPR = "🟩";
            mergedPR = "🟪";
            draftPR = "⬜";
            closedPR = "🟥";
          };
        };
        history = {
          diffPopup = {
            width = 0.8;
            height = 0.8;
            border = "rounded";
          };
          autoUnshallowIfNeeded = false;
        };
        appearance = {
          mainIcon = "󰊢";
          backdrop = {
            enabled = true;
            blend = 40;
          };
        };
        statusline = {
          blame = {
            ignoreAuthors.__empty = { };
            hideAuthorNames.__empty = { };
            maxMsgLen = 40;
            icon = "ﰖ";
          };
          branchState = {
            icons = {
              ahead = "󰶣";
              behind = "󰶡";
              diverge = "󰃻";
            };
          };
        };
      };
    };
  };

  example = {
    plugins.tinygit = {
      enable = true;

      settings = {
        stage.moveToNextHunkOnStagingToggle = true;
        commit = {
          keepAbortedMsgSecs.__raw = "60 * 10";
          spellcheck = true;
          subject = {
            autoFormat.__raw = ''
              function(subject)
                -- remove trailing dot https://commitlint.js.org/reference/rules.html#body-full-stop
                subject = subject:gsub("%.$", "")

                -- sentence case of title after the type
                subject = subject
                  :gsub("^(%w+: )(.)", function(c1, c2) return c1 .. c2:lower() end) -- no scope
                  :gsub("^(%w+%b(): )(.)", function(c1, c2) return c1 .. c2:lower() end) -- with scope
                return subject
              end
            '';
            enforceType = true;
            types = [
              "fix"
              "feat"
              "chore"
              "docs"
              "refactor"
              "build"
              "test"
              "perf"
              "style"
              "revert"
              "ci"
              "break"
              "improv"
            ];
          };
        };
        push.openReferencedIssues = true;
        history = {
          autoUnshallowIfNeeded = true;
          diffPopup = {
            width = 0.9;
            height = 0.9;
          };
        };
        statusline = {
          blame = {
            hideAuthorNames = [
              "John Doe"
              "johndoe"
            ];
            ignoreAuthors = [ "🤖 automated" ];
            maxMsgLen = 55;
          };
        };
      };
    };
  };
}
