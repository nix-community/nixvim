{ lib }:
{
  empty = {
    plugins.leetcode.enable = true;
  };

  example = {
    plugins.leetcode = {
      enable = true;

      settings = {
        lang = "rust";
        storage = {
          home = "~/projects/leetcode";
          cache = lib.nixvim.mkRaw "vim.fn.stdpath('cache') .. '/leetcode'";
        };
      };
    };
  };

  defaults = {
    plugins.leetcode = {
      enable = true;

      settings = {
        arg = "leetcode.nvim";
        lang = "cpp";
        cn = {
          enabled = false;
          translator = true;
          translate_problems = true;
        };
        storage = {
          home = lib.nixvim.mkRaw "vim.fn.stdpath('data') .. '/leetcode'";
          cache = lib.nixvim.mkRaw "vim.fn.stdpath('cache') .. '/leetcode'";
        };
        plugins = {
          non_standalone = false;
        };
        logging = true;
        injector.__empty = { };
        cache = {
          update_interval = 60 * 60 * 24 * 7;
        };
        editor = {
          reset_previous_code = true;
          fold_imports = true;
        };
        console = {
          open_on_runcode = true;
          dir = "row";
          size = {
            width = "90%";
            height = "75%";
          };
          result = {
            size = "60%";
          };
          testcase = {
            virt_text = true;
            size = "40%";
          };
        };
        description = {
          position = "left";
          width = "40%";
          show_stats = true;
        };
        picker = {
          provider.__raw = "nil";
        };
        hooks = {
          "enter" = { };
          "question_enter" = { };
          "leave" = { };
        };
        keys = {
          toggle = "q";
          confirm = "<CR>";
          reset_testcases = "r";
          use_testcase = "U";
          focus_testcases = "H";
          focus_result = "L";
        };
        theme.__empty = { };
        image_support = false;
      };
    };
  };
}
