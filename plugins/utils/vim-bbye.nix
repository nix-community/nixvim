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

    maps.normal = with cfg.keymaps;
      (optionalAttrs (!isNull bdelete)
        {
          ${bdelete} = {
            action = ":Bdelete<CR>";
            silent = cfg.keymapsSilent;
          };
        })
      // (optionalAttrs (!isNull bwipeout)
        {
          ${bwipeout} = {
            action = ":Bwipeout<CR>";
            silent = cfg.keymapsSilent;
          };
        });
  };
}
