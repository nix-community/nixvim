{
  lib,
  helpers,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "codesnap";
  packPathName = "codesnap.nvim";
  package = "codesnap-nvim";

  maintainers = [ maintainers.GaetanLepage ];

  settingsOptions = {
    save_path = helpers.defaultNullOpts.mkStr null ''
      The save_path must be ends with `.png`, unless when you specified a directory path, CodeSnap
      will append an auto-generated filename to the specified directory path.

      For example:
      - `save_path = "~/Pictures";`
        parsed: `"~/Pictures/CodeSnap_y-m-d_at_h:m:s.png"`
      - `save_path = "~/Pictures/foo.png";`
        parsed: `"~/Pictures/foo.png"`
    '';

    mac_window_bar = helpers.defaultNullOpts.mkBool true ''
      Whether to display the MacOS style title bar.
    '';

    title = helpers.defaultNullOpts.mkStr "CodeSnap.nvim" ''
      The editor title.
    '';

    code_font_family = helpers.defaultNullOpts.mkStr "CaskaydiaCove Nerd Font" ''
      Which font to use for the code.
    '';

    watermark_font_family = helpers.defaultNullOpts.mkStr "Pacifico" ''
      Which font to use for watermarks.
    '';

    watermark = helpers.defaultNullOpts.mkStr "CodeSnap.nvim" ''
      Wartermark of the code snapshot.
    '';

    bg_theme = helpers.defaultNullOpts.mkStr "default" ''
      Background theme name.

      Check the [upstream README](https://github.com/mistricky/codesnap.nvim?tab=readme-ov-file#custom-background)
      for available options.
    '';

    bg_color = helpers.defaultNullOpts.mkStr' {
      pluginDefault = null;
      example = "#535c68";
      description = ''
        If you prefer solid color background, you can set bg_color to your preferred color.
      '';
    };

    breadcrumbs_separator = helpers.defaultNullOpts.mkStr "/" ''
      Separator for breadcrumbs.
      The CodeSnap.nvim uses `/` as the separator of the file path by default, of course, you can
      specify any symbol you prefer as the custom separator.
    '';

    has_breadcrumbs = helpers.defaultNullOpts.mkBool false ''
      Whether to display the current snapshot file path.
    '';

    has_line_number = helpers.defaultNullOpts.mkBool false ''
      Whether to display line numbers.
    '';

    show_workspace = helpers.defaultNullOpts.mkBool false ''
      Breadcrumbs hide the workspace name by default, if you want to display workspace in
      breadcrumbs, you can just set this option to `true`.
    '';

    min_width = helpers.defaultNullOpts.mkUnsignedInt 0 ''
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
