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
        type = types.nullOr types.bool;
        default = null;
      };

      disableHint = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };

      disableContextHighlighting = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };

      disableCommitConfirmation = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };

      autoRefresh = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };

      disableBuiltinNotifications = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };

      useMagitKeybindings = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };

      commitPopup = mkOption {
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
        type = types.nullOr types.str;
      };

      signs = mkOption {
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
        type = types.submodule {
          options = {
            diffview = mkOption {
              type = types.bool;
              default = false;
            };
          };
        };
        default = { };
      };

      sections = mkOption {
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
      inherit integrations sections mappings;
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
