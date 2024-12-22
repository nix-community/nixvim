{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts mkNullOrOption;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "render-markdown";
  packPathName = "render-markdown.nvim";
  package = "render-markdown-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # Only 'Useful Configuration Options' from the wiki
  # https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki#useful-configuration-options
  settingsOptions = {
    preset = defaultNullOpts.mkStr "none" ''
      Allows you to set many different non default options with a single value.
      You can view the values for these [here](https://github.com/MeanderingProgrammer/render-markdown.nvim/blob/main/lua/render-markdown/presets.lua).
    '';

    enabled = defaultNullOpts.mkBool true ''
      This lets you set whether the plugin should render documents from the start or not.
      Useful if you want to use a command like `RenderMarkdown enable` to start rendering documents
      rather than having it on by default.

      There are ways to accomplish the same thing with the `lazy.nvim` `cmd` option, the point of
      this feature is to be plugin manager agnostic.
    '';

    injections =
      defaultNullOpts.mkAttrsOf types.anything
        {

          gitcommit = {
            enabled = true;
            query = ''
              ((message) @injection.content
                  (#set! injection.combined)
                  (#set! injection.include-children)
                  (#set! injection.language "markdown"))
            '';
          };
        }
        ''
          This plugin works by iterating through the language trees of the current buffer and adding
          marks for handled languages such as `markdown`.

          For standard `markdown` files this is the entire file, however for other filetypes this
          may be only specific sections.

          This option allows users to define these sections within the plugin configuration as well
          as allowing this plugin to provide logical defaults for a "batteries included" experience.
        '';

    max_file_size = defaultNullOpts.mkNullable types.float 10.0 ''
      The maximum file size that this plugin will attempt to render in megabytes.

      This plugin only does rendering for what is visible within the viewport so the size of the
      file does not directly impact its performance.
      However large files in general are laggy enough hence this feature.

      The size is only checked once when the file is opened and not after every update, so a file
      that grows larger than this in the process of editing will continue to be rendered.
    '';

    debounce = defaultNullOpts.mkUnsignedInt 100 ''
      This is meant to space out how often this plugin parses the content of the viewport in
      milliseconds to avoid causing too much lag while scrolling & editing.

      For example if you hold `j` once you've scrolled far enough down you'll notice that there is
      no longer any rendering happening.
      Only once you've stopped scrolling for this debounce time will the plugin parse the viewport
      and update the marks.
      If you don't mind the lag or have a really fast system you can reduce this value to make the
      plugin feel snappier.
    '';

    win_options =
      defaultNullOpts.mkAttrsOf
        (types.submodule {
          freeformType = with types; attrsOf anything;

          options = {
            default = mkNullOrOption types.anything ''
              Default value (used for editing).
            '';

            rendered = mkNullOrOption types.anything ''
              Value only used for rendering files.
            '';
          };
        })
        {
          conceallevel = {
            default.__raw = "vim.api.nvim_get_option_value('conceallevel', {})";
            rendered = 3;
          };
          concealcursor = {
            default.__raw = "vim.api.nvim_get_option_value('concealcursor', {})";
            rendered = "";
          };
        }
        ''
          Window options are used by the plugin to set different window level neovim option values
          when rendering and when not rendering a file.

          This is useful for 2 reasons:
          - To allow options for rendering to be controlled by the plugin configuration so users
            don't need to set global or ftplugin options to make things work.
          - Some option values are more useful for appearance and others are more useful while
            editing.
        '';

    overrides = {
      buftype = defaultNullOpts.mkAttrsOf' {
        type = types.anything;
        pluginDefault = {
          nofile = {
            padding.highlight = "NormalFloat";
            sign.enabled = false;
          };
        };
        example = {
          nofile.code = {
            left_pad = 0;
            right_pad = 0;
          };
        };
        description = ''
          This lets you set nearly all the options available at a `buftype` level.
          Think of the top level configuration as the default where when the `buftype` match these
          override values are used instead.
          `filetype` takes precedence over `buftype`.
        '';
      };

      filetype = defaultNullOpts.mkAttrsOf types.anything { } ''
        This lets you set nearly all the options available at a `filetype` level.
        Think of the top level configuration as the default where when the `filetype` match these
        override values are used instead.
        `filetype` takes precedence over `buftype`.
      '';
    };
  };

  settingsExample = {
    render_modes = true;
    signs.enabled = false;
    bullet = {
      icons = [
        "◆ "
        "• "
        "• "
      ];
      right_pad = 1;
    };
    heading = {
      sign = false;
      width = "full";
      position = "inline";
      border = true;
      icons = [
        "1 "
        "2 "
        "3 "
        "4 "
        "5 "
        "6 "
      ];
    };
    code = {
      sign = false;
      width = "block";
      position = "right";
      language_pad = 2;
      left_pad = 2;
      right_pad = 2;
      border = "thick";
      above = " ";
      below = " ";
    };
  };
}
