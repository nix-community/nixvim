{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "tuis";
  package = "tuis-nvim";

  description = ''
    Interactive terminal user interfaces for Neovim, built on `morph.nvim`.
    Wraps CLIs such as Docker, Kubernetes, AWS, GCP, systemd/launchd, LSP
    servers, Bitwarden, and GitHub.

    The plugin has no `setup()` function or configuration table. Call its Lua
    API directly, typically from a keymap:
    - `require('tuis').choose()`: pick a UI interactively.
    - `require('tuis').run(name)`: launch a UI by name.
    - `require('tuis').list()`: list the enabled UIs.
  '';

  maintainers = [ lib.maintainers.khaneliman ];

  callSetup = false;
  hasSettings = false;
}
