{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "cursorline";
  moduleName = "nvim-cursorline";
  package = "nvim-cursorline";

  maintainers = [ lib.maintainers.khaneliman ];

  description = ''
    A Neovim plugin to highlight the cursor line and word under the cursor.
  '';

  settingsOptions = {
    cursorline = {
      enable = defaultNullOpts.mkBool true "Show / hide cursorline in connection with cursor moving.";
      timeout = defaultNullOpts.mkInt 1000 "Time (in ms) after which the cursorline appears.";
      number = defaultNullOpts.mkBool false "Whether to also highlight the line number.";
    };
    cursorword = {
      enable = defaultNullOpts.mkBool true "Underlines the word under the cursor.";
      min_length = defaultNullOpts.mkInt 3 "Minimum length for underlined words.";
      hl = defaultNullOpts.mkAttrsOf types.anything {
        underline = true;
      } "Highlight definition map for cursorword highlighting.";
    };
  };

  settingsExample = {
    settings = {
      cursorline = {
        enable = true;
        timeout = 1000;
        number = false;
      };
      cursorword = {
        enable = true;
        min_length = 3;
        hl = {
          underline = true;
        };
      };
    };
  };

  # TODO: Deprecated in 2025-02-01
  inherit (import ./deprecations.nix) deprecateExtraOptions optionsRenamedToSettings;
}
