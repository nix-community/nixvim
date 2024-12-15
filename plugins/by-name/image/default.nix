{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.image;
in
{
  meta.maintainers = [ maintainers.GaetanLepage ];

  options.plugins.image = lib.nixvim.neovim-plugin.extraOptionsOptions // {
    enable = mkEnableOption "image.nvim";

    package = lib.mkPackageOption pkgs "image.nvim" {
      default = [
        "vimPlugins"
        "image-nvim"
      ];
    };

    curlPackage = lib.mkPackageOption pkgs "curl" {
      nullable = true;
    };

    ueberzugPackage = lib.mkPackageOption pkgs "ueberzugpp" {
      nullable = true;
    };

    backend =
      helpers.defaultNullOpts.mkEnumFirstDefault
        [
          "kitty"
          "ueberzug"
        ]
        ''
          All the backends support rendering inside Tmux.

          - kitty - best in class, works great and is very snappy
          - ueberzug - backed by ueberzugpp, supports any terminal, but has lower performance
            - Supports multiple images thanks to @jstkdng.
        '';

    integrations =
      let
        mkIntegrationOptions = integrationName: filetypesDefault: {
          enabled = helpers.defaultNullOpts.mkBool true ''
            Whether to enable the markdown integration.
          '';

          clearInInsertMode = helpers.defaultNullOpts.mkBool false ''
            Clears the image when entering insert mode.
          '';

          downloadRemoteImages = helpers.defaultNullOpts.mkBool true ''
            Whether to download remote images.
          '';

          onlyRenderImageAtCursor = helpers.defaultNullOpts.mkBool false ''
            Whether to limit rendering to the image at the current cursor position.
          '';

          filetypes = helpers.defaultNullOpts.mkListOf types.str filetypesDefault ''
            Markdown extensions (ie. quarto) can go here.
          '';
        };
      in
      mapAttrs mkIntegrationOptions {
        markdown = [
          "markdown"
          "vimwiki"
        ];
        neorg = [ "norg" ];
        syslang = [ "syslang" ];
      };

    maxWidth = helpers.mkNullOrOption types.ints.unsigned "Image maximum width.";

    maxHeight = helpers.mkNullOrOption types.ints.unsigned "Image maximum height.";

    maxWidthWindowPercentage = helpers.mkNullOrOption types.ints.unsigned ''
      Image maximum width as a percentage of the window width.
    '';

    maxHeightWindowPercentage = helpers.defaultNullOpts.mkUnsignedInt 50 ''
      Image maximum height as a percentage of the window height.
    '';

    windowOverlapClearEnabled = helpers.defaultNullOpts.mkBool false ''
      Toggles images when windows are overlapped.
    '';

    windowOverlapClearFtIgnore =
      helpers.defaultNullOpts.mkListOf types.str
        [
          "cmp_menu"
          "cmp_docs"
          ""
        ]
        ''
          Toggles images when windows are overlapped.
        '';

    editorOnlyRenderWhenFocused = helpers.defaultNullOpts.mkBool false ''
      Auto show/hide images when the editor gains/looses focus.
    '';

    tmuxShowOnlyInActiveWindow = helpers.defaultNullOpts.mkBool false ''
      Auto show/hide images in the correct Tmux window (needs visual-activity off).
    '';

    hijackFilePatterns =
      helpers.defaultNullOpts.mkListOf types.str
        [
          "*.png"
          "*.jpg"
          "*.jpeg"
          "*.gif"
          "*.webp"
        ]
        ''
          Render image files as images when opened.
        '';
  };

  config = mkIf cfg.enable {
    extraPlugins = [ cfg.package ];
    extraLuaPackages = ps: [ ps.magick ];

    extraPackages = [
      # In theory, we could remove that if the user explicitly disables `downloadRemoteImages` for
      # all integrations but shipping `curl` is not too heavy.
      cfg.curlPackage
    ] ++ optional (cfg.backend == "ueberzug") cfg.ueberzugPackage;

    extraConfigLua =
      let
        setupOptions =
          with cfg;
          {
            inherit backend;
            integrations =
              let
                processIntegrationOptions = v: {
                  inherit (v) enabled;
                  clear_in_insert_mode = v.clearInInsertMode;
                  download_remote_images = v.downloadRemoteImages;
                  only_render_image_at_cursor = v.onlyRenderImageAtCursor;
                  inherit (v) filetypes;
                };
              in
              mapAttrs (_: processIntegrationOptions) integrations;
            max_width = maxWidth;
            max_height = maxHeight;
            max_width_window_percentage = maxWidthWindowPercentage;
            max_height_window_percentage = maxHeightWindowPercentage;
            window_overlap_clear_enabled = windowOverlapClearEnabled;
            window_overlap_clear_ft_ignore = windowOverlapClearFtIgnore;
            editor_only_render_when_focused = editorOnlyRenderWhenFocused;
            tmux_show_only_in_active_window = tmuxShowOnlyInActiveWindow;
            hijack_file_patterns = hijackFilePatterns;
          }
          // cfg.extraOptions;
      in
      ''
        require('image').setup(${helpers.toLuaObject setupOptions})
      '';
  };
}
