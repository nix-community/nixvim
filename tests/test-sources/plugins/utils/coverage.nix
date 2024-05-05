{
  empty = {
    plugins.coverage.enable = true;
  };

  example = {
    plugins.coverage = {
      enable = true;

      keymapsSilent = true;
      keymaps = {
        coverage = "<leader>a";
        load = "<leader>b";
        show = "<leader>c";
        hide = "<leader>d";
        toggle = "<leader>e";
        clear = "<leader>f";
        summary = "<leader>g";
      };

      autoReload = false;
      autoReloadTimeoutMs = 500;
      commands = true;
      highlights = {
        covered = {
          fg = "#B7F071";
        };
        uncovered = {
          fg = "#F07178";
        };
        partial = {
          fg = "#AA71F0";
        };
        summaryBorder = {
          link = "FloatBorder";
        };
        summaryNormal = {
          link = "NormalFloat";
        };
        summaryCursorLine = {
          link = "CursorLine";
        };
        summaryHeader = {
          style = "bold,underline";
          sp = "bg";
        };
        summaryPass = {
          link = "CoverageCovered";
        };
        summaryFail = {
          link = "CoverageUncovered";
        };
      };
      loadCoverageCb = ''
        function (ftype)
          vim.notify("Loaded " .. ftype .. " coverage")
        end
      '';
      signs = {
        covered = {
          hl = "CoverageCovered";
          text = "▎";
        };
        uncovered = {
          hl = "CoverageUncovered";
          text = "▎";
        };
        partial = {
          hl = "CoveragePartial";
          text = "▎";
        };
      };
      signGroup = "coverage";
      summary = {
        widthPercentage = 0.7;
        heightPercentage = 0.5;
        borders = {
          topleft = "╭";
          topright = "╮";
          top = "─";
          left = "│";
          right = "│";
          botleft = "╰";
          botright = "╯";
          bot = "─";
          highlight = "Normal:CoverageSummaryBorder";
        };
        minCoverage = 80;
      };
      lang = {
        python = {
          coverage_file = ".coverage";
          coverage_command = "coverage json --fail-under=0 -q -o -";
        };
        ruby = {
          coverage_file = "coverage/coverage.json";
        };
      };
      lcovFile = null;
    };
  };
}
