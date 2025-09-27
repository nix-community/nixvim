{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts mkNullOrOption;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "autoclose";
  package = "autoclose-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  description = ''
    Automatically close pairs in Neovim.
  '';

  settingsOptions = {
    keys = mkNullOrOption (types.attrsOf types.anything) ''
      Configures various options, such as shortcuts for pairs, what pair of characters to use in the shortcut, etc.
    '';
    options = {
      disabled_filetypes = defaultNullOpts.mkListOf types.str [ "text" ] ''
        The plugin will be disabled under the filetypes in this table.
      '';
      disable_when_touch = defaultNullOpts.mkBool false ''
        Set this to true will disable the auto-close function when the cursor touches character that matches touch_regex.
      '';
      touch_regex = defaultNullOpts.mkStr "[%w(%[{]" ''
        Regex to use in combination with `disable_when_touch`.
      '';
      pair_spaces = defaultNullOpts.mkBool false ''
        Pair the spaces when cursor is inside a pair of keys.
      '';
      auto_indent = defaultNullOpts.mkBool true ''
        Enable auto-indent feature.
      '';
      disable_command_mode = defaultNullOpts.mkBool false ''
        Disable autoclose for command mode globally.
      '';
    };
  };

  settingsExample = {
    settings = {
      options = {
        disabled_filetypes = [ "text" ];
        disable_when_touch = false;
        touch_regex = "[%w(%[{]";
        pair_spaces = false;
        auto_indent = true;
        disable_command_mode = false;
      };
    };
  };

  # TODO: Deprecated in 2025-01-31
  inherit (import ./deprecations.nix) deprecateExtraOptions optionsRenamedToSettings;
}
