{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "nvim-lightbulb";
  description = "The plugin shows a lightbulb in the sign column whenever a `textDocument/codeAction` is available at the current cursor position.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    sign = {
      enabled = false;
      text = "󰌶";
    };
    virtual_text = {
      enabled = true;
      text = "󰌶";
    };
    float = {
      enabled = false;
      text = " 󰌶 ";
      win_opts.border = "rounded";
    };
    status_text = {
      enabled = false;
      text = " 󰌶 ";
    };
    number = {
      enabled = false;
    };
    line = {
      enabled = false;
    };
    autocmd = {
      enabled = true;
      updatetime = 200;
    };
  };
}
