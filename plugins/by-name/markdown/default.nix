{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "markdown";
  package = "markdown-nvim";

  maintainers = [ lib.maintainers.mrtnvgr ];

  description = "Configurable tools for working with Markdown in Neovim.";

  settingsExample = {
    mappings = {
      inline_surround_toggle = "gs";
      inline_surround_toggle_line = "gss";
      inline_surround_delete = "ds";
      inline_surround_change = "cs";
      link_add = "<leader>ml";
      link_follow = "gx";
      go_curr_heading = "]c";
      go_parent_heading = "]p";
      go_next_heading = "]]";
      go_prev_heading = "[[";
    };
    inline_surround = {
      emphasis = {
        key = "i";
        txt = "*";
      };
      strong = {
        key = "b";
        txt = "**";
      };
      strikethrough = {
        key = "s";
        txt = "~~";
      };
      code = {
        key = "c";
        txt = "`";
      };
    };
    link.paste.enable = true;
    toc = {
      omit_heading = "toc omit heading";
      omit_section = "toc omit section";
      markers = [ "-" ];
    };
  };
}
