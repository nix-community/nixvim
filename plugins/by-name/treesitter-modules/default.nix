{ lib, config, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "treesitter-modules";
  package = "treesitter-modules-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  description = ''
    A companion plugin to nvim-treesitter that re-implements modules that used to be
    built into nvim-treesitter's `main` branch (such as `incremental_selection`,
    `highlight`, `indent`, and `fold`), now that nvim-treesitter's `main` branch only
    manages parsers/queries.
  '';

  settingsExample = lib.literalExpression ''
    {
      incremental_selection = {
        enable = true;
        keymaps = {
          init_selection = "<A-o>";
          node_incremental = "<A-o>";
          scope_incremental = "<A-O>";
          node_decremental = "<A-i>";
        };
      };
    }
  '';

  extraConfig = {
    assertions = lib.nixvim.mkAssertions "plugins.treesitter-modules" {
      assertion = config.plugins.treesitter.enable;
      message = ''
        You have to enable `plugins.treesitter` to use `plugins.treesitter-modules`.
      '';
    };
  };
}
