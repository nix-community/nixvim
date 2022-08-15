{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.nvim-tree;
  helpers = import ../helpers.nix { lib = lib; };
in
{
  options.programs.nixvim.plugins.nvim-tree = {
    enable = mkEnableOption "Enable nvim-tree";

    disableNetrw = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = "Disable netrw";
    };

    hijackNetrw = mkOption  {
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

    updateCwd = mkOption {
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

      icons = let
        diagnosticOption = desc: mkOption {
          type = types.nullOr types.str;
          default = null;
          description = desc;
        };
      in {
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
        type = types.nullOr types.str;
        default = null;
      };
      height = mkOption {
        type = types.nullOr types.str;
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

  config = let
    options = {
      disable_netrw = cfg.disableNetrw;
      hijack_netrw = cfg.hijackNetrw;
      open_on_setup = cfg.openOnSetup;
      ignore_ft_on_setup = cfg.ignoreFtOnSetup;
      auto_close = cfg.autoClose;
      open_on_tab = cfg.openOnTab;
      hijack_cursor = cfg.hijackCursor;
      update_cwd = cfg.updateCwd;
      update_to_buf_dir = {
        enable = cfg.updateToBufDir.enable;
        auto_open = cfg.updateToBufDir.autoOpen;
      };
      diagnostics = cfg.diagnostics;
      updateFocusedFile = {
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
  in mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = with pkgs.vimPlugins; [
        nvim-tree-lua nvim-web-devicons
      ];

      extraConfigLua = ''
        require('nvim-tree').setup(${helpers.toLuaObject options})
      '';
    };
  };
}
