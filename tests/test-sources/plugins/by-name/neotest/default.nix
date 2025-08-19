{
  example = {
    plugins.neotest.enable = true;
  };

  all-adapters = {
    plugins = {
      treesitter.enable = true;
      neotest = {
        enable = true;

        adapters = {
          bash.enable = true;
          ctest.enable = true;
          dart.enable = true;
          deno.enable = true;
          dotnet.enable = true;
          elixir.enable = true;
          foundry.enable = true;
          go.enable = true;
          golang.enable = true;
          gradle.enable = true;
          # We cannot test neotest-gtest as it tries to create file in the upper directory
          # https://github.com/alfaix/neotest-gtest/blob/6e794ac91f4c347e2ea5ddeb23d594f8fc64f2a8/lua/neotest-gtest/utils.lua#L10-L16
          gtest.enable = false;
          hardhat.enable = true;
          haskell.enable = true;
          java.enable = true;
          jest.enable = true;
          minitest.enable = true;
          pest.enable = true;
          phpunit.enable = true;
          playwright.enable = true;
          plenary.enable = true;
          python.enable = true;
          rspec.enable = true;
          rust.enable = true;
          scala.enable = true;
          testthat.enable = true;
          vitest.enable = true;
          zig.enable = true;
        };
      };
    };
  };

  defaults = {
    plugins.neotest = {
      enable = true;

      adapters = { };
      settings = {
        discovery = {
          enabled = true;
          concurrent = 0;
          filter_dir = null;
        };
        running = {
          concurrent = true;
        };
        default_strategy = "integrated";
        log_level = "warn";
        consumers = { };
        icons = {
          child_indent = "│";
          child_prefix = "├";
          collapsed = "─";
          expanded = "╮";
          failed = "";
          final_child_indent = " ";
          final_child_prefix = "╰";
          non_collapsible = "─";
          passed = "";
          running = "";
          running_animated = [
            "/"
            "|"
            "\\"
            "-"
            "/"
            "|"
            "\\"
            "-"
          ];
          skipped = "";
          unknown = "";
          watching = "";
        };
        highlights = {
          adapter_name = "NeotestAdapterName";
          border = "NeotestBorder";
          dir = "NeotestDir";
          expand_marker = "NeotestExpandMarker";
          failed = "NeotestFailed";
          file = "NeotestFile";
          focused = "NeotestFocused";
          indent = "NeotestIndent";
          marked = "NeotestMarked";
          namespace = "NeotestNamespace";
          passed = "NeotestPassed";
          running = "NeotestRunning";
          select_win = "NeotestWinSelect";
          skipped = "NeotestSkipped";
          target = "NeotestTarget";
          test = "NeotestTest";
          unknown = "NeotestUnknown";
          watching = "NeotestWatching";
        };
        floating = {
          border = "rounded";
          max_height = 0.6;
          max_width = 0.6;
          options = { };
        };
        strategies = {
          integrated = {
            height = 40;
            width = 120;
          };
        };
        summary = {
          enabled = true;
          animated = true;
          follow = true;
          expandErrors = true;
          mappings = {
            attach = "a";
            clear_marked = "M";
            clear_target = "T";
            debug = "d";
            debug_marked = "D";
            expand = [
              "<CR>"
              "<2-LeftMouse>"
            ];
            expand_all = "e";
            jumpto = "i";
            mark = "m";
            next_failed = "J";
            output = "o";
            prev_failed = "K";
            run = "r";
            run_marked = "R";
            short = "O";
            stop = "u";
            target = "t";
            watch = "w";
          };
          open = "botright vsplit | vertical resize 50";
        };
        output = {
          enabled = true;
          open_on_run = "short";
        };
        output_panel = {
          enabled = true;
          open = "botright split | resize 15";
        };
        quickfix = {
          enabled = true;
          open = false;
        };
        status = {
          enabled = true;
          virtual_text = false;
          signs = true;
        };
        state = {
          enabled = true;
        };
        watch = {
          enabled = true;
          symbol_queries = null;
          filter_path = null;
        };
        diagnostic = {
          enabled = true;
          severity = "error";
        };
      };
    };
  };
}
