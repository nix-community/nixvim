{ lib, ... }:
let
  inherit (lib.nixvim) nestedLiteralLua;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "navbuddy";
  package = "nvim-navbuddy";
  moduleName = "nvim-navbuddy";
  description = "A simple popup display that provides a breadcrumbs feature using an LSP server.";
  maintainers = [ ];

  # TODO: introduced 2025-10-10: remove after 26.05
  inherit (import ./deprecations.nix lib) deprecateExtraOptions optionsRenamedToSettings imports;

  settingsExample = {
    lsp.auto_attach = true;
    use_default_mapping = true;
    mappings = {
      "<esc>" = nestedLiteralLua "require('nvim-navbuddy.actions').close()";
      "q" = nestedLiteralLua "require('nvim-navbuddy.actions').close()";
      "j" = nestedLiteralLua "require('nvim-navbuddy.actions').next_sibling()";
      "k" = nestedLiteralLua "require('nvim-navbuddy.actions').previous_sibling()";
      "<C-v>" = nestedLiteralLua "require('nvim-navbuddy.actions').vsplit()";
      "<C-s>" = nestedLiteralLua "require('nvim-navbuddy.actions').hsplit()";
    };
    icons = {
      Array = "> ";
      Boolean = "> ";
      Class = "> ";
    };
  };
}
