{pkgs,lib,config, ...}:
with lib;
let
  cfg = config.plugins.magma-nvim;
  helpers = import ../helpers.nix { lib = lib; };
  plugins = import ../plugin-defs.nix { inherit pkgs; };
in
  {
    options = {
      plugins.magma-nvim = {
        enable = mkEnableOption "Enable magma-nvim?";
        # image_provider
        # automatically_open_output
        # wrap_output
        # output_window_borders
        # cell_highlight_group
        # save_path
        # show_mimetype_debug
      };
    };
    config = mkIf cfg.enable {
      extraPlugins = [ plugins.magma-nvim ];
      globals = {

      };
   };

  }

