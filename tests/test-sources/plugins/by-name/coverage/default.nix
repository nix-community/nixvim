{ lib, ... }:
{
  empty = {
    plugins.coverage.enable = true;
  };

  example = {
    plugins.coverage = {
      enable = true;

      settings = {
        commands = true;
        autoReload = false;
        autoReloadTimeoutMs = 500;
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
        loadCoverageCb = lib.nixvim.mkRaw ''
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
  };
}
