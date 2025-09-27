{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-git";
  moduleName = "mini.git";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  dependencies = [ "git" ];

  settingsExample = {
    job.timeout = 20000;
    command.split = "horizontal";
  };
}
