{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "lazygit";
  originalName = "lazygit.nvim";
  package = "lazygit-nvim";
  globalPrefix = "lazygit_";

  maintainers = [ lib.maintainers.AndresBermeoMarinelli ];

  settingsOptions = {
    floating_window_winblend = defaultNullOpts.mkNullable (types.ints.between 0 100) 0 ''
      Set the transparency of the floating window.
    '';

    floating_window_scaling_factor =
      defaultNullOpts.mkNullable types.numbers.nonnegative 0.9
        "Set the scaling factor for floating window.";

    floating_window_border_chars = defaultNullOpts.mkListOf types.str [
      "╭"
      "─"
      "╮"
      "│"
      "╯"
      "─"
      "╰"
      "│"
    ] "Customize lazygit popup window border characters.";

    floating_window_use_plenary = defaultNullOpts.mkFlagInt 0 ''
      Whether to use plenary.nvim to manage floating window if available.
    '';

    use_neovim_remote = defaultNullOpts.mkFlagInt 1 ''
      Whether to use neovim remote. Will fallback to `0` if neovim-remote is not installed.
    '';

    use_custom_config_file_path = defaultNullOpts.mkFlagInt 0 ''
      Config file path is evaluated if this value is `1`.
    '';

    config_file_path = defaultNullOpts.mkNullable (
      with types; either str (listOf str)
    ) [ ] "Custom config file path or list of custom config file paths.";
  };

  settingsExample = {
    floating_window_winblend = 0;
    floating_window_scaling_factor = 0.9;
    floating_window_border_chars = [
      "╭"
      "─"
      "╮"
      "│"
      "╯"
      "─"
      "╰"
      "│"
    ];
    floating_window_use_plenary = 0;
    use_neovim_remote = 1;
    use_custom_config_file_path = 0;
    config_file_path = [ ];
  };

  extraOptions = {
    gitPackage = lib.mkPackageOption pkgs "git" {
      nullable = true;
    };

    lazygitPackage = lib.mkPackageOption pkgs "lazygit" {
      nullable = true;
    };
  };

  extraConfig = cfg: {
    extraPackages = [
      cfg.gitPackage
      cfg.lazygitPackage
    ];
  };
}
