{
  config,
  lib,
  helpers,
  pkgs,
  ...
}:
with lib;
  helpers.vim-plugin.mkVimPlugin config {
    name = "lazygit";
    originalName = "lazygit.nvim";
    defaultPackage = pkgs.vimPlugins.lazygit-nvim;
    globalPrefix = "lazygit_";

    maintainers = [helpers.maintainers.AndresBermeoMarinelli];

    settingsOptions = {
      floating_window_winblend = helpers.defaultNullOpts.mkNullable (types.ints.between 0 100) "0" ''
        Set the transparency of the floating window.
      '';

      floating_window_scaling_factor =
        helpers.defaultNullOpts.mkNullable types.numbers.nonnegative
        "0.9" "Set the scaling factor for floating window.";

      floating_window_border_chars =
        helpers.defaultNullOpts.mkListOf types.str
        ''["╭" "─" "╮" "│" "╯" "─" "╰" "│"]''
        "Customize lazygit popup window border characters.";

      floating_window_use_plenary = helpers.defaultNullOpts.mkBool false ''
        Whether to use plenary.nvim to manage floating window if available.
      '';

      use_neovim_remote = helpers.defaultNullOpts.mkBool true ''
        Whether to use neovim remote. Will fallback to `false` if neovim-remote is not installed.
      '';

      use_custom_config_file_path = helpers.defaultNullOpts.mkBool false ''
        Config file path is evaluated if this value is `true`.
      '';

      config_file_path =
        helpers.defaultNullOpts.mkNullable
        (
          with types;
            either
            str (listOf str)
        )
        "[]"
        "Custom config file path or list of custom config file paths.";
    };

    settingsExample = {
      floating_window_winblend = 0;
      floating_window_scaling_factor = 0.9;
      floating_window_border_chars = ["╭" "─" "╮" "│" "╯" "─" "╰" "│"];
      floating_window_use_plenary = false;
      use_neovim_remote = true;
      use_custom_config_file_path = false;
      config_file_path = [];
    };

    extraOptions = {
      gitPackage = mkOption {
        type = with types; nullOr package;
        default = pkgs.git;
        example = null;
        description = ''
          The `git` package to use.
          Set to `null` to not install any package.
        '';
      };

      lazygitPackage = mkOption {
        type = with types; nullOr package;
        default = pkgs.lazygit;
        example = null;
        description = ''
          The `lazygit` package to use.
          Set to `null` to not install any package.
        '';
      };
    };

    extraConfig = cfg: {
      extraPackages = [
        cfg.gitPackage
        cfg.lazygitPackage
      ];
    };
  }
