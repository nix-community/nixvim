{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.plugins.nvim-tree;
  helpers = import ../helpers.nix { lib = lib; };
in
{
  options.plugins.nvim-tree = {
    enable = mkEnableOption "Enable nvim-tree";

    package = mkOption {
      type = types.package;
      default = pkgs.vimPlugins.nvim-tree-lua;
      description = "Plugin to use for nvim-tree";
    };

    disableNetrw = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = "Disable netrw";
    };

    hijackNetrw = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = "Hijack netrw";
    };

    openOnSetup = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = "Open on setup";
    };

    ignoreFtOnSetup = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
    };

    autoClose = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = "Automatically close";
    };

    openOnTab = mkOption {
      type = types.nullOr types.bool;
      default = null;
    };

    hijackCursor = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = "Hijack cursor";
    };

    # TODO: change this to it's new definition sync_root_with_cwd
    updateCwd = mkOption {
      type = types.nullOr types.bool;
      default = null;
    };

    respectBufCwd = mkOption {
      type = types.nullOr types.bool;
      default = null;
    };

    updateToBufDir = {
      enable = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };

      autoOpen = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };
    };

    diagnostics = {
      enable = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Enable diagnostics";
      };

      icons =
        let
          diagnosticOption = desc: mkOption {
            type = types.nullOr types.str;
            default = null;
            description = desc;
          };
        in
        {
          hint = diagnosticOption "Hints";
          info = diagnosticOption "Info";
          warning = diagnosticOption "Warning";
          error = diagnosticOption "Error";
        };
    };

    updateFocusedFile = {
      enable = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };

      # TODO: change this to it's new definition update_root
      updateCwd = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };

      ignoreList = mkOption {
        type = types.nullOr (types.listOf types.bool);
        default = null;
      };
    };

    systemOpen = {
      cmd = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      args = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
      };
    };

    git = {
      enable = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Enable git integration";
      };

      ignore = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };

      timeout = mkOption {
        type = types.nullOr types.int;
        default = null;
      };
    };

    filters = {
      dotfiles = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };
      custom = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
      };
    };

    view = {
      width = mkOption {
        type = types.nullOr types.int;
        default = null;
      };
      height = mkOption {
        type = types.nullOr types.int;
        default = null;
      };
      hideRootFolder = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };
      side = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      autoResize = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };
      mappings = {
        customOnly = mkOption {
          type = types.nullOr types.bool;
          default = null;
        };
        list = mkOption {
          # TODO: Type-check the attrset
          type = types.nullOr (types.listOf types.attrs);
          default = null;
        };
      };
      number = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };
      relativenumber = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };
      signcolumn = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
    };

    trash = {
      cmd = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      requireConfirm = mkOption {
        type = types.nullOr types.bool;
        default = null;
      };
    };
  };

  config =
    let
      options = {
        disable_netrw = cfg.disableNetrw;
        hijack_netrw = cfg.hijackNetrw;
        open_on_setup = cfg.openOnSetup;
        ignore_ft_on_setup = cfg.ignoreFtOnSetup;
        open_on_tab = cfg.openOnTab;
        hijack_cursor = cfg.hijackCursor;
        update_cwd = cfg.updateCwd;
        respect_buf_cwd = cfg.respectBufCwd;
        update_to_buf_dir = {
          enable = cfg.updateToBufDir.enable;
          auto_open = cfg.updateToBufDir.autoOpen;
        };
        diagnostics = cfg.diagnostics;
        update_focused_file = {
          enable = cfg.updateFocusedFile.enable;
          update_cwd = cfg.updateFocusedFile.updateCwd;
          ignore_list = cfg.updateFocusedFile.ignoreList;
        };
        system_open = cfg.systemOpen;
        filters = cfg.filters;
        git = cfg.git;
        view = {
          width = cfg.view.width;
          height = cfg.view.height;
          hide_root_folder = cfg.view.hideRootFolder;
          side = cfg.view.side;
          auto_resize = cfg.view.autoResize;
          mappings = {
            custom_only = cfg.view.mappings.customOnly;
            list = cfg.view.mappings.list;
          };
          number = cfg.view.number;
          relativenumber = cfg.view.relativenumber;
          signcolumn = cfg.view.signcolumn;
        };
        trash = {
          cmd = cfg.trash.cmd;
          require_confirm = cfg.trash.requireConfirm;
        };
      };
    in
    mkIf cfg.enable {
      extraPlugins = with pkgs.vimPlugins; [
        cfg.package
        nvim-web-devicons
      ];

      autoCmd = mkIf (cfg.autoClose != null && cfg.autoClose) [
        {
          event = "BufEnter";
          command = "if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif";
          nested = true;
        }
      ];

      extraConfigLua = ''
        require('nvim-tree').setup(${helpers.toLuaObject options})
      '';
      extraPackages = [ pkgs.git ];
    };
}
