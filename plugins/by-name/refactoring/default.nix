{
  lib,
  helpers,
  config,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin {
  name = "refactoring";
  originalName = "refactoring.nvim";
  package = "refactoring-nvim";

  maintainers = [ maintainers.MattSturgeon ];

  # TODO: introduced 2024-05-24, remove on 2024-08-24
  optionsRenamedToSettings = [
    "promptFuncReturnType"
    "promptFuncParamType"
    "printVarStatements"
    "printfStatements"
    "extractVarStatements"
  ];

  extraOptions = {
    enableTelescope = mkEnableOption "telescope integration";
  };

  extraConfig = cfg: {
    assertions = [
      {
        assertion = cfg.enableTelescope -> config.plugins.telescope.enable;
        message = ''
          Nixvim: You have enabled the `telescope` integration with refactoring-nvim.
          However, you have not enabled the `telescope` plugin itself (`plugins.telescope.enable = true`).
        '';
      }
    ];

    plugins.telescope.enabledExtensions = mkIf cfg.enableTelescope [ "refactoring" ];
  };

  settingsOptions = with lib.types; {
    prompt_func_return_type =
      helpers.defaultNullOpts.mkAttrsOf bool
        {
          go = false;
          java = false;
          cpp = false;
          c = false;
          h = false;
          hpp = false;
          cxx = false;
        }
        ''
          For certain languages like Golang, types are required for functions that return an object(s).
          Unfortunately, for some functions there is no way to automatically find their type. In those instances,
          we want to provide a way to input a type instead of inserting a placeholder value.

          Set the relevant language(s) to `true` to enable prompting for a return type, e.g:


          ```nix
            {
              go = true;
              cpp = true;
              c = true;
              java = true;
            }
          ```
        '';

    prompt_func_param_type =
      helpers.defaultNullOpts.mkAttrsOf bool
        {
          go = false;
          java = false;
          cpp = false;
          c = false;
          h = false;
          hpp = false;
          cxx = false;
        }
        ''
          For certain languages like Golang, types are required for functions parameters.
          Unfortunately, for some parameters there is no way to automatically find their type. In those instances,
          we want to provide a way to input a type instead of inserting a placeholder value.

          Set the relevant language(s) to `true` to enable prompting for parameter types, e.g:


          ```nix
            {
              go = true;
              cpp = true;
              c = true;
              java = true;
            }
        '';

    printf_statements = helpers.defaultNullOpts.mkAttrsOf (listOf (maybeRaw str)) { } ''
      In any custom printf statement, it is possible to optionally add a **max of one `%s` pattern**, which is where the debug path will go.
      For an example custom printf statement, go to [this folder][folder], select your language, and click on `multiple-statements/printf.config`.

      Note: if you have multiple custom statements, the plugin will prompt for which one should be inserted.
      If you just have one custom statement in your config, it will override the default automatically.

      Example:

      ```nix
        {
          # add a custom printf statement for cpp
          cpp = [ "std::cout << \"%s\" << std::endl;" ];
        }
      ```

      [folder]: https://github.com/ThePrimeagen/refactoring.nvim/blob/master/lua/refactoring/tests/debug/printf
    '';

    print_var_statements = helpers.defaultNullOpts.mkAttrsOf (listOf (maybeRaw str)) { } ''
      In any custom print var statement, it is possible to optionally add a **max of two `%s` patterns**, which is where the debug path and
      the actual variable reference will go, respectively. To add a literal `"%s"` to the string, escape the sequence like this: `%%s`.
      For an example custom print var statement, go to [this folder][folder], select your language, and view `multiple-statements/print_var.config`.

      Note: if you have multiple custom statements, the plugin will prompt for which one should be inserted.
      If you just have one custom statement in your config, it will override the default automatically.

      Example:

      ```nix
        {
          # add a custom print var statement for cpp
          cpp = [ "printf(\"a custom statement %%s %s\", %s)" ];
        }
      ```

      [folder]: https://github.com/ThePrimeagen/refactoring.nvim/blob/master/lua/refactoring/tests/debug/print_var
    '';

    extract_var_statements = helpers.defaultNullOpts.mkAttrsOf str { } ''
      When performing an `extract_var` refactor operation, you can custom how the new variable would be declared by setting configuration
      like the below example.

      Example:

      ```nix
        {
          # overriding extract statement for go
          go = "%s := %s // poggers";
        }
      ```
    '';

    show_success_message = helpers.defaultNullOpts.mkBool false ''
      Shows a message with information about the refactor on success. Such as:

      ```
        [Refactor] Inlined 3 variable occurrences
      ```
    '';
  };
}
