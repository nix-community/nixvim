{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.gitgutter;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options = {
    plugins.gitgutter = {
      enable = mkEnableOption "gitgutter";

      package = helpers.mkPackageOption "gitgutter" pkgs.vimPlugins.gitgutter;

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

      signs = mkOption {
        type = let
          signOption = desc:
            mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Sign for ${desc}";
            };
        in
          types.submodule {
            options = {
              added = signOption "added lines";
              modified = signOption "modified lines";
              removed = signOption "removed lines";
              modifiedAbove = signOption "modified line above";
              removedFirstLine = signOption "a removed first line";
              removedAboveAndBelow = signOption "lines removed above and  below";
              modifiedRemoved = signOption "modified and removed lines";
            };
          };
        default = {};
        description = "Custom signs for the sign column";
      };

      diffRelativeToWorkingTree = mkOption {
        type = types.bool;
        default = false;
        description = "Make diffs relative to the working tree instead of the index";
      };

      extraGitArgs = mkOption {
        type = types.str;
        default = "";
        description = "Extra arguments to pass to git";
      };

      extraDiffArgs = mkOption {
        type = types.str;
        default = "";
        description = "Extra arguments to pass to git diff";
      };

      grep = mkOption {
        type = types.nullOr (types.oneOf [
          (types.submodule {
            options = {
              command = mkOption {
                type = types.str;
                description = "The command to use as a grep alternative";
              };

              package = mkOption {
                type = types.package;
                description = "The package of the grep alternative to use";
              };
            };
          })
          types.str
        ]);
        default = null;
        description = "A non-standard grep to use instead of the default";
      };

      enableByDefault = mkOption {
        type = types.bool;
        default = true;
        description = "Enable gitgutter by default";
      };

      signsByDefault = mkOption {
        type = types.bool;
        default = true;
        description = "Show signs by default";
      };

      highlightLines = mkOption {
        type = types.bool;
        default = true;
        description = "Highlight lines by default";
      };

      highlightLineNumbers = mkOption {
        type = types.bool;
        default = true;
        description = "Highlight line numbers by default";
      };

      runAsync = mkOption {
        type = types.bool;
        default = true;
        description = "Disable this to run git diff syncrhonously instead of asynchronously";
      };

      previewWinFloating = mkOption {
        type = types.bool;
        default = false;
        description = "Preview hunks on floating windows";
      };

      useLocationList = mkOption {
        type = types.bool;
        default = false;
        description = "Load chunks into windows's location list instead of the quickfix list";
      };

      terminalReportFocus = mkOption {
        type = types.bool;
        default = true;
        description = "Let the terminal report its focus status";
      };
    };
  };

  config = let
    grepPackage =
      if builtins.isAttrs cfg.grep
      then [cfg.grep.package]
      else [];
    grepCommand =
      if builtins.isAttrs cfg.grep
      then cfg.grep.command
      else cfg.grep;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      options = mkIf cfg.recommendedSettings {
        updatetime = 100;
        foldtext = "gitgutter#fold#foldtext";
      };

      extraPackages = [pkgs.git] ++ grepPackage;

      globals = {
        gitgutter_max_signs = mkIf (cfg.maxSigns != null) cfg.maxSigns;
        gitgutter_show_msg_on_hunk_jumping = mkIf (!cfg.showMessageOnHunkJumping) 0;
        gitgutter_map_keys = mkIf (!cfg.defaultMaps) 0;
        gitgutter_sign_allow_clobber = mkIf cfg.allowClobberSigns 1;
        gitgutter_sign_priority = mkIf (cfg.signPriority != null) cfg.signPriority;
        gitgutter_set_sign_backgrounds = mkIf cfg.matchBackgrounds 1;

        gitgutter_sign_added = mkIf (cfg.signs.added != null) cfg.signs.added;
        gitgutter_sign_modified = mkIf (cfg.signs.modified != null) cfg.signs.modified;
        gitgutter_sign_removed = mkIf (cfg.signs.removed != null) cfg.signs.removed;
        gitgutter_sign_removed_first_line = mkIf (cfg.signs.removedFirstLine != null) cfg.signs.removedFirstLine;
        gitgutter_sign_removed_above_and_bellow = mkIf (cfg.signs.removedAboveAndBelow != null) cfg.signs.removedAboveAndBelow;
        gitgutter_sign_modified_above = mkIf (cfg.signs.modifiedAbove != null) cfg.signs.modifiedAbove;

        gitgutter_diff_relative_to = mkIf cfg.diffRelativeToWorkingTree "working_tree";
        gitgutter_git_args = mkIf (cfg.extraGitArgs != "") cfg.extraGitArgs;
        gitgutter_diff_args = mkIf (cfg.extraDiffArgs != "") cfg.extraDiffArgs;

        gitgutter_grep = mkIf (grepCommand != null) grepCommand;

        gitgutter_enabled = mkIf (!cfg.enableByDefault) 0;
        gitgutter_signs = mkIf (!cfg.signsByDefault) 0;

        gitgutter_highlight_lines = mkIf (!cfg.highlightLines) 0;
        gitgutter_highlight_linenrs = mkIf (!cfg.highlightLineNumbers) 0;
        gitgutter_async = mkIf (!cfg.runAsync) 0;
        gitgutter_preview_win_floating = mkIf cfg.previewWinFloating 1;
        gitgutter_use_location_list = mkIf cfg.useLocationList 1;

        gitgutter_terminal_report_focus = mkIf (!cfg.terminalReportFocus) 0;
      };
    };
}
