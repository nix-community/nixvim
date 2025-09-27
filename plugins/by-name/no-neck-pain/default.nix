{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "no-neck-pain";
  maintainers = [ lib.maintainers.ChelseaWilkinson ];
  package = "no-neck-pain-nvim";
  description = "☕ Dead simple yet super extensible zen mode plugin to protect your neck.";

  settingsExample = {
    width = 80;
    autocmds = {
      enableOnVimEnter = true;
      skipEnteringNoNeckPainBuffer = true;
    };
    buffers = {
      colors = {
        background = "catppuccin-frappe";
        blend = -0.1;
      };
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
