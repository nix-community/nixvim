{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.vim-bbye;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options.plugins.vim-bbye = {
    enable = mkEnableOption "vim-bbye";

    package = helpers.mkPackageOption "vim-bbye" pkgs.vimPlugins.vim-bbye;

    keymapsSilent = mkOption {
      type = types.bool;
      description = "Whether vim-bbye keymaps should be silent.";
      default = false;
    };

    keymaps = {
      bdelete = helpers.mkNullOrOption types.str ''
        Keymap for deleting the current buffer.";
      '';

      bwipeout = helpers.mkNullOrOption types.str ''
        Keymap for completely deleting the current buffer.";
      '';
    };
  };

  config = mkIf cfg.enable {
    extraPlugins = [cfg.package];

    keymaps = with cfg.keymaps;
      helpers.keymaps.mkKeymaps
      {
        mode = "n";
        options.silent = cfg.keymapsSilent;
      }
      (
        (
          optional
          (bdelete != null)
          {
            key = bdelete;
            action = ":Bdelete<CR>";
          }
        )
        ++ (
          optional
          (bwipeout != null)
          {
            key = bwipeout;
            action = ":Bwipeout<CR>";
          }
        )
      );
  };
}
