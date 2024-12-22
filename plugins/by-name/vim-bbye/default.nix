{
  lib,
  ...
}:
let
  inherit (lib.nixvim) mkNullOrOption;
  inherit (lib) types;
in
lib.nixvim.plugins.mkVimPlugin {
  name = "vim-bbye";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraOptions = {
    keymapsSilent = lib.mkOption {
      type = types.bool;
      description = "Whether vim-bbye keymaps should be silent.";
      default = false;
    };

    keymaps = {
      bdelete = mkNullOrOption types.str ''
        Keymap for deleting the current buffer.";
      '';

      bwipeout = mkNullOrOption types.str ''
        Keymap for completely deleting the current buffer.";
      '';
    };
  };

  extraConfig = cfg: {
    keymaps =
      lib.nixvim.keymaps.mkKeymaps
        {
          mode = "n";
          options.silent = cfg.keymapsSilent;
        }
        (
          (lib.optional (cfg.keymaps.bdelete != null) {
            key = cfg.keymaps.bdelete;
            action = ":Bdelete<CR>";
          })
          ++ (lib.optional (cfg.keymaps.bwipeout != null) {
            key = cfg.keymaps.bwipeout;
            action = ":Bwipeout<CR>";
          })
        );
  };
}
