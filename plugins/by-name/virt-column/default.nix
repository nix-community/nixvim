{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "virt-column";
  originalName = "virt-column.nvim";
  package = "virt-column-nvim";

  maintainers = [ lib.maintainers.alisonjenkins ];

  settingsOptions = {
    enabled = defaultNullOpts.mkBool true ''
      Enables or disables virt-column.
    '';

    char = defaultNullOpts.mkNullable (with types; either str (listOf str)) [ "┃" ] ''
      Character, or list of characters, that get used to display the virtual column.
      Each character has to have a display width of 0 or 1.
    '';

    virtcolumn = defaultNullOpts.mkStr "" ''
      Comma-separated list of screen columns same syntax as `:help colorcolumn`.
    '';

    highlight = defaultNullOpts.mkNullable (with types; either str (listOf str)) "NonText" ''
      Highlight group, or list of highlight groups, that get applied to the virtual column.
    '';

    exclude = {
      filetypes = defaultNullOpts.mkListOf types.str [
        "lspinfo"
        "packer"
        "checkhealth"
        "help"
        "man"
        "TelescopePrompt"
        "TelescopeResults"
      ] "List of `filetype`s for which virt-column is disabled.";

      buftypes = defaultNullOpts.mkListOf types.str [
        "nofile"
        "quickfix"
        "terminal"
        "prompt"
      ] "List of `buftype`s for which virt-column is disabled.";
    };
  };

  settingsExample = {
    enabled = true;
    char = "┃";
    virtcolumn = "";
    highlight = "NonText";
    exclude = {
      filetypes = [
        "lspinfo"
        "packer"
        "checkhealth"
        "help"
        "man"
        "TelescopePrompt"
        "TelescopeResults"
      ];
      buftypes = [
        "nofile"
        "quickfix"
        "terminal"
        "prompt"
      ];
    };
  };
}
