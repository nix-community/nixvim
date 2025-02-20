# https://github.com/CopilotC-Nvim/CopilotChat.nvim/blob/main/lua/CopilotChat/config.lua
{
  system_prompt = "require('CopilotChat.config.prompts').COPILOT_INSTRUCTIONS";
  model = "gpt-4-o";
  agent = "none";
  context = null;
  sticky = null;

  temperature = 0.1;
  headless = false;
  callback = null;

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
    row = null;
    col = null;
    title = "Copilot Chat";
    footer = null;
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
  proxy = null;
  allow_insecure = false;

  chat_autocomplete = true;

  log_path.__raw = "vim.fn.stdpath('state') .. '/CopilotChat.log'";
  history_path.__raw = "vim.fn.stdpath('data') .. '/copilotchat_history'";

  question_header = "## User ";
  answer_header = "## Copilot ";
  error_header = "## Error ";
  separator = "───";

  providers = import ./providers.nix;
  contexts = import ./contexts.nix;
  prompts = { }; # TODO
  mappings = import ./mappings.nix;

  __prompts = {
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

  __mappings = {
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
}
