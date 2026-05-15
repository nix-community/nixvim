{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "jj";
  moduleName = "jj";
  package = "jj-nvim";
  description = "Drive Jujutsu (jj) VCS from Neovim like a pro";

  maintainers = [ lib.maintainers.sportshead ];

  dependencies = [ "jujutsu" ];

  settingsExample = {
    picker.snacks = { };

    diff = {
      backend = "codediff";
    };

    cmd = {
      describe.editor = {
        type = "buffer";
      };
    };
  };
}
