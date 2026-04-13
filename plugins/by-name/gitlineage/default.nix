{
  lib,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "gitlineage";
  package = "gitlineage-nvim";

  description = "Show git lineage information inside Neovim.";

  maintainers = with lib.maintainers; [ LionyxML ];

  settingsOptions = {
    split = defaultNullOpts.mkStr "auto" ''
      Where the git lineage window should open.
      Accepts "vertical", "horizontal", or "auto".
    '';

    keymap = defaultNullOpts.mkStr "<leader>gl" ''
      Default keymap for opening the git lineage window.
      Set to `null` to disable.
    '';

    keys =
      defaultNullOpts.mkAttrsOf (types.nullOr types.str)
        {
          close = "q";
          next_commit = "]c";
          prev_commit = "[c";
          yank_commit = "yc";
          open_diff = "<CR>";
        }
        ''
          Keymaps inside the git lineage window.
          Set individual entries to `null` to disable.
        '';
  };

  settingsExample = {
    split = "auto";
    keymap = "<leader>gl";
    keys = {
      close = "q";
      next_commit = "]c";
      prev_commit = "[c";
      yank_commit = "yc";
      open_diff = "<CR>";
    };
  };
}
