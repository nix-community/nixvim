{
  empty = {
    plugins.overseer.enable = true;
  };

  defaults = {
    plugins.overseer = {
      enable = true;

      settings = {
        strategy = "terminal";
        templates = [ "builtin" ];
        auto_detect_success_color = true;

        dap = true;

        #   -- Configure the task list
        task_list = {
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

          direction =

            [
              "left"
              "right"
              "bottom"
            ];

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
        };
      };
    };
  };
}
