{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.neogit;
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
    programs.nixvim.plugins.neogit = {
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
              type = types.nullOr (types.listOf types.str);
              default = null;
            };

            item = mkOption {
              type = types.nullOr (types.listOf types.str);
              default = null;
            };

            hunk = mkOption {
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
              type = types.nullOr sectionDefaultsModule;
              default = null;
            };
            unstaged = mkOption {
              type = types.nullOr sectionDefaultsModule;
              default = null;
            };
            staged = mkOption {
              type = types.nullOr sectionDefaultsModule;
              default = null;
            };
            stashes = mkOption {
              type = types.nullOr sectionDefaultsModule;
              default = null;
            };
            unpulled = mkOption {
              type = types.nullOr sectionDefaultsModule;
              default = null;
            };
            unmerged = mkOption {
              type = types.nullOr sectionDefaultsModule;
              default = null;
            };
            recent = mkOption {
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
