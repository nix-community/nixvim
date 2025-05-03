{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "lf";
  packPathName = "lf.nvim";
  package = "lf-nvim";

  description = ''
    Lf file manager integration for Neovim
  '';

  maintainers = [ lib.maintainers.bpeetz ];

  settingsExample = {
    default_action = "drop";
    default_actions = {
      "<C-t>" = "tabedit";
      "<C-x>" = "split";
      "<C-v>" = "vsplit";
      "<C-o>" = "tab drop";
    };
    winblend = 10;
    dir = "";
    direction = "float";
    border = "rounded";
    height.__raw = "vim.fn.float2nr(vim.fn.round(0.75 * vim.o.lines))";
    width.__raw = "vim.fn.float2nr(vim.fn.round(0.75 * vim.o.columns))";
    escape_quit = true;
    focus_on_open = true;
    tmux = false;
    default_file_manager = true;
    disable_netrw_warning = true;
  };
}
