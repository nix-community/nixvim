{

  empty = {
    plugins.copilot-chat.enable = true;
  };

  defaults = {
    plugins.copilot-chat = {
      enable = true;

      # https://github.com/CopilotC-Nvim/CopilotChat.nvim/blob/main/lua/CopilotChat/config.lua
      settings = {
        system_prompt = "require('CopilotChat.config.prompts').COPILOT_INSTRUCTIONS";
        model = "gpt-4-o";
        agent = "none";
        context.__raw = "nil";
        sticky.__raw = "nil";

        temperature = 0.1;
        headless = false;
        callback.__raw = "nil";

        selection.__raw = ''
          function(source)
            local select = require('CopilotChat.select')
            return select.visual(source) or select.buffer(source)
          end
        '';

        window = {
          layout = "vertical";
          width = 0.5;
          height = 0.5;
          relative = "editor";
          border = "single";
          row.__raw = "nil";
          col.__raw = "nil";
          title = "Copilot Chat";
          footer.__raw = "nil";
          zindex = 1;
        };

        show_help = true;
        show_folds = true;
        highlight_selection = true;
        highlight_headers = true;
        auto_follow_cursor = true;
        auto_insert_mode = false;
        insert_at_end = false;

        debug = false;
        log_level = "info";
        proxy.__raw = "nil";
        allow_insecure = false;

        chat_autocomplete = true;

        log_path.__raw = "vim.fn.stdpath('state') .. '/CopilotChat.log'";
        history_path.__raw = "vim.fn.stdpath('data') .. '/copilotchat_history'";

        question_header = "## User ";
        answer_header = "## Copilot ";
        error_header = "## Error ";
        separator = "───";
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
