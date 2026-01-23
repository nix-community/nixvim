{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "overseer";
  package = "overseer-nvim";
  description = "A task runner and job management plugin for Neovim.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsOptions = {
    strategy =
      defaultNullOpts.mkNullableWithRaw (with types; either str (attrsOf anything)) "terminal"
        ''
          Default task strategy.
        '';

    templates = defaultNullOpts.mkListOf types.str [ "builtin" ] ''
      Template modules to load.
    '';

    auto_detect_success_color = defaultNullOpts.mkBool true ''
      When true, tries to detect a green color from your colorscheme to use for success highlight.
    '';

    dap = defaultNullOpts.mkBool true ''
      Whether to patch nvim-dap to support preLaunchTask and postDebugTask
    '';

    task_list =
      defaultNullOpts.mkAttrsOf types.anything
        {
          default_detail = 1;
          max_width = [
            100
            0.2
          ];
          min_width = [
            40
            0.1
          ];
          width = null;
          max_height = [
            20
            0.1
          ];
          min_height = 8;
          height = null;
          separator = "────────────────────────────────────────";
          direction = "bottom";
          bindings = {
            "?" = "ShowHelp";
            "g?" = "ShowHelp";
            "<CR>" = "RunAction";
            "<C-e>" = "Edit";
            "o" = "Open";
            "<C-v>" = "OpenVsplit";
            "<C-s>" = "OpenSplit";
            "<C-f>" = "OpenFloat";
            "<C-q>" = "OpenQuickFix";
            "p" = "TogglePreview";
            "<C-l>" = "IncreaseDetail";
            "<C-h>" = "DecreaseDetail";
            "L" = "IncreaseAllDetail";
            "H" = "DecreaseAllDetail";
            "[" = "DecreaseWidth";
            "]" = "IncreaseWidth";
            "{" = "PrevTask";
            "}" = "NextTask";
            "<C-k>" = "ScrollOutputUp";
            "<C-j>" = "ScrollOutputDown";
            "q" = "Close";
          };
        }
        "The task list displays all tasks that have been created. It shows the task status, name, and a summary of the task output.";

    task_editor = {
      bindings =
        defaultNullOpts.mkAttrsOf types.anything
          {
            i = {
              "<CR>" = "NextOrSubmit";
              "<C-s>" = "Submit";
              "<Tab>" = "Next";
              "<S-Tab>" = "Prev";
              "<C-c>" = "Cancel";
            };
            n = {
              "<CR>" = "NextOrSubmit";
              "<C-s>" = "Submit";
              "<Tab>" = "Next";
              "<S-Tab>" = "Prev";
              "q" = "Cancel";
              "?" = "ShowHelp";
            };
          }
          ''
            Set keymap to false to remove default behavior.
            You can add custom keymaps here as well (anything vim.keymap.set accepts).
          '';
    };

    task_launcher = {
      bindings =
        defaultNullOpts.mkAttrsOf types.anything
          {
            i = {
              "<C-s>" = "Submit";
              "<C-c>" = "Cancel";
            };
            n = {
              "<CR>" = "Submit";
              "<C-s>" = "Submit";
              "q" = "Cancel";
              "?" = "ShowHelp";
            };
          }
          ''
            Set keymap to false to remove default behavior.
            You can add custom keymaps here as well (anything vim.keymap.set accepts).
          '';
    };

    actions = defaultNullOpts.mkAttrsOf types.anything { } ''
      They are simply a custom function that will do something to or with a task.
      Please refer to the documentation for details of available builtin actions.
    '';
  };
}
