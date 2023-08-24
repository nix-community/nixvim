{
  empty = {
    plugins.efmls-configs.enable = true;
  };

  example = {
    extraConfigLuaPre = ''
      local efm_fs = require('efmls-configs.fs')
      local djlint_fmt = {
        formatCommand = string.format('%s --reformat ''${INPUT} -', efm_fs.executable('djlint')),
        formatStdin = true,
      }
    '';

    plugins.efmls-configs = {
      enable = true;

      setup = {
        # Setup for all languages
        all = {
          linter = "vale";
        };

        # Only accepts known tools, or raw strings
        html = {
          formatter = ["prettier" {__raw = "djlint_fmt";}];
        };

        # Unknown filetype, accepts anything
        htmldjango = {
          formatter = [{__raw = "djlint_fmt";}];
          linter = "djlint";
        };
      };
    };
  };
}
