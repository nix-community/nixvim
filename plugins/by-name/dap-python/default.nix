{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    optionalString
    types
    ;
  inherit (lib.nixvim)
    defaultNullOpts
    mkNullOrOption
    toLuaObject
    ;

  dapHelpers = import ../dap/dapHelpers.nix { inherit lib; };
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "dap-python";
  package = "nvim-dap-python";
  description = "An extension for nvim-dap, providing default configurations for python.";

  maintainers = [ lib.maintainers.khaneliman ];

  extraOptions = {
    adapterPythonPath = lib.mkOption {
      default = lib.getExe (pkgs.python3.withPackages (ps: [ ps.debugpy ]));
      defaultText = lib.literalExpression ''
        lib.getExe (pkgs.python3.withPackages (ps: [ ps.debugpy ]))
      '';
      description = ''
        Path to the python interpreter.
        Path must be absolute or in $PATH and needs to have the `debugpy` package installed.
      '';
      type = types.str;
    };

    customConfigurations = mkNullOrOption (types.listOf dapHelpers.configurationType) "Custom python configurations for dap.";

    resolvePython = defaultNullOpts.mkLuaFn null ''
      Function to resolve path to python to use for program or test execution.
      By default the `VIRTUAL_ENV` and `CONDA_PREFIX` environment variables are used if present.
    '';

    testRunner = defaultNullOpts.mkLuaFn' {
      description = "The name of test runner to use by default.";
      pluginDefault = lib.literalMD ''
        The default value is dynamic and depends on `pytest.ini` or `manage.py` markers.
        If neither are found, `"unittest"` is used.
      '';
    };

    testRunners = mkNullOrOption (with lib.types; attrsOf strLuaFn) ''
      Set to register test runners.

      Built-in test runners include: `unittest`, `pytest` and `django`.

      The key is the test runner name, the value a function to generate the
      module name to run and its arguments.

      See `|dap-python.TestRunner|`.
    '';
  };

  settingsOptions = {
    console = defaultNullOpts.mkEnumFirstDefault [
      "integratedTerminal"
      "internalConsole"
      "externalTerminal"
    ] "Debugpy console.";

    includeConfigs = defaultNullOpts.mkBool true "Add default configurations.";
  };

  # Manually supplied to nvim-dap config module
  callSetup = false;
  extraConfig = cfg: {
    plugins.dap = {
      enable = true;

      extensionConfigLua =
        ''
          require("dap-python").setup("${cfg.adapterPythonPath}", ${toLuaObject cfg.settings})
        ''
        + (optionalString (cfg.testRunners != null) ''
          table.insert(require("dap-python").test_runners,
          ${toLuaObject (builtins.mapAttrs (_: lib.nixvim.mkRaw) cfg.testRunners)})
        '')
        + (optionalString (cfg.customConfigurations != null) ''
          table.insert(require("dap").configurations.python, ${toLuaObject cfg.customConfigurations})
        '')
        + (optionalString (cfg.resolvePython != null) ''
          require("dap-python").resolve_python = ${toLuaObject cfg.resolvePython}
        '')
        + (optionalString (cfg.testRunner != null) ''
          require("dap-python").test_runner = ${toLuaObject cfg.testRunner};
        '');
    };
  };

  # NOTE: Renames added in https://github.com/nix-community/nixvim/pull/2897 (2025-01-26)
  imports = [ ./deprecations.nix ];
}
