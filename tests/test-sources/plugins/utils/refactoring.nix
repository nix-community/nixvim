{
  empty = {
    plugins.refactoring.enable = true;
  };

  defaults = {
    plugins.refactoring = {
      enable = true;
      promptFuncReturnType = {
        go = true;
      };
      promptFuncParamType = {
        go = true;
      };
      printVarStatements = {
        cpp = ["printf(\"a custom statement %%s %s\", %s)"];
      };
      printfStatements = {
        cpp = ["std::cout << \"%s\" << std::endl;"];
      };
      extractVarStatements = {
        go = "%s := %s // poggers";
      };
    };
  };
}
