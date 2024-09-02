{ lib, pkgs, ... }:
{
  empty = {
    plugins.gitgutter.enable = true;
  };

  grep-command =
    { config, ... }:
    {
      plugins.gitgutter = {
        enable = true;
        grep = {
          package = pkgs.gnugrep;
          command = "";
        };
      };
      assertions = [
        {
          assertion =
            config.extraPackages != [ ] && lib.any (x: x.pname or null == "gnugrep") config.extraPackages;
          message = "gnugrep wasn't found when it was expected";
        }
      ];
    };

  no-packages =
    { config, ... }:
    {
      globals.gitgutter_git_executable = lib.getExe pkgs.git;
      plugins.gitgutter = {
        enable = true;
        gitPackage = null;
      };
      assertions = [
        {
          assertion = lib.all (x: x.pname or null != "git") config.extraPackages;
          message = "A git package found in extraPackages when it wasn't expected";
        }
      ];
    };
}
