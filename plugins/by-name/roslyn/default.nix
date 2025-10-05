{ config, lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "roslyn";
  package = "roslyn-nvim";

  dependencies = [
    "roslyn_ls"
  ];

  maintainers = [ lib.maintainers.khaneliman ];

  extraConfig = {
    warnings = lib.nixvim.mkWarnings "plugins.roslyn" {
      when = config.lsp.servers.roslyn_ls.enable;

      message = ''
        You have enabled both `lsp.servers.roslyn_ls` and `plugins.roslyn`.
        This causes duplicate lsps to attach to the buffer. It is recommended to disable one.
      '';
    };
  };

  settingsExample = {
    broad_search = true;
    lock_target = true;
    silent = true;
  };
}
