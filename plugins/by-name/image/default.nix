{
  lib,
  config,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "image";
  package = "image-nvim";
  description = "This plugin adds image support to Neovim using Kitty's Graphics Protocol or ueberzugpp.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO: option deprecations added 2025-03-20. Remove after 25.05
  # TODO: curlPackage and ueberzugPackage deprecations added 2025-04-06. Remove after 25.05
  inherit (import ./deprecations.nix lib)
    deprecateExtraOptions
    optionsRenamedToSettings
    imports
    ;

  settingsOptions = {
    backend =
      defaultNullOpts.mkEnumFirstDefault
        [
          "kitty"
          "ueberzug"
          "sixel"
        ]
        ''
          All the backends support rendering inside Tmux.

          - kitty - best in class, works great and is very snappy
          - ueberzug - backed by ueberzugpp, supports any terminal, but has lower performance
            - Supports multiple images thanks to @jstkdng.
          - sixel - uses the Sixel graphics protocol, widely supported by many terminals
            - Works with XTerm, WezTerm, foot, and other Sixel-compatible terminals
            - ImageMagick is required for Sixel encoding

          > [!Note]
          > When choosing the `"ueberzug"` backend, Nixvim will automatically add `ueberzugpp` as a dependency.
          > Set `ueberzugPackage = null` to disable this behavior.
        '';

    integrations =
      defaultNullOpts.mkAttrsOf types.anything
        {
          markdown.enabled = true;
          typst.enabled = true;
          neorg.enabled = true;
          syslang.enabled = true;
          html.enabled = false;
          css.enabled = false;
        }
        ''
          Per-filetype integrations.
        '';

    max_width = defaultNullOpts.mkUnsignedInt null ''
      Image maximum width.
    '';

    max_height = defaultNullOpts.mkUnsignedInt null ''
      Image maximum height.
    '';

    max_width_window_percentage = defaultNullOpts.mkUnsignedInt 100 ''
      Image maximum width as a percentage of the window width.
    '';

    max_height_window_percentage = defaultNullOpts.mkUnsignedInt 50 ''
      Image maximum height as a percentage of the window height.
    '';

    window_overlap_clear_enabled = defaultNullOpts.mkBool false ''
      Toggles images when windows are overlapped.
    '';

    window_overlap_clear_ft_ignore =
      defaultNullOpts.mkListOf types.str
        [
          "cmp_menu"
          "cmp_docs"
          "snacks_notif"
          "scrollview"
          "scrollview_sign"
        ]
        ''
          Toggles images when windows are overlapped.
        '';

    editor_only_render_when_focused = defaultNullOpts.mkBool false ''
      Auto show/hide images when the editor gains/looses focus.
    '';

    tmux_show_only_in_active_window = defaultNullOpts.mkBool false ''
      Auto show/hide images in the correct Tmux window (needs visual-activity off).
    '';

    hijack_file_patterns =
      defaultNullOpts.mkListOf types.str
        [
          "*.png"
          "*.jpg"
          "*.jpeg"
          "*.gif"
          "*.webp"
          "*.avif"
        ]
        ''
          Render image files as images when opened.
        '';
  };

  settingsExample = {
    backend = "kitty";
    max_width = 100;
    max_height = 12;
    max_height_window_percentage.__raw = "math.huge";
    max_width_window_percentage.__raw = "math.huge";
    window_overlap_clear_enabled = true;
    window_overlap_clear_ft_ignore = [
      "cmp_menu"
      "cmp_docs"
      ""
    ];
  };

  dependencies = [
    # In theory, we could remove that if the user explicitly disables `downloadRemoteImages` for
    # all integrations but shipping `curl` is not too heavy.
    "curl"

    {
      name = "ueberzug";
      enable = config.plugins.image.settings.backend == "ueberzug";
    }
    {
      name = "imagemagick";
      enable = config.plugins.image.settings.backend == "sixel";
    }
  ];
}
