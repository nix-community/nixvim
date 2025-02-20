{

  empty = {
    plugins.copilot-chat.enable = true;
  };

  defaults = {
    plugins.copilot-chat = {
      enable = true;

      settings = import ./default-settings;
    };
  };

  example = {
    plugins.copilot-chat = {
      enable = false;

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
