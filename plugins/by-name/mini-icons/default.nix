{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;

  iconCustomizationType = types.submodule {
    freeformType = with types; attrsOf anything;
    options = {
      glyph = defaultNullOpts.mkStr null ''
        The icon glyph/character to display.
      '';

      hl = defaultNullOpts.mkStr null ''
        The highlight group name to use for coloring the icon.
      '';
    };
  };
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-icons";
  moduleName = "mini.icons";
  packPathName = "mini.icons";
  configLocation = lib.mkOrder 800 "extraConfigLua";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsOptions = {
    style = defaultNullOpts.mkEnum [ "glyph" "ascii" ] "glyph" ''
      Icon style to use:
      - "glyph": use glyph icons (like 󰈔 and 󰉋)
      - "ascii": use fallback ASCII-compatible icons (computed as upper first character of icon's resolved name)
    '';

    default = defaultNullOpts.mkAttrsOf iconCustomizationType { } ''
      Icon data used as fallback for any category.
    '';

    directory = defaultNullOpts.mkAttrsOf iconCustomizationType { } ''
      Icon data for directory paths.
      Keys should be directory basenames (case-sensitive).
    '';

    extension = defaultNullOpts.mkAttrsOf iconCustomizationType { } ''
      Icon data for file extensions.
      Keys should be extensions without dot prefix (case-insensitive).
    '';

    file = defaultNullOpts.mkAttrsOf iconCustomizationType { } ''
      Icon data for specific file names.
      Keys should be exact file basenames (case-sensitive).
    '';

    filetype = defaultNullOpts.mkAttrsOf iconCustomizationType { } ''
      Icon data for Neovim filetypes.
      Keys should be filetype names (case-insensitive).
    '';

    lsp = defaultNullOpts.mkAttrsOf iconCustomizationType { } ''
      Icon data for LSP kind values (completion items, symbols, etc.).
      Keys should be LSP kind names (case-insensitive).
    '';

    os = defaultNullOpts.mkAttrsOf iconCustomizationType { } ''
      Icon data for operating systems.
      Keys should be OS names (case-insensitive).
    '';

    use_file_extension = defaultNullOpts.mkRaw "function(ext, file) return true end" ''
      Function to control which extensions will be considered during "file" category resolution.
      Called with arguments: ext (extension; lowercase) and file (input file path).
      Should return true if extension should be considered.
    '';
  };

  settingsExample = {
    style = "glyph";
    extension = {
      lua = {
        hl = "Special";
      };
    };
    file = {
      "init.lua" = {
        glyph = "";
        hl = "MiniIconsGreen";
      };
    };
  };

  extraOptions = {
    mockDevIcons = lib.mkEnableOption "" // {
      description = ''
        Whether to tell `mini.icons` to emulate `nvim-web-devicons` for plugins that don't natively support it.

        When enabled, you don't need to set `plugins.web-devicons.enable`. This will replace the need for it.
      '';
    };
  };

  extraConfig = cfg: {
    plugins.mini-icons.luaConfig.content = lib.mkAfter (
      lib.optionalString cfg.mockDevIcons ''
        MiniIcons.mock_nvim_web_devicons()
      ''
    );
  };
}
