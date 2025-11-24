{ lib }:
{
  empty = {
    plugins.copilot-lua.enable = true;
    plugins.sidekick.enable = true;
  };

  defaults = {
    plugins.copilot-lua.enable = true;
    plugins.sidekick = {
      enable = true;
      settings = {
        jump = {
          jumplist = true;
        };
        signs = {
          enabled = true;
          icon = " ";
        };
        nes = {
          enabled.__raw = ''
            function(buf)
              return vim.g.sidekick_nes ~= false and vim.b.sidekick_nes ~= false
            end'';
          debounce = 100;
          trigger = {
            events = [
              "InsertLeave"
              "TextChanged"
              "User SidekickNesDone"
            ];
          };
          clear = {
            events = [
              "TextChangedI"
              "BufWritePre"
              "InsertEnter"
            ];
            esc = true;
          };
          diff = {
            inline = "words";
          };
        };
        cli = {
          watch = true;
          win = {
            config = lib.nixvim.mkRaw "function(terminal) end";
            wo.__empty = { };
            bo.__empty = { };
            layout = "right";
            float = {
              width = 0.9;
              height = 0.9;
            };
            split = {
              width = 80;
              height = 20;
            };
            keys = {
              stopinsert = [
                "<esc><esc>"
                "stopinsert"
                { mode = "t"; }
              ];
              hide_n = [
                "q"
                "hide"
                { mode = "n"; }
              ];
              hide_t = [
                "<c-q>"
                "hide"
              ];
              win_p = [
                "<c-w>p"
                "blur"
              ];
              blur = [
                "<c-o>"
                "blur"
              ];
              prompt = [
                "<c-p>"
                "prompt"
              ];
            };
          };
        };
        mux = {
          backend = "zellij";
          enabled = false;
        };
        tools = {
          aider = {
            cmd = [ "aider" ];
            url = "https://github.com/Aider-AI/aider";
          };
          amazon_q = {
            cmd = [ "q" ];
            url = "https://github.com/aws/amazon-q-developer-cli";
          };
          claude = {
            cmd = [ "claude" ];
            url = "https://github.com/anthropics/claude-code";
          };
          codex = {
            cmd = [
              "codex"
              "--search"
            ];
            url = "https://github.com/openai/codex";
          };
          copilot = {
            cmd = [
              "copilot"
              "--banner"
            ];
            url = "https://github.com/github/copilot-cli";
          };
          cursor = {
            cmd = [ "cursor-agent" ];
            url = "https://cursor.com/cli";
          };
          gemini = {
            cmd = [ "gemini" ];
            url = "https://github.com/google-gemini/gemini-cli";
          };
          grok = {
            cmd = [ "grok" ];
            url = "https://github.com/superagent-ai/grok-cli";
          };
          opencode = {
            cmd = [ "opencode" ];
            url = "https://github.com/sst/opencode";
          };
          qwen = {
            cmd = [ "qwen" ];
            url = "https://github.com/QwenLM/qwen-code";
          };
        };
        prompts = {
          explain = "Explain this code";
          diagnostics = {
            msg = "What do the diagnostics in this file mean?";
            diagnostics = true;
          };
          diagnostics_all = {
            msg = "Can you help me fix these issues?";
            diagnostics = {
              all = true;
            };
          };
          fix = {
            msg = "Can you fix the issues in this code?";
            diagnostics = true;
          };
          review = {
            msg = "Can you review this code for any issues or improvements?";
            diagnostics = true;
          };
          optimize = "How can this code be optimized?";
          tests = "Can you write tests for this code?";
          file = {
            location = {
              row = false;
              col = false;
            };
            position.__empty = { };
          };
        };
        debug = false;
      };
    };
  };
}
