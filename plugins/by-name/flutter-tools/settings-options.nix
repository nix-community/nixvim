lib:
let
  inherit (lib.nixvim) defaultNullOpts;
in
{
  debugger = {
    register_configurations = defaultNullOpts.mkRaw' {
      pluginDefault = null;
      example = ''
        function(paths)
          require("dap").configurations.dart = {
            --put here config that you would find in .vscode/launch.json
          }
          -- If you want to load .vscode launch.json automatically run the following:
          -- require("dap.ext.vscode").load_launchjs()
        end
      '';
      description = ''
        Function to register configurations.
      '';
    };
  };

  dev_log = {
    filter = defaultNullOpts.mkRaw null ''
      Optional callback to filter the log.

      Takes a `log_line` as string argument; returns a boolean or `nil`.

      The `log_line` is only added to the output if the function returns `true`.
    '';
  };
}
