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
        auto_reload = false;
        auto_reload_timeout_ms = 500;
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
          summary_border = {
            link = "FloatBorder";
          };
          summary_normal = {
            link = "NormalFloat";
          };
          summary_cursorLine = {
            link = "CursorLine";
          };
          summary_header = {
            style = "bold,underline";
            sp = "bg";
          };
          summary_pass = {
            link = "CoverageCovered";
          };
          summary_fail = {
            link = "CoverageUncovered";
          };
        };
        load_coverage_cb = lib.nixvim.mkRaw ''
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
        sign_group = "coverage";
        summary = {
          width_percentage = 0.7;
          height_percentage = 0.5;
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
          min_coverage = 80;
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
        lcov_file = null;
      };
    };
  };
}
