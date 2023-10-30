{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  helpers = import ../helpers.nix {inherit lib;};
in {
  options.plugins.refactoring =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "refactoring.nvim";

      package = helpers.mkPackageOption "refactoring.nvim" pkgs.vimPlugins.refactoring-nvim;

      promptFuncReturnType =
        helpers.defaultNullOpts.mkNullable
        (
          with types;
            attrsOf bool
        )
        ''
          {
            "go" = "false";
            "java" = "false";
            "cpp" = "false";
            "c" = "false";
            "h" = "false";
            "hpp" = "false";
            "cxx" = "false";
          }
        ''
        ''
          For certain languages like Golang, types are required for functions that return an object(s) and parameters of functions. Unfortunately, for some parameters and functions there is no way to automatically find their type. In those instances, we want to provide a way to input a type instead of inserting a placeholder value.
        '';

      promptFuncParamType =
        helpers.defaultNullOpts.mkNullable
        (
          with types;
            attrsOf bool
        )
        ''
          {
            "go" = "false";
            "java" = "false";
            "cpp" = "false";
            "c" = "false";
            "h" = "false";
            "hpp" = "false";
            "cxx" = "false";
          }
        ''
        ''
          For certain languages like Golang, types are required for functions that return an object(s) and parameters of functions. Unfortunately, for some parameters and functions there is no way to automatically find their type. In those instances, we want to provide a way to input a type instead of inserting a placeholder value.
        '';

      printVarStatements =
        helpers.defaultNullOpts.mkNullable
        (
          with types;
            attrsOf listof str
        )
        ''
          {
            "go" = [];
            "java" = [];
            "cpp" = [];
            "c" = [];
            "h" = [];
            "hpp" = [];
            "cxx" = [];
          }
        ''
        ''
          In any custom print var statement, it is possible to optionally add a max of two %s patterns, which is where the debug path and the actual variable reference will go, respectively. To add a literal "%s" to the string, escape the sequence like this: %%s. For an example custom print var statement, go to this folder, select your language, and view multiple-statements/print_var.config.

          Note: for either of these functions, if you have multiple custom statements, the plugin will prompt for which one should be inserted. If you just have one custom statement in your config, it will override the default automatically.

          Example:
          	 cpp = {
          			'printf("a custom statement %%s %s", %s)'
          	}
        '';

      printfStatements =
        helpers.defaultNullOpts.mkNullable
        (
          with types;
            attrsOf listof str
        )
        ''
          {
            "go" = [];
            "java" = [];
            "cpp" = [];
            "c" = [];
            "h" = [];
            "hpp" = [];
            "cxx" = [];
          }
        ''
        ''
          In any custom printf statement, it is possible to optionally add a max of one %s pattern, which is where the debug path will go. For an example custom printf statement, go to this folder, select your language, and click on multiple-statements/printf.config.

          Example:
          	cpp = {
          			'std::cout << "%s" << std::endl;'
          	}
        '';
    };

  config = let
    cfg = config.plugins.refactoring;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = let
        opts = {
          inherit (cfg);
          prompt_func_return_type = promptFuncReturnType;
          prompt_func_param_type = promptFuncParamType;
        };
      in ''
        require('refactoring').setup(${helpers.toLuaObject opts})
      '';
    };
}
