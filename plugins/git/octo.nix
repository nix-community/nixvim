{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.octo;

  sectionDefaultsModule = types.submodule {
    options = {
      folded = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };
    };
  };
in {
  options = {
    plugins.octo = {
      enable = mkEnableOption "octo";

      package = helpers.mkPackageOption "octo" pkgs.vimPlugins.octo;

      use_local_fs = mkOption {
        description = "Use local files on right side of reviews";
        type = types.nullOr types.bool;
        default = false;
      };

      enable_builtin = mkOption {
        description = "Shows a list of builtin actions when no action is provided";
        type = types.nullOr types.bool;
        default = false;
      };

      default_remote = mkOption {
        description = "Shows a list of builtin actions when no action is provided";
        type = types.nullOr types.list;
        default = ["upstream" "origin"];
      };

      ssh_aliases = mkOption {
        description = "SSH aliases. e.g. `ssh_aliases = {[" github.com-work "] = " github.com "}`";
        type = types.nullOr types.dict;
        default = {};
      };

      picker_config = mkOption {
        description = "Picker configuration";
        type = types.submodule {
          options = {
            kind = mkOption {
              type = mkOption {
                type = types.submodule {
                  options = {
                    open_in_browser = mkOption {
                      type = types.nullOr types.dict;
                      default = {
                        lhs = "<C-b>";
                        desc = "open issue in browser";
                      };
                    };

                    copy_url = mkOption {
                      type = types.nullOr types.dict;
                      default = {
                        lhs = "<C-y>";
                        desc = "copy url to system clipboard";
                      };
                    };

                    checkout_pr = mkOption {
                      type = types.nullOr types.dict;
                      default = {
                        lhs = "<C-o>";
                        desc = "checkout pull request";
                      };
                    };

                    merge_pr = mkOption {
                      type = types.nullOr types.dict;
                      default = {
                        lhs = "<C-r>";
                        desc = "merge pull request";
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };

      reaction_viewer_hint_icon = mkOption {
        description = "Marker for user reactions";
        type = types.nullOr types.string;
        default = "";
      };

      user_icon = mkOption {
        description = "User Icon";
        type = types.nullOr types.string;
        default = " ";
      };

      timeline_marker = mkOption {
        description = "Timeline marker";
        type = types.nullOr types.string;
        default = "";
      };

      timeline_indent = mkOption {
        description = "Timeline indentation";
        type = types.nullOr types.string;
        default = "2";
      };

      right_bubble_delimiter = mkOption {
        description = "Bubble delimiter";
        type = types.nullOr types.string;
        default = "";
      };

      left_bubble_delimiter = mkOption {
        description = "Bubble delimiter";
        type = types.nullOr types.string;
        default = "";
      };

      github_hostname = mkOption {
        description = "GitHub Enterprise host";
        type = types.nullOr types.string;
        default = "";
      };

      snippet_context_lines = mkOption {
        description = "Number or lines around commented lines";
        type = types.nullOr types.int;
        default = 4;
      };

      gh_env = mkOption {
        description = "Extra environment variables to pass on to GitHub CLI, can be a table or function returning a table";
        type = types.nullOr types.dict;
        default = {};
      };

      timeout = mkOption {
        description = "Timeout for requests between the remote server";
        type = types.nullOr types.int;
        default = 5000;
      };

      ui = {
        description = "UI options";
        type = types.submodule {
          options = {
            use_sign_column = mkOption {
              description = "Show \"modified\" marks on the sign column";
              type = types.nullOr types.bool;
              default = true;
            };
          };
        };
      };

      issues = {
        description = "Issues options";
        type = types.submodule {
          options = {
            order_by = mkOption {
              description = "Criteria to sort results of `Octo issue list`";
              type = types.submodule {
                options = {
                  field = mkOption {
                    description = "Either COMMENTS, CREATED_AT or UPDATED_AT (https://docs.github.com/en/graphql/reference/enums#issueorderfield)";
                    type = types.nullOr types.str;
                    default = "CREATED_AT";
                  };
                  direction = mkOption {
                    description = "Either DESC or ASC (https://docs.github.com/en/graphql/reference/enums#orderdirection)";
                    type = types.nullOr types.str;
                    default = "DESC";
                  };
                };
              };
              default = true;
            };
          };
        };
      };
    };
  };

  config = let
    setupOptions = with cfg;
      helpers.toLuaObject {
        # inherit kind integrations signs sections mappings;
        # disable_signs = disableSigns;
        # disable_hint = disableHint;
        # disable_context_highlighting = disableContextHighlighting;
        # disable_commit_confirmation = disableCommitConfirmation;
        # auto_refresh = autoRefresh;
        # disable_builtin_notifications = disableBuiltinNotifications;
        # use_magit_keybindings = useMagitKeybindings;
        # commit_popup = commitPopup;
      };
  in
    mkIf cfg.enable {
      extraPlugins = with pkgs.vimPlugins;
        [
          cfg.package
          plenary-nvim
        ]
        ++ optional cfg.integrations.diffview diffview-nvim;

      extraPackages = [pkgs.git];

      extraConfigLua = ''
        require('octo').setup(${setupOptions})
      '';
    };
}
