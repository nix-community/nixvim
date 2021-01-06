{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.gitgutter;
  helpers = import ../helpers.nix { inherit lib; };
in {
  options = {
    programs.nixvim.plugins.gitgutter = {
      enable = mkEnableOption "Enable gitgutter";

      recommendedSettings = mkOption {
        type = types.bool;
        default = true;
        description = "Use recommended settings";
      };

      maxSigns = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "Maximum number of signs to show on the screen. Unlimited by default.";
      };

      showMessageOnHunkJumping = mkOption {
        type = types.bool;
        default = true;
        description = "Show a message when jumping between hunks";
      };

      defaultMaps = mkOption {
        type = types.bool;
        default = true;
        description = "Let gitgutter set default mappings";
      };

      allowClobberSigns = mkOption {
        type = types.bool;
        default = false;
        description = "Don't preserve other signs on the sign column";
      };

      signPriority = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "GitGutter's sign priority on the sign column";
      };

      matchBackgrounds = mkOption {
        type = types.bool;
        default = false;
        description = "Make the background colors match the sign column";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = [ pkgs.vimPlugins.gitgutter ];

      options = mkIf cfg.recommendedSettings {
        updatetime = 100;
        foldtext = "gitgutter#fold#foldtext";
      };

      globals = {
        gitgutter_max_signs = mkIf (!isNull cfg.maxSigns) cfg.maxSigns;
        gitgutter_show_msg_on_hunk_jumping = mkIf (!cfg.showMessageOnHunkJumping) 0;
        gitgutter_map_keys = mkIf (!cfg.defaultMaps) 0;
        gitgutter_sign_allow_clobber = mkIf (cfg.allowClobberSigns) 1;
        gitgutter_sign_priority = mkIf (!isNull cfg.signPriority) cfg.signPriority;
        gitgutter_set_sign_backgrounds = mkIf (cfg.matchBackgrounds) 1;

        # TODO these config options:
        # gitgutter_sign_*
        # gitgutter_diff_relative_to
        # gitgutter_diff_base
        # gitgutter_git_args
        # gitgutter_diff_args
        # gitgutter_grep
        # gitgutter_enabled
        # gitgutter_signs
        # gitgutter_highlight_lines
        # gitgutter_highlight_linenrs
        # gitgutter_async
        # gitgutter_preview_win_floating
        # gitgutter_use_location_list
      };
    };
  };
}
