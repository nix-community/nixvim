{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.bufferline;
  helpers = import ../helpers.nix { inherit lib; };

  highlight = mkOption {
    type = types.nullOr (types.submodule ({ ... }: {
      options = {
        guifg = mkOption {
          type = types.nullOr types.str;
          description = "foreground color";
          default = null;
        };
        guibg = mkOption {
          type = types.nullOr types.str;
          description = "background color";
          default = null;
        };
      };
    }));
    default = null;
  };
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
        default = "▎";
      };
      bufferCloseIcon = mkOption {
        type = types.str;
        description = "The close icon for each buffer.";
        default = "";
      };
      modifiedIcon = mkOption {
        type = types.str;
        description = "The icon indicating a buffer was modified.";
        default = "●";
      };
      closeIcon = mkOption {
        type = types.str;
        description = "The close icon.";
        default = "";
      };
      leftTruncMarker = mkOption {
        type = types.str;
        default = "";
      };
      rightTruncMarker = mkOption {
        type = types.str;
        default = "";
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
        default = "slant";
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
        default = "id";
      };
      highlights = mkOption {
        type = types.submodule {
          options = {
            fill = highlight;
            background = highlight;

            tab = highlight;
            tabSelected = highlight;
            tabClose = highlight;

            closeButton = highlight;
            closeButtonVisible = highlight;
            closeButtonSelected = highlight;

            bufferVisible = highlight;
            bufferSelected = highlight;

            diagnostic = highlight;
            diagnosticVisible = highlight;
            diagnosticSelected = highlight;

            info = highlight;
            infoVisible = highlight;
            infoSelected = highlight;

            infoDiagnostic = highlight;
            infoDiagnosticVisible = highlight;
            infoDiagnosticSelected = highlight;

            warning = highlight;
            warningVisible = highlight;
            warningSelected = highlight;

            warningDiagnostic = highlight;
            warningDiagnosticVisible = highlight;
            warningDiagnosticSelected = highlight;

            error = highlight;
            errorVisible = highlight;
            errorSelected = highlight;

            errorDiagnostic = highlight;
            errorDiagnosticVisible = highlight;
            errorDiagnosticSelected = highlight;

            modified = highlight;
            modifiedVisible = highlight;
            modifiedSelected = highlight;

            duplicate = highlight;
            duplicateVisible = highlight;
            duplicateSelected = highlight;

            separator = highlight;
            separatorVisible = highlight;
            separatorSelected = highlight;

            indicatorSelected = highlight;

            pick = highlight;
            pickVisible = highlight;
            pickSelected = highlight;
          };
        };
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
      highlights = with cfg.highlights; {
        fill = fill;
        background = background;

        tab = tab;
        tab_selected = tabSelected;
        tab_close = tabClose;
        close_button = closeButton;
        close_button_visible = closeButtonVisible;
        close_button_selected = closeButtonSelected;

        buffer_visible = bufferVisible;
        buffer_selected = bufferSelected;

        diagnostic = diagnostic;
        diagnostic_visible = diagnosticVisible;
        diagnostic_selected = diagnosticSelected;

        info = info;
        info_visible = infoVisible;
        info_selected = infoSelected;

        info_diagnostic = infoDiagnostic;
        info_diagnostic_visible = infoDiagnosticVisible;
        info_diagnostic_selected = infoDiagnosticSelected;

        warning = warning;
        warning_visible = warningVisible;
        warning_selected = warningSelected;

        warning_diagnostic = warningDiagnostic;
        warning_diagnostic_visible = warningDiagnosticVisible;
        warning_diagnostic_selected = warningDiagnosticSelected;

        error = error;
        error_visible = errorVisible;
        error_selected = errorSelected;

        error_dagnostic = errorDiagnostic;
        error_diagnostic_visible = errorDiagnosticVisible;
        error_diagnostic_selected = errorDiagnosticSelected;

        modified = modified;
        modified_visible = modifiedVisible;
        modified_selected = modifiedSelected;

        duplicate = duplicate;
        duplicate_visible = duplicateVisible;
        duplicate_selected = duplicateSelected;

        separator = separator;
        separator_visible = separatorVisible;
        separator_selected = separatorSelected;

        indicator_selected = indicatorSelected;

        pick = pick;
        pick_visible = pickVisible;
        pick_selected = pickSelected;

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
        require('bufferline').setup${helpers.toLuaObject setupOptions}
      '';
    };
  };
}
