{ lib }:
{
  empty =
    { config, ... }:
    {
      plugins.justice.enable = true;

      assertions = [
        {
          assertion = !(lib.hasInfix "require('justice').setup(" config.content);
          message = "Empty justice config should not emit a setup call.";
        }
      ];
    };

  defaults =
    { config, ... }:
    {
      plugins.justice = {
        enable = true;
        settings = {
          recipeModes = {
            streaming = {
              name = [ "download" ];
              comment = [
                "streaming"
                "curl"
              ];
            };
            terminal = {
              name = [ ];
              comment = [
                "input"
                "terminal"
                "fzf"
              ];
            };
            quickfix = {
              name = [ "%-qf$" ];
              comment = [ "quickfix" ];
            };
            ignore = {
              name = [ ];
              comment = [ ];
            };
          };
          window = {
            border = lib.nixvim.mkRaw ''
              (function()
                local ok, winborder = pcall(function()
                  return vim.o.winborder
                end)
                if not ok or winborder == "" or winborder == "none" then
                  return "rounded"
                end
                return winborder
              end)()
            '';
            recipeCommentMaxLen = 30;
            keymaps = {
              next = "<Tab>";
              prev = "<S-Tab>";
              runRecipeUnderCursor = "<CR>";
              runFirstRecipe = "1";
              closeWin = [
                "q"
                "<Esc>"
              ];
              showRecipe = "<Space>";
              showVariables = "?";
              dontUseForQuickKey = [
                "j"
                "k"
                "-"
                "_"
              ];
            };
            highlightGroups = {
              quickKey = "Keyword";
              icons = "Function";
            };
            icons = {
              just = "󰖷";
              streaming = "ﲋ";
              quickfix = "";
              terminal = "";
              ignore = "󰈉";
              recipeParameters = "󰘎";
            };
          };
          terminal.height = 10;
        };
      };

      assertions = [
        {
          assertion = lib.hasInfix "require('justice').setup(" config.content;
          message = "Justice defaults should emit a setup call.";
        }
      ];
    };

  example =
    { config, ... }:
    {
      plugins.justice = {
        enable = true;
        settings = {
          window = {
            border = "single";
            recipeCommentMaxLen = 0;
          };
          recipeModes.streaming.comment = [
            "streaming"
            "curl"
            "watch"
          ];
          terminal.height = 15;
        };
      };

      assertions = [
        {
          assertion = lib.hasInfix "require('justice').setup(" config.content;
          message = "Configured justice should emit a setup call.";
        }
      ];
    };
}
