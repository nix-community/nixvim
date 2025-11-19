{ lib, ... }:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "codesnap";
  package = "codesnap-nvim";
  description = "Snapshot plugin with rich features that can make pretty code snapshots.";

  maintainers = [ maintainers.GaetanLepage ];

  settingsOptions = {
    save_path = lib.nixvim.defaultNullOpts.mkStr null ''
      The save_path must be ends with `.png`, unless when you specified a directory path, CodeSnap
      will append an auto-generated filename to the specified directory path.

      For example:
      - `save_path = "~/Pictures";`
        parsed: `"~/Pictures/CodeSnap_y-m-d_at_h:m:s.png"`
      - `save_path = "~/Pictures/foo.png";`
        parsed: `"~/Pictures/foo.png"`
    '';

    mac_window_bar = lib.nixvim.defaultNullOpts.mkBool true ''
      Whether to display the MacOS style title bar.
    '';

    title = lib.nixvim.defaultNullOpts.mkStr "CodeSnap.nvim" ''
      The editor title.
    '';

    code_font_family = lib.nixvim.defaultNullOpts.mkStr "CaskaydiaCove Nerd Font" ''
      Which font to use for the code.
    '';

    watermark_font_family = lib.nixvim.defaultNullOpts.mkStr "Pacifico" ''
      Which font to use for watermarks.
    '';

    watermark = lib.nixvim.defaultNullOpts.mkStr "CodeSnap.nvim" ''
      Wartermark of the code snapshot.
    '';

    bg_theme = lib.nixvim.defaultNullOpts.mkStr "default" ''
      Background theme name.

      Check the [upstream README](https://github.com/mistricky/codesnap.nvim?tab=readme-ov-file#custom-background)
      for available options.
    '';

    bg_color = lib.nixvim.defaultNullOpts.mkStr' {
      pluginDefault = null;
      example = "#535c68";
      description = ''
        If you prefer solid color background, you can set bg_color to your preferred color.
      '';
    };

    breadcrumbs_separator = lib.nixvim.defaultNullOpts.mkStr "/" ''
      Separator for breadcrumbs.
      The CodeSnap.nvim uses `/` as the separator of the file path by default, of course, you can
      specify any symbol you prefer as the custom separator.
    '';

    has_breadcrumbs = lib.nixvim.defaultNullOpts.mkBool false ''
      Whether to display the current snapshot file path.
    '';

    has_line_number = lib.nixvim.defaultNullOpts.mkBool false ''
      Whether to display line numbers.
    '';

    show_workspace = lib.nixvim.defaultNullOpts.mkBool false ''
      Breadcrumbs hide the workspace name by default, if you want to display workspace in
      breadcrumbs, you can just set this option to `true`.
    '';

    min_width = lib.nixvim.defaultNullOpts.mkUnsignedInt 0 ''
      Minimum width for the snapshot.
    '';
  };

  settingsExample = {
    save_path = "~/Pictures/Screenshots/";
    mac_window_bar = true;
    title = "CodeSnap.nvim";
    watermark = "";
    breadcrumbs_separator = "/";
    has_breadcrumbs = true;
    has_line_number = false;
  };
}
