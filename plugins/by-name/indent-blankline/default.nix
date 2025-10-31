{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "indent-blankline";
  moduleName = "ibl";
  package = "indent-blankline-nvim";
  description = "This plugin adds indentation guides to Neovim.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    indent = {
      char = "│";
    };
    scope = {
      show_start = false;
      show_end = false;
      show_exact_scope = true;
    };
    exclude = {
      filetypes = [
        ""
        "checkhealth"
        "help"
        "lspinfo"
        "packer"
        "TelescopePrompt"
        "TelescopeResults"
        "yaml"
      ];
      buftypes = [
        "terminal"
        "quickfix"
      ];
    };
  };
}
