{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
# We use `mkVimPlugin` to avoid having a `settings` option.
# Indeed, this plugin is not configurable in the common sense (no `setup` function).
helpers.vim-plugin.mkVimPlugin config {
  name = "gitignore";
  originalName = "gitignore.nvim";
  defaultPackage = pkgs.vimPlugins.gitignore-nvim;

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
