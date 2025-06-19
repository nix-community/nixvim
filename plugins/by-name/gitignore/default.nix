{
  lib,
  helpers,
  ...
}:
with lib;
# We use `mkVimPlugin` to avoid having a `settings` option.
# Indeed, this plugin is not configurable in the common sense (no `setup` function).
lib.nixvim.plugins.mkVimPlugin {
  name = "gitignore";
  packPathName = "gitignore.nvim";
  package = "gitignore-nvim";
  description = "A Neovim plugin for generating .gitignore files.";

  maintainers = [ maintainers.GaetanLepage ];

  extraOptions = {
    keymap = mkOption {
      type =
        with types;
        nullOr (
          either str (submodule {
            options = {
              key = mkOption {
                type = str;
                description = "The key to map.";
                example = "<leader>gi";
              };

              mode = helpers.keymaps.mkModeOption "n";

              options = helpers.keymaps.mapConfigOptions;
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
    keymaps = optional (cfg.keymap != null) (
      (
        if isString cfg.keymap then
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
