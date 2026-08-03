{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "tuis";
  package = "tuis-nvim";

  description = ''
    A collection of interactive terminal user interfaces for Neovim, built on top of
    `morph.nvim`. Provides rich, interactive UIs for various CLIs (Docker, Kubernetes,
    AWS, GCP, systemd/launchd, LSP servers, Bitwarden, GitHub, and more).

    The plugin has no `setup()` function or configuration table; it is used by calling
    its Lua API directly, typically bound to a keymap:
    - `require('tuis').choose()`: pick a UI interactively.
    - `require('tuis').run(name)`: launch a specific UI by name.
    - `require('tuis').list()`: list the currently enabled UIs.
  '';

  maintainers = [ lib.maintainers.khaneliman ];

  callSetup = false;
  hasSettings = false;
}
