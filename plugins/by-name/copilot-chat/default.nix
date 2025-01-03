{
  lib,
  helpers,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "copilot-chat";
  packPathName = "CopilotChat.nvim";
  moduleName = "CopilotChat";
  package = "CopilotChat-nvim";

  maintainers = [ maintainers.GaetanLepage ];

  settingsOptions = {
    debug = helpers.defaultNullOpts.mkBool false ''
      Enable debug logging.
    '';

    proxy = helpers.defaultNullOpts.mkStr null ''
      Custom proxy to use, formatted as `[protocol://]host[:port]`.
    '';

    allow_insecure = helpers.defaultNullOpts.mkBool false ''
      Allow insecure server connections.
    '';

    system_prompt = helpers.defaultNullOpts.mkLua "require('CopilotChat.prompts').COPILOT_INSTRUCTIONS" ''
      System prompt to use.
    '';

    model = helpers.defaultNullOpts.mkStr "gpt-4" ''
      GPT model to use, 'gpt-3.5-turbo' or 'gpt-4'.
    '';

    temperature = helpers.defaultNullOpts.mkProportion 0.1 ''
      GPT temperature.
    '';

    question_header = helpers.defaultNullOpts.mkStr "## User " ''
      Header to use for user questions.
    '';

    answer_header = helpers.defaultNullOpts.mkStr "## Copilot " ''
      Header to use for AI answers.
    '';

    error_header = helpers.defaultNullOpts.mkStr "## Error " ''
      Header to use for errors.
    '';

    separator = helpers.defaultNullOpts.mkStr "───" ''
      Separator to use in chat.
    '';

    show_folds = helpers.defaultNullOpts.mkBool true ''
      Shows folds for sections in chat.
    '';

    show_help = helpers.defaultNullOpts.mkBool true ''
      Shows help message as virtual lines when waiting for user input.
    '';

    auto_follow_cursor = helpers.defaultNullOpts.mkBool true ''
      Auto-follow cursor in chat.
    '';

    auto_insert_mode = helpers.defaultNullOpts.mkBool false ''
      Automatically enter insert mode when opening window and if auto follow cursor is enabled on new prompt.
    '';

    clear_chat_on_new_prompt = helpers.defaultNullOpts.mkBool false ''
      Clears chat on every new prompt.
    '';

    highlight_selection = helpers.defaultNullOpts.mkBool true ''
      Highlight selection.
    '';

    context =
      helpers.defaultNullOpts.mkEnum
        [
          "buffers"
          "buffer"
        ]
        null
        ''
          Default context to use, `"buffers"`, `"buffer"` or `null` (can be specified manually in prompt via @).
        '';

    history_path = helpers.defaultNullOpts.mkStr (helpers.mkRaw "vim.fn.stdpath('data') .. '/copilotchat_history'") ''
      Default path to stored history.
    '';

    callback = helpers.defaultNullOpts.mkLuaFn null ''
      Callback to use when ask response is received.

      `fun(response: string, source: CopilotChat.config.source)`
    '';

    selection =
      helpers.defaultNullOpts.mkLuaFn
        ''
          function(source)
            local select = require('CopilotChat.select')
            return select.visual(source) or select.line(source)
          end
        ''
        ''
          Default selection (visual or line).
          `fun(source: CopilotChat.config.source):CopilotChat.config.selection`
        '';

    prompts =
      let
        promptType = types.submodule {
          freeformType = with types; attrsOf anything;
          options = {
            prompt = helpers.mkNullOrStr "Prompt text.";

            description = helpers.mkNullOrStr "Description for this prompt.";

            kind = helpers.mkNullOrStr "Kind of this prompt.";

            mapping = helpers.mkNullOrStr "A key to bind to this prompt.";

            system_prompt = helpers.mkNullOrStr "System prompt to use.";

            callback = helpers.mkNullOrLuaFn ''
              Callback to trigger when this prompt is executed.
              `fun(response: string, source: CopilotChat.config.source)`
            '';

            selection = helpers.mkNullOrLuaFn ''
              Selection for this prompt.
              `fun(source: CopilotChat.config.source):CopilotChat.config.selection`
            '';
          };
        };

        default = {
          Explain.prompt = "/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.";
          Review = {
            prompt = "/COPILOT_REVIEW Review the selected code.";
            callback = ''
              function(response, source)
                -- see config.lua for implementation
              end
            '';
          };
          Fix.prompt = "/COPILOT_GENERATE There is a problem in this code. Rewrite the code to show it with the bug fixed.";
          Optimize.prompt = "/COPILOT_GENERATE Optimize the selected code to improve performance and readablilty.";
          Docs.prompt = "/COPILOT_GENERATE Please add documentation comment for the selection.";
          Tests.prompt = "/COPILOT_GENERATE Please generate tests for my code.";
          FixDiagnostic = {
            prompt = "Please assist with the following diagnostic issue in file:";
            selection = "require('CopilotChat.select').diagnostics";
          };
          Commit = {
            prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.";
            selection = "require('CopilotChat.select').gitdiff";
          };
          CommitStaged = {
            prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.";
            selection = ''
              function(source)
                return select.gitdiff(source, true)
              end
            '';
          };
        };
      in
      helpers.defaultNullOpts.mkAttrsOf (with types; either str promptType) default ''
        Default prompts.
      '';

    window = {
      layout =
        helpers.defaultNullOpts.mkEnumFirstDefault
          [
            "vertical"
            "horizontal"
            "float"
            "replace"
          ]
          ''
            Layout for the window.
          '';

      width =
        helpers.defaultNullOpts.mkNullableWithRaw
          (with types; either (numbers.between 0.0 1.0) ints.positive)
          0.5
          ''
            Fractional width of parent, or absolute width in columns when > 1.
          '';

      height =
        helpers.defaultNullOpts.mkNullableWithRaw
          (with types; either (numbers.between 0.0 1.0) ints.positive)
          0.5
          ''
            Fractional height of parent, or absolute height in rows when > 1.
          '';

      relative =
        helpers.defaultNullOpts.mkEnumFirstDefault
          [
            "editor"
            "win"
            "cursor"
            "mouse"
          ]
          ''
            Relative position.
            (Only for floating windows.)
          '';

      border =
        helpers.defaultNullOpts.mkEnum
          [
            "none"
            "single"
            "double"
            "rounded"
            "solid"
            "shadow"
          ]
          "single"
          ''
            Border for this window.
            (Only for floating windows.)
          '';

      row = helpers.defaultNullOpts.mkUnsignedInt null ''
        Row position of the window, default is centered.
        (Only for floating windows.)
      '';

      col = helpers.defaultNullOpts.mkUnsignedInt null ''
        Column position of the window, default is centered.
        (Only for floating windows.)
      '';

      title = helpers.defaultNullOpts.mkStr "Copilot Chat" ''
        Title of chat window.
      '';

      footer = helpers.defaultNullOpts.mkStr null ''
        Footer of chat window.
      '';

      zindex = helpers.defaultNullOpts.mkUnsignedInt 1 ''
        Determines if window is on top or below other floating windows.
      '';
    };

    mappings =
      helpers.defaultNullOpts.mkAttrsOf
        (types.submodule {
          freeformType = with types; attrsOf anything;
          options = {
            normal = helpers.mkNullOrStr "Key for normal mode.";

            insert = helpers.mkNullOrStr "Key for insert mode.";

            detail = helpers.mkNullOrStr "A description for this binding.";
          };
        })
        {
          complete.insert = "<Tab>";
          close = {
            normal = "q";
            insert = "<C-c>";
          };
          reset = {
            normal = "<C-l>";
            insert = "<C-l>";
          };
          submit_prompt = {
            normal = "<CR>";
            insert = "<C-s>";
          };
          toggle_sticky = {
            detail = "Makes line under cursor sticky or deletes sticky line.";
            normal = "gr";
          };
          accept_diff = {
            normal = "<C-y>";
            insert = "<C-y>";
          };
          jump_to_diff.normal = "gj";
          quickfix_diffs.normal = "gq";
          yank_diff = {
            normal = "gy";
            register = "\"";
          };
          show_diff.normal = "gd";
          show_info.normal = "gi";
          show_context.normal = "gc";
          show_help.normal = "gh";
        }
        "Mappings for CopilotChat.";
  };

  settingsExample = {
    question_header = "## User ";
    answer_header = "## Copilot ";
    error_header = "## Error ";
    prompts = {
      Explain = "Please explain how the following code works.";
      Review = "Please review the following code and provide suggestions for improvement.";
      Tests = "Please explain how the selected code works, then generate unit tests for it.";
    };
    auto_follow_cursor = false;
    show_help = false;
    mappings = {
      complete = {
        detail = "Use @<Tab> or /<Tab> for options.";
        insert = "<Tab>";
      };
      close = {
        normal = "q";
        insert = "<C-c>";
      };
    };
  };
}
