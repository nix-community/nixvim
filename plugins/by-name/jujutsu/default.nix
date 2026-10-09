{ lib, ... }:
let
  inherit (lib) mkOption;

  actions = {
    "show_help" = "Show keybindings help window";
    "quit" = "Close the log window";
    "jump_to_next_change" = "Navigate to next change";
    "jump_to_prev_change" = "Navigate to previous change";
    "jump_to_current_change" = "Navigate to the currently edited change";
    "refresh" = "Refresh the log view";
    "undo" = "Undo the last operation";
    "set_revset" = "Open log with custom revset";
    "switch_diff_viewer" = "Switch between diff viewer presets";
    "show_global_flags" = "Show menu to toggle global jj flags";
    "open_diff" = "Open diff viewer for change";
    "describe" = "Edit change description";
    "new_change" = "Create new change";
    "new_change_menu" = "Show new change options menu";
    "abandon_changes" = "Abandon change(s)";
    "absorb_changes" = "Absorb change(s)";
    "edit_change" = "Check out change";
    "edit_change_menu" = "Show edit change options menu";
    "rebase_change" = "Rebase change";
    "squash_change" = "Squash change";
    "squash_to_target" = "Squash to specific target";
    "bookmark_change" = "Set/create bookmark";
    "bookmark_menu" = "Show bookmark operations";
    "push_bookmarks" = "Push bookmarks";
    "push_bookmarks_and_create" = "Push bookmarks with --allow-new";
    "git_fetch" = "Fetch from remote";
    "pull_bookmark" = "Pull bookmark from remote";
    "toggle_change" = "Toggle multi-selection";
    "clear_selections" = "Clear all selections";
  };

  keys = lib.nixvim.keymaps.mkMapOptionSubmodule {
    key = false;

    action = false;
    defaults.mode = "";
    extraOptions = {
      cmd = mkOption {
        type = lib.types.maybeRaw (lib.types.enum (builtins.attrNames actions));
        description = "Command to execute";
      };

      desc = mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
    };

    extraModules = [
      (
        { config, lib, ... }:
        let
          isBuiltin = actions ? config.action;

          defaultDesc = if isBuiltin then actions.${config.action} else null;
        in
        {
          config = {
            desc = lib.mkDefault defaultDesc;
          };
        }
      )
    ];
  };
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "jujutsu";
  moduleName = "jujutsu-nvim";
  package = "jujutsu-nvim";

  maintainers = [ lib.maintainers.auscyber ];
  extraConfig =
    cfg:
    let
      possible-sources = [
        "diffview"
        "codediff"
      ];
    in
    {
      plugins = lib.genAttrs' possible-sources (name: {
        inherit name;
        value.enable = lib.mkIf (cfg.settings.diff_preset == name) true;
      }

      );
    };

  settingsOptions = {
    diff_preset = lib.nixvim.defaultNullOpts.mkEnum [
      "difftastic"
      "diffview"
      "codediff"
      "none"
    ] "none" "diff view preset";
    help_position = lib.nixvim.defaultNullOpts.mkEnum [
      "center"
      "bottom_right"
    ] "center" "The help window (opened with ?) can be positioned in different locations";
    keymap = lib.mkOption {
      type = lib.types.attrsOf (lib.types.either keys lib.types.bool);
      description = "Keymaps for jujutsu-nvim";
      default = { };

    };

    # TODO provide an example for the `settings` option (or remove entirely if there is no useful example)
    # NOTE you can use `lib.literalExpression` or `lib.literalMD` if needed

  };
}
