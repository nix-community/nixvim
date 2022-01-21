{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.dashboard;
in
{
  options = {
    programs.nixvim.plugins.dashboard = {
      enable = mkEnableOption "Enable dashboard";

      executive = mkOption {
        description = "Select the fuzzy search plugin";
        type = types.nullOr (types.enum [ "clap" "fzf" "telescope" ]);
        default = null;
      };

      shortcuts = mkOption {
        description = "Set the fuzzy search keymaps";
        type = types.nullOr (types.attrsOf types.str);
        default = null;
      };

      shortcutsIcon = mkOption {
        description = "Icons for shortcuts";
        type = types.nullOr (types.attrsOf types.str);
        default = null;
      };

      header = mkOption {
        description = "Header text";
        type = with types; nullOr (listOf str);
        default = null;
      };

      footer = mkOption {
        description = "Footer text";
        type = with types; nullOr (listOf str);
        default = null;
      };

      sessionDirectory = mkOption {
        description = "Set the session folder";
        type = types.nullOr types.str;
        default = null;
      };

      sections = mkOption {
        description = "Set your own sections";
        type = types.nullOr (types.attrsOf (types.submodule {
          options = {
            description = mkOption {
              description = "String shown in Dashboard buffer";
              type = types.str;
            };

            command = mkOption {
              description = "Command or funcref";
              type = types.str;
            };
          };
        }));
        default = { };
      };

      preview = mkOption {
        description = "Preview options";
        type = types.submodule {
          options = {
            command = mkOption {
              description = "Command that can print output to neovim built-in terminal";
              type = types.nullOr types.str;
              default = null;
            };

            pipeline = mkOption {
              description = "Pipeline command";
              type = types.nullOr types.str;
              default = null;
            };

            file = mkOption {
              description = "Path to preview file";
              type = types.nullOr types.str;
              default = null;
            };

            height = mkOption {
              description = "The height of the preview file";
              type = types.nullOr types.int;
              default = null;
            };

            width = mkOption {
              description = "The width of the preview file";
              type = types.nullOr types.int;
              default = null;
            };
          };
        };
        default = { };
      };

      fzf = mkOption {
        description = "Some options for fzf";
        type = types.submodule {
          options = {
            float = mkOption {
              description = "Fzf floating window mode";
              type = types.nullOr types.int;
              default = null;
            };

            engine = mkOption {
              description = "Grep tool to fzf use";
              type = types.nullOr (types.enum [ "rg" "ag" ]);
              default = null;
            };
          };
        };
        default = { };
      };
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = [ pkgs.vimPlugins.dashboard-nvim ];
      extraPackages = if (cfg.fzf.engine == "ag") then [ pkgs.silver-searcher ]
        else [ pkgs.ripgrep ];

      globals = {
        dashboard_default_executive = mkIf (!isNull cfg.executive) cfg.executive;
        dashboard_custom_shortcut = mkIf (!isNull cfg.shortcuts) cfg.shortcuts;
        dashboard_custom_shortcut_icon = mkIf (!isNull cfg.shortcutsIcon) cfg.shortcutsIcon;
        dashboard_custom_header = mkIf (!isNull cfg.header) cfg.header;
        dashboard_custom_footer = mkIf (!isNull cfg.footer) cfg.footer;
        dashboard_session_directory = mkIf (!isNull cfg.sessionDirectory) cfg.sessionDirectory;
        dashboard_custom_sections = mkIf (!isNull cfg.sections) cfg.sections;
        dashboard_preview_command = mkIf (!isNull cfg.preview.command) cfg.preview.command;
        dashboard_preview_pipeline = mkIf (!isNull cfg.preview.pipeline) cfg.preview.pipeline;
        dashboard_preview_file = mkIf (!isNull cfg.preview.file) cfg.preview.file;
        dashboard_preview_file_height = mkIf (!isNull cfg.preview.height) cfg.preview.height;
        dashboard_preview_file_width = mkIf (!isNull cfg.preview.width) cfg.preview.width;
        dashboard_fzf_float = mkIf (!isNull cfg.fzf.float) cfg.fzf.float;
        dashboard_fzf_engine = mkIf (!isNull cfg.fzf.engine) cfg.fzf.engine;
      };
    };
  };
}
