{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.plugins.neogit;
  helpers = import ../helpers.nix { inherit lib; };

  sectionDefaultsModule = types.submodule {
    options = {
      folded = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };
    };
  };
in
{
  options = {
    plugins.neogit = {
      enable = mkEnableOption "Enable neogit";

      disableSigns = mkOption {
        description = "Disable signs";
        type = types.nullOr types.bool;
        default = null;
      };

      disableHint = mkOption {
        description = "Disable hint";
        type = types.nullOr types.bool;
        default = null;
      };

      disableContextHighlighting = mkOption {
        description = "Disable the context highlighting";
        type = types.nullOr types.bool;
        default = null;
      };

      disableCommitConfirmation = mkOption {
        description = "Disable the commit confirmation prompt";
        type = types.nullOr types.bool;
        default = null;
      };

      autoRefresh = mkOption {
        description = "Enable Auto Refresh";
        type = types.nullOr types.bool;
        default = null;
      };

      disableBuiltinNotifications = mkOption {
        description = "Disable builtin notifications";
        type = types.nullOr types.bool;
        default = null;
      };

      useMagitKeybindings = mkOption {
        description = "Enable Magit keybindings";
        type = types.nullOr types.bool;
        default = null;
      };

      commitPopup = mkOption {
        description = "Commit popup configuration";
        type = types.submodule {
          options = {
            kind = mkOption {
              type = types.nullOr types.str;
              default = null;
            };
          };
        };
        default = { };
      };

      kind = mkOption {
        description = "The way of opening neogit";
        type = types.nullOr types.str;
        default = null;
      };

      signs = mkOption {
        description = "Customize displayed signs";
        type = types.submodule {
          options = {
            section = mkOption {
              description = "Cosed and opened signs for sections";
              type = types.nullOr (types.listOf types.str);
              default = null;
            };

            item = mkOption {
              description = "Cosed and opened signs for items";
              type = types.nullOr (types.listOf types.str);
              default = null;
            };

            hunk = mkOption {
              description = "Cosed and opened signs for hunks";
              type = types.nullOr (types.listOf types.str);
              default = null;
            };
          };
        };
        default = { };
      };

      integrations = mkOption {
        description = "Tools integration";
        type = types.submodule {
          options = {
            diffview = mkOption {
              description = "Enable diff popup";
              type = types.bool;
              default = false;
            };
          };
        };
        default = { };
      };

      sections = mkOption {
        description = "Section configuration";
        type = types.submodule {
          options = {
            untracked = mkOption {
              description = "Options for untracked section";
              type = types.nullOr sectionDefaultsModule;
              default = null;
            };
            unstaged = mkOption {
              description = "Options for unstaged section";
              type = types.nullOr sectionDefaultsModule;
              default = null;
            };
            staged = mkOption {
              description = "Options for staged section";
              type = types.nullOr sectionDefaultsModule;
              default = null;
            };
            stashes = mkOption {
              description = "Options for stashes section";
              type = types.nullOr sectionDefaultsModule;
              default = null;
            };
            unpulled = mkOption {
              description = "Options for unpulled section";
              type = types.nullOr sectionDefaultsModule;
              default = null;
            };
            unmerged = mkOption {
              description = "Options for unmerged section";
              type = types.nullOr sectionDefaultsModule;
              default = null;
            };
            recent = mkOption {
              description = "Options for recent commits section";
              type = types.nullOr sectionDefaultsModule;
              default = null;
            };
          };
        };
        default = { };
      };

      mappings = mkOption {
        description = "Custom mappings";
        type = types.submodule {
          options = {
            status = mkOption {
              type = types.nullOr (types.attrsOf (types.enum [
                "Close"
                "Depth1"
                "Depth2"
                "Depth3"
                "Depth4"
                "Toggle"
                "Discard"
                "Stage"
                "StageUnstaged"
                "StageAll"
                "GoToFile"
                "Unstaged"
                "UnstagedStage"
                "CommandHistory"
                "RefreshBuffer"
                "HelpPopup"
                "PullPopup"
                "PushPopup"
                "CommitPopup"
                "LogPopup"
                "StashPopup"
                "BranchPopup"
              ]));
              default = null;
            };
          };
        };
        default = { };
      };
    };
  };

  config = let 
    setupOptions = with cfg; helpers.toLuaObject {
      inherit kind integrations signs sections mappings;
      disable_signs = disableSigns;
      disable_hint = disableHint;
      disable_context_highlighting = disableContextHighlighting;
      disable_commit_confirmation = disableCommitConfirmation;
      auto_refresh = autoRefresh;
      disable_builtin_notifications = disableBuiltinNotifications;
      use_magit_keybindings = useMagitKeybindings;
      commit_popup = commitPopup;
    };
  in mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = with pkgs.vimPlugins; [
        neogit
        plenary-nvim
      ] ++ optional cfg.integrations.diffview diffview-nvim;

      extraConfigLua = ''
        require('neogit').setup(${setupOptions})
      '';
    };
  };
}
