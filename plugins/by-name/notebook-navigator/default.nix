{ lib, config, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "notebook-navigator";
  packPathName = "NotebookNavigator-nvim";
  package = "NotebookNavigator-nvim";
  description = "A Neovim plugin for navigating and managing Jupyter code cells in notebooks.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    cell_markers = defaultNullOpts.mkAttrsOf' {
      type = types.str;
      pluginDefault = { };
      example = {
        python = "# %%";
      };
      description = ''
        Code cell marker.

        Cells start with the marker and end either at the beginning of the next cell or at the end of
        the file.

        By default, uses language-specific double percent comments like `# %%`.
        This can be overridden for each language with this setting.
      '';
    };

    activate_hydra_keys = defaultNullOpts.mkStr null ''
      If not `nil` the keymap defined in the string will activate the hydra head.
      If you don't want to use hydra you don't need to install it either.
    '';

    show_hydra_hint = defaultNullOpts.mkBool true ''
      If `true` a hint panel will be shown when the hydra head is active.
      If `false` you get a minimalistic hint on the command line.
    '';

    hydra_keys =
      defaultNullOpts.mkAttrsOf types.str
        {
          comment = "c";
          run = "X";
          run_and_move = "x";
          move_up = "k";
          move_down = "j";
          add_cell_before = "a";
          add_cell_after = "b";
          split_cell = "s";
        }
        ''
          Mappings while the hydra head is active.
        '';

    repl_provider =
      defaultNullOpts.mkEnumFirstDefault
        [
          "auto"
          "iron"
          "molten"
          "toggleterm"
        ]
        ''
          The repl plugin with which to interface.

          Current options:
          - "iron" for iron.nvim,
          - "toggleterm" for toggleterm.nvim,
          - "molten" for molten-nvim
          - "auto" which checks which of the above are installed
        '';

    syntax_highlight = defaultNullOpts.mkBool false ''
      Syntax based highlighting.

      If you don't want to install `mini.hipattners` or enjoy a more minimalistic look.
    '';

    cell_highlight_group = defaultNullOpts.mkStr "Folded" ''
      For use with `mini.hipatterns` to highlight cell markers.
    '';
  };

  # Optionally, provide an example for the `settings` option.
  settingsExample = {
    cell_markers.python = "# %%";
    activate_hydra_keys = "<leader>h";
    hydra_keys = {
      comment = "c";
      run = "X";
      run_and_move = "x";
      move_up = "k";
      move_down = "j";
      add_cell_before = "a";
      add_cell_after = "b";
      split_cell = "s";
    };
    repl_provider = "molten";
    syntax_highlight = true;
    cell_highlight_group = "Folded";
  };

  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.notebook-navigator" [
      {
        when = (cfg.settings.activate_hydra_keys != null) && (!config.plugins.hydra.enable);
        message = ''
          `settings.activate_hydra_keys` has been set to a non-`null` value but `plugins.hydra.enable` is `false`.
        '';
      }
      {
        when = (cfg.settings.repl_provider == "toggleterm") && (!config.plugins.toggleterm.enable);
        message = ''
          `settings.repl_provider` has been set to "toggleterm" but `plugins.hydra.toggleterm.enable` is `false`.
        '';
      }
      {
        when = (cfg.settings.repl_provider == "molten") && (!config.plugins.molten.enable);
        message = ''
          `settings.repl_provider` has been set to "molten" but `plugins.molten.enable` is `false`.
        '';
      }
    ];
  };
}
