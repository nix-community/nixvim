{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "gitlinker";
  package = "gitlinker-nvim";
  description = "A simple popup display that provides a breadcrumbs feature using an LSP server.";
  maintainers = [ ];

  # TODO: introduced 2025-10-12: remove after 26.05
  inherit (import ./deprecations.nix lib) deprecateExtraOptions optionsRenamedToSettings imports;

  settingsExample = {
    opts = {
      action_callback = lib.nixvim.nestedLiteralLua ''
        function(url)
          -- yank to unnamed register
          vim.api.nvim_command("let @\" = '" .. url .. "'")
          -- copy to the system clipboard using OSC52
          vim.fn.OSCYankString(url)
        end
      '';
      print_url = false;
    };
  };
}
