{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "competitest";
  originalName = "competitest.nvim";
  package = "competitest-nvim";

  maintainers = [ lib.maintainers.svl ];

  settingsOptions = {
    local_config_file_name = defaultNullOpts.mkStr ".competitest.lua" ''
      You can use a different configuration for every different folder.
      See [local configuration](https://github.com/xeluxee/competitest.nvim?tab=readme-ov-file#local-configuration).
    '';

    save_current_file = defaultNullOpts.mkBool true ''
      If true save current file before running testcases.
    '';

    save_all_files = defaultNullOpts.mkBool false ''
      If true save all the opened files before running testcases.
    '';

    compile_directory = defaultNullOpts.mkStr "." ''
      Execution directory of compiler, relatively to current file's path.
    '';

    compile_command =
      lib.nixvim.mkNullOrOption
        (
          with types;
          attrsOf (submodule {
            options = {
              exec = lib.mkOption {
                type = str;
                description = "Command to execute";
              };
              args = defaultNullOpts.mkListOf types.str [ ] ''
                Arguments to the command.
              '';
            };
          })
        )
        ''
          Configure the command used to compile code for every different language, see
          [here](https://github.com/xeluxee/competitest.nvim?tab=readme-ov-file#customize-compile-and-run-commands).
        '';

    running_directory = defaultNullOpts.mkStr "." ''
      Execution directory of your solutions, relatively to current file's path.
    '';

    run_command =
      lib.nixvim.mkNullOrOption
        (
          with types;
          attrsOf (submodule {
            options = {
              exec = lib.mkOption {
                type = str;
                description = "Command to execute.";
              };
              args = defaultNullOpts.mkListOf types.str [ ] ''
                Arguments to the command.
              '';
            };
          })
        )
        ''
          Configure the command used to run your solutions for every different language, see
          [here](https://github.com/xeluxee/competitest.nvim?tab=readme-ov-file#customize-compile-and-run-commands).
        '';

    multiple_testing = defaultNullOpts.mkInt (-1) ''
      How many testcases to run at the same time
      * Set it to -1 to make the most of the amount of available parallelism.
        Often the number of testcases run at the same time coincides with the number of CPUs.
      * Set it to 0 if you want to run all the testcases together.
      * Set it to any positive integer to run that number of testcases contemporarily.
    '';

    maximum_time = defaultNullOpts.mkInt 5000 ''
      Maximum time, in milliseconds, given to processes.
      If it's exceeded process will be killed.
    '';

    output_compare_method =
      defaultNullOpts.mkNullable
        (
          with types;
          either (enum [
            "exact"
            "squish"
          ]) rawLua
        )
        "squish"
        ''
          How given output (stdout) and expected output should be compared.
          It can be a string, representing the method to use, or a custom function.
          Available options follows:
          * "exact": character by character comparison.
          * "squish": compare stripping extra white spaces and newlines.
          * custom function: you can use a function accepting two arguments, two strings
            representing output and expected output. It should return true if the given
            output is acceptable, false otherwise.
        '';

    view_output_diff = defaultNullOpts.mkBool false ''
      View diff between actual output and expected output in their respective windows.
    '';

    testcases_directory = defaultNullOpts.mkStr "." ''
      Where testcases files are located, relatively to current file's path.
    '';

    testcases_use_single_file = defaultNullOpts.mkBool false ''
      If true testcases will be stored in a single file instead of using multiple text files.
      If you want to change the way already existing testcases are stored see
      [conversion](https://github.com/xeluxee/competitest.nvim?tab=readme-ov-file#convert-testcases).
    '';

    testcases_auto_detect_storage = defaultNullOpts.mkBool true ''
      If true testcases storage method will be detected automatically.
      When both text files and single file are available, testcases will be loaded according
      to the preference specified in `testcases_use_single_file`.
    '';

    testcases_single_file_format = defaultNullOpts.mkStr "$(FNOEXT).testcases" ''
      String representing how single testcases files should be named
      (see [file-format modifiers](https://github.com/xeluxee/competitest.nvim?tab=readme-ov-file#file-format-modifiers)).
    '';

    testcases_input_file_format = defaultNullOpts.mkStr "$(FNOEXT)_input$(TCNUM).txt" ''
      String representing how testcases input files should be named
      (see [file-format modifiers](https://github.com/xeluxee/competitest.nvim?tab=readme-ov-file#file-format-modifiers)).
    '';

    testcases_output_file_format = defaultNullOpts.mkStr "$(FNOEXT)_output$(TCNUM).txt" ''
      String representing how testcases output files should be named
      (see [file-format modifiers](https://github.com/xeluxee/competitest.nvim?tab=readme-ov-file#file-format-modifiers)).
    '';

    companion_port = defaultNullOpts.mkInt 27121 ''
      Competitive companion port number.
    '';

    receive_print_message = defaultNullOpts.mkBool true ''
      If true notify user that plugin is ready to receive testcases, problems and
      contests or that they have just been received.
    '';

    template_file =
      lib.nixvim.mkNullOrOption
        (
          with types;
          oneOf [
            (enum [ false ])
            str
            (attrsOf str)
          ]
        )
        ''
          Templates to use when creating source files for received problems or contests.
          Can be one of the following:
          * false: do not use templates.
          * string with
            [file-format modifiers](https://github.com/xeluxee/competitest.nvim?tab=readme-ov-file#file-format-modifiers):
            useful when templates for different file types have a regular file naming.
          * table with paths: table associating file extension to template file.
        '';

    evaluate_template_modifiers = defaultNullOpts.mkBool false ''
      Whether to evaluate
      [receive modifiers](https://github.com/xeluxee/competitest.nvim?tab=readme-ov-file#receive-modifiers)
      inside a template file or not.
    '';

    date_format = defaultNullOpts.mkStr "%c" ''
      String used to format `$(DATE)` modifier (see
      [receive modifiers](https://github.com/xeluxee/competitest.nvim?tab=readme-ov-file#receive-modifiers)).
      The string should follow the formatting rules as per Lua's
      `[os.date](https://www.lua.org/pil/22.1.html)` function.
    '';

    received_files_extension = defaultNullOpts.mkStr "cpp" ''
      Default file extension for received problems.
    '';

    received_problems_path = defaultNullOpts.mkStr "$(CWD)/$(PROBLEM).$(FEXT)" ''
      Path where received problems (not contests) are stored.
      Can be one of the following:
      * string with receive modifiers.
      * function: function accepting two arguments, a table with task details and
        a string with preferred file extension. It should return the absolute path
        to store received problem.
    '';

    received_problems_prompt_path = defaultNullOpts.mkBool true ''
      Whether to ask user confirmation about path where the received problem is stored or not.
    '';

    received_contests_directory = defaultNullOpts.mkStr "$(CWD)" ''
      Directory where received contests are stored. It can be string or function,
      exactly as `received_problems_path`.
    '';

    received_contests_problems_path = defaultNullOpts.mkStr "$(PROBLEM).$(FEXT)" ''
      Relative path from contest root directory, each problem of a received contest
      is stored following this option. It can be string or function, exactly as `received_problems_path`.
    '';

    received_contests_prompt_directory = defaultNullOpts.mkBool true ''
      Whether to ask user confirmation about the directory where received contests are stored or not.
    '';

    received_contests_prompt_extension = defaultNullOpts.mkBool true ''
      Whether to ask user confirmation about what file extension to use when receiving a contest or not.
    '';

    open_received_problems = defaultNullOpts.mkBool true ''
      Automatically open source files when receiving a single problem.
    '';

    open_received_contests = defaultNullOpts.mkBool true ''
      Automatically open source files when receiving a contest.
    '';

    replace_received_testcases = defaultNullOpts.mkBool false ''
      This option applies when receiving only testcases. If true replace existing
      testcases with received ones, otherwise ask user what to do.
    '';
  };

  settingsExample = {
    received_problems_path = "$(HOME)/cp/$(JUDGE)/$(CONTEST)/$(PROBLEM)/main.$(FEXT)";
    template_file = "$(HOME)/cp/templates/template.$(FEXT)";
    evaluate_template_modifiers = true;
    compile_command = {
      cpp = {
        exec = "g++";
        args = [
          "-DLOCAL"
          "$(FNAME)"
          "-o"
          "$(FNOEXT)"
          "-Wall"
          "-Wextra"
        ];
      };
    };
  };
}
