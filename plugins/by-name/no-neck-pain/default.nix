{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "no-neck-pain";
  maintainers = [ lib.maintainers.ChelseaWilkinson ];
  packPathName = "no-neck-pain.nvim";
  package = "no-neck-pain-nvim";
  url = "https://github.com/shortcuts/no-neck-pain.nvim";
  description = "☕ Dead simple yet super extensible zen mode plugin to protect your neck.";

  moduleName = "no-neck-pain";

  settingsExample = {
    width = 80;
    autocmds = {
      enableOnVimEnter = true;
      skipEnteringNoNeckPainBuffer = true;
    };
    buffers = {
      backgroundColor = "catppuccin-frappe";
      blend = -0.1;
      scratchPad = {
        enabled = true;
        fileName = "notes";
        location = "~/";
      };
      bo = {
        filetype = "md";
      };
    };
  };
}
