{
  empty = {
    plugins.refactoring.enable = true;
  };

  example = {
    plugins.refactoring = {
      enable = true;

      settings = {
        prompt_func_return_type = {
          go = true;
        };
        prompt_func_param_type = {
          go = true;
        };
        printf_statements = {
          cpp = [ "std::cout << \"%s\" << std::endl;" ];
        };
        print_var_statements = {
          cpp = [ "printf(\"a custom statement %%s %s\", %s)" ];
        };
        extract_var_statements = {
          go = "%s := %s // poggers";
        };
        show_success_message = true;
      };
    };
  };

  withTelescope = {
    plugins.telescope.enable = true;

    plugins.refactoring = {
      enable = true;
      enableTelescope = true;
    };

    plugins.web-devicons.enable = true;
  };

  defaults = {
    plugins.refactoring = {
      enable = true;

      settings = {
        prompt_func_return_type = {
          go = false;
          java = false;
          cpp = false;
          c = false;
          h = false;
          hpp = false;
          cxx = false;
        };
        prompt_func_param_type = {
          go = false;
          java = false;
          cpp = false;
          c = false;
          h = false;
          hpp = false;
          cxx = false;
        };
        printf_statements = { };
        print_var_statements = { };
        extract_var_statements = { };
        show_success_message = false;
      };
    };
  };
}
