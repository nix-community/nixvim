{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "startup";
  package = "startup-nvim";
  description = "A highly configurable Neovim startup screen.";
  maintainers = [ ];

  # Plugin uses 2 functions to setup...
  callSetup = false;

  # TODO: introduced 2025-10-17: remove after 26.05
  inherit (import ./deprecations.nix lib) deprecateExtraOptions optionsRenamedToSettings imports;

  extraOptions = {
    userMappings = lib.mkOption {
      type = with lib.types; attrsOf str;
      description = "Add your own mappings as key-command pairs.";
      default = { };
      example = {
        "<leader>ff" = "<cmd>Telescope find_files<CR>";
        "<leader>lg" = "<cmd>Telescope live_grep<CR>";
      };
    };
  };

  settingsExample = {
    theme = "dashboard";
    options = {
      mapping_keys = true;
      cursor_column = 0.5;
      after = null;
      empty_lines_between_mappings = true;
      disable_statuslines = true;
      paddings = lib.nixvim.nestedLiteral (lib.literalExpression "lib.nixvim.utils.emptyTable");
    };
    mappings = {
      execute_command = "<CR>";
      open_file = "o";
      open_file_split = "<c-o>";
      open_section = "<TAB>";
      open_help = "?";
    };
    colors = {
      background = "#1f2227";
      folded_section = "#56b6c2";
    };
  };

  extraConfig = cfg: {
    extraConfigLua = ''
      require('startup').setup(${lib.nixvim.toLuaObject cfg.settings})
    ''
    + (lib.optionalString (
      cfg.userMappings != { }
    ) "require('startup').create_mappings(${lib.nixvim.toLuaObject cfg.userMappings})");
  };
}
