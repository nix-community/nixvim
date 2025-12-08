{ lib, ... }:
# We use `mkVimPlugin` to avoid having a `settings` option.
# Indeed, this plugin is not configurable in the common sense (no `setup` function).
lib.nixvim.plugins.mkVimPlugin {
  name = "gitignore";
  package = "gitignore-nvim";
  description = "A Neovim plugin for generating .gitignore files.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraOptions = {
    keymap = lib.mkOption {
      type =
        with lib.types;
        nullOr (
          either str (submodule {
            options = {
              key = lib.mkOption {
                type = str;
                description = "The key to map.";
                example = "<leader>gi";
              };

              mode = lib.nixvim.keymaps.mkModeOption "n";

              options = lib.nixvim.keymaps.mapConfigOptions;
            };
          })
        );
      default = null;
      description = ''
        Keyboard shortcut for the `gitignore.generate` command.
        Can be:
        - A string: which key to bind
        - An attrs: if you want to customize the mode and/or the options of the keymap
          (`desc`, `silent`, ...)
      '';
      example = "<leader>gi";
    };
  };

  extraConfig = cfg: {
    keymaps = lib.optional (cfg.keymap != null) (
      (
        if lib.isString cfg.keymap then
          {
            mode = "n";
            key = cfg.keymap;
          }
        else
          cfg.keymap
      )
      // {
        action.__raw = "require('gitignore').generate";
      }
    );
  };
}
