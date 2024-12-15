{
  lib,
  ...
}:
let
  inherit (lib) types;
in
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "quickmath";
  packPathName = "quickmath.nvim";
  package = "quickmath-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraOptions = {
    keymap = {
      key = lib.nixvim.mkNullOrOption types.str "Keymap to run the `:Quickmath` command.";

      silent = lib.mkOption {
        type = types.bool;
        description = "Whether the quickmath keymap should be silent.";
        default = false;
      };
    };
  };

  extraConfig = cfg: {
    keymaps =
      with cfg.keymap;
      lib.optional (key != null) {
        mode = "n";
        inherit key;
        action = "<CMD>Quickmath<CR>";
        options.silent = cfg.keymap.silent;
      };
  };
}
