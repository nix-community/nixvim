{

  empty = {
    plugins.copilot-chat.enable = true;
  };

  defaults = {
    plugins.copilot-chat = {
      enable = true;

      settings = {
        debug = false;
        proxy = null;
        allow_insecure = false;
        system_prompt = "require('CopilotChat.prompts').COPILOT_INSTRUCTIONS";
        model = "gpt-4";
        temperature = 0.1;
        question_header = "## User ";
        answer_header = "## Copilot ";
        error_header = "## Error ";
        separator = "───";
        show_folds = true;
        show_help = true;
        auto_follow_cursor = true;
        auto_insert_mode = false;
        clear_chat_on_new_prompt = false;
        highlight_selection = true;
        context = null;
        history_path.__raw = "vim.fn.stdpath('data') .. '/copilotchat_history'";
        callback = null;
        selection = ''
          function(source)
            local select = require('CopilotChat.select')
            return select.visual(source) or select.line(source)
          end
        '';
        prompts = {
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

        window = {
          layout = "vertical";
          width = 0.5;
          height = 0.5;
          relative = "editor";
          border = "single";
          row = null;
          col = null;
          title = "Copilot Chat";
          footer = null;
          zindex = 1;
        };
        mappings = {
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
        };
      };
    };
  };

  example = {
    plugins.copilot-chat = {
      enable = true;

      settings = {
        question_header = "## User ";
        answer_header = "## Copilot ";
        error_header = "## Error ";
        prompts = {
          Explain = "Please explain how the following code works.";
          Review = "Please review the following code and provide suggestions for improvement.";
          Tests = "Please explain how the selected code works, then generate unit tests for it.";
          Refactor = "Please refactor the following code to improve its clarity and readability.";
          FixCode = "Please fix the following code to make it work as intended.";
          FixError = "Please explain the error in the following text and provide a solution.";
          BetterNamings = "Please provide better names for the following variables and functions.";
          Documentation = "Please provide documentation for the following code.";
          SwaggerApiDocs = "Please provide documentation for the following API using Swagger.";
          SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.";
          Summarize = "Please summarize the following text.";
          Spelling = "Please correct any grammar and spelling errors in the following text.";
          Wording = "Please improve the grammar and wording of the following text.";
          Concise = "Please rewrite the following text to make it more concise.";
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
          reset = {
            normal = "<C-x>";
            insert = "<C-x>";
          };
          submit_prompt = {
            normal = "<CR>";
            insert = "<C-CR>";
          };
          accept_diff = {
            normal = "<C-y>";
            insert = "<C-y>";
          };
          yank_diff.normal = "gmy";
          show_diff.normal = "gmd";
          show_info.normal = "gmp";
          show_context.normal = "gms";
        };
      };
    };
  };
}
