{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-git";
  moduleName = "mini.git";
  packPathName = "mini.git";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  dependencies = [ "git" ];

  settingsOptions = {
    job = {
      git_executable = defaultNullOpts.mkStr "git" ''
        Path to Git executable.
      '';

      timeout = defaultNullOpts.mkNum 30000 ''
        Timeout (in ms) for each job before force quit.
      '';
    };

    command = {
      split = defaultNullOpts.mkEnum [ "horizontal" "vertical" "tab" "auto" ] "auto" ''
        Default split direction.
      '';
    };
  };

  settingsExample = {
    job.timeout = 20000;
    command.split = "horizontal";
  };
}
