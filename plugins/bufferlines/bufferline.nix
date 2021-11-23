{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.bufferline;
  helpers = import ../helpers.nix { inherit lib; };
in
{
  options = {
    programs.nixvim.plugins.bufferline = {
      enable = mkEnableOption "Enable bufferline";
      numbers = mkOption {
        type = types.lines;
        description = "A lua function customizing the styling of numbers.";
        default = "";
      };
      closeCommand = mkOption {
        type = types.lines;
        description = "Command or function run when closing a buffer.";
        default = "";
      };
      rightMouseCommand = mkOption {
        type = types.lines;
        description = "Command or function run when right clicking on a buffer.";
        default = "";
      };
      leftMouseCommand = mkOption {
        type = types.lines;
        description = "Command or function run when clicking on a buffer.";
        default = "";
      };
      middleMouseCommand = mkOption {
        type = types.lines;
        description = "Command or function run when middle clicking on a buffer.";
        default = "";
      };
      indicatorIcon = mkOption {
        type = types.str;
        description = "The Icon shown as a indicator for buffer. Changing it is NOT recommended, 
        this is intended to be an escape hatch for people who cannot bear it for whatever reason.";
      };
      bufferCloseIcon = mkOption {
        type = types.str;
        description = "The close icon for each buffer.";
      };
      modifiedIcon = mkOption {
        type = types.str;
        description = "The icon indicating a buffer was modified.";
      };
      closeIcon = mkOption {
        type = types.str;
        description = "The close icon.";
      };
      leftTruncMarker = mkOption {
        type = types.str;
      };
      rightTruncMarker = mkOption {
        type = types.str;
      };
      nameFormatter = mkOption {
        type = types.lines;
        description = "A lua function that can be used to modify the buffer's lable. The argument 'buf' containing a name, path and bufnr is supplied.";
        default = "";
      };
      maxNameLength = mkOption {
        type = types.int;
        description = "Max length of a buffer name.";
        default = 18;
      };
      maxPrefixLength = mkOption {
        type = types.int;
        description = "Max length of a buffer prefix (used when a buffer is de-duplicated)";
        default = 15;
      };
      tabSize = mkOption {
        type = types.int;
        description = "Size of the tabs";
        default = 18;
      };
      diagnostics = mkOption {
        type = types.enum [ false "nvim_lsp" "coc" ];
        default = false;
      };
      diagnosticsUpdateInInsert = mkOption {
        type = types.bool;
        default = false;
      };
      diagnosticsIndicator = mkOption {
        type = types.lines;
        default = "";
      };
      customFilter = mkOption {
        type = types.lines;
        default = "";
      };
      showBufferIcons = mkOption {
        type = types.bool;
        default = true; 
      };
      showBufferCloseIcons = mkOption {
        type = types.bool;
        default = true;
      };
      showCloseIcon = mkOption {
        type = types.bool;
        default = true;
      };
      showTabIndicators = mkOption {
        type = types.bool;
        default = true;
      };
      persistBufferSort = mkOption {
        type = types.bool;
        default = true;
      };
      separatorStyle = mkOption {
        type = types.enum [ "slant" "thick" "thin" ];
      };
      enforceRegularTabs = mkOption {
        type = types.bool;
        default = false;
      };
      alwaysShowBufferline = mkOption {
        type = types.bool;
        default = true;
      };
      sortBy = mkOption {
        type = types.enum [ "id" "extension" "relative_directory" "directory" "tabs" ];
      };
    };
  };

  config = let 
    setupOptions = {
      options = {
        numbers = cfg.numbers;
        close_command = cfg.closeCommand;
        right_mouse_command = cfg.rightMouseCommand;
        left_mouse_command = cfg.leftMouseCommand;
        middle_mouse_command = cfg.middleMouseCommand;
        indicator_icon = cfg.indicatorIcon;
        buffer_close_icon = cfg.bufferCloseIcon;
        modified_icon = cfg.modifiedIcon;
        close_icon = cfg.closeIcon;
        left_trunc_marker = cfg.leftTruncMarker;
        right_trunc_marker = cfg.rightTruncMarker;
        name_formatter = cfg.nameFormatter;
        max_name_length = cfg.maxNameLength;
        max_prefix_length = cfg.maxPrefixLength;
        tab_size = cfg.tabSize;
        diagnostics = cfg.diagnostics;
        diagnostics_update_in_insert = cfg.diagnosticsUpdateInInsert;
        diagnostics_indicator = cfg.diagnosticsIndicator;
        custom_filter = cfg.customFilter;
        show_buffer_icons = cfg.showBufferIcons;
        show_buffer_close_icons = cfg.showBufferCloseIcons;
        show_close_icon = cfg.showCloseIcon;
        show_tab_indicators = cfg.showTabIndicators;
        persist_buffer_sort = cfg.persistBufferSort;
        separator_style = cfg.separatorStyle;
        enforce_regular_tabs = cfg.enforceRegularTabs;
        always_show_bufferline = cfg.alwaysShowBufferline;
        sort_by = cfg.sortBy;
      };
    };
    in mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = with pkgs.vimPlugins; [
        bufferline-nvim
        nvim-web-devicons
      ];
      options.termguicolors = true;
      extraConfigLua = ''
        require('bufferline').setup{${helpers.toLuaObject setupOptions}}
      '';
    };
  };
}
