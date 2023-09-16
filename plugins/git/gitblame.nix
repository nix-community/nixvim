{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.gitblame;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options = {
    plugins.gitblame = {
      enable = mkEnableOption "gitblame";

      package = helpers.mkPackageOption "gitblame" pkgs.vimPlugins.git-blame-nvim;

      messageTemplate = mkOption {
        type = types.str;
        default = "  <author> • <date> • <summary>";
        description = "The template for the blame message that will be shown.";
      };

      dateFormat = mkOption {
        type = types.str;
        default = "%c";
        description = "The format of the date fields in messageTemplate.";
      };

      messageWhenNotCommitted = mkOption {
        type = types.str;
        default = "  Not Committed Yet";
        description = "The blame message that will be shown when the current modification hasn't been committed yet.";
      };

      highlightGroup = mkOption {
        type = types.str;
        default = "Comment";
        description = "The highlight group for virtual text.";
      };

      enableVirtualText = mkOption {
        type = types.bool;
        default = true;
        description = "If the blame message should be displayed as virtual text. You may want to disable this if you display the blame message in statusline.";
      };

      ignoredFiletypes = mkOption {
        type = with types; listOf str;
        default = [];
        description = "A list of filetypes for which gitblame information will not be displayed.";
      };

      delay = mkOption {
        type = types.int;
        default = 0;
        description = "The delay in milliseconds after which the blame info will be displayed.";
      };

      virtualTextColumn = mkOption {
        type = with types; nullOr int;
        default = null;
        description = "Have the blame message start at a given column instead of EOL. If the current line is longer than the specified column value the blame message will default to being displayed at EOL.";
      };

      extmarkOptions = mkOption {
        type = with types; nullOr attrs;
        default = null;
        description = "nvim_buf_set_extmark optional parameters. (Warning: overwriting id and virt_text will break the plugin behavior)";
      };
    };
  };

  config = let
    setupOptions = {
      enabled = cfg.enable;
      message_template = cfg.messageTemplate;
      date_format = cfg.dateFormat;
      message_when_not_committed = cfg.messageWhenNotCommitted;
      highlight_group = cfg.highlightGroup;
      display_virtual_text =
        if cfg.enableVirtualText
        then 1
        else 0;
      ignored_filetypes = cfg.ignoredFiletypes;
      inherit (cfg) delay;
      virtual_text_column = cfg.virtualTextColumn;
      set_extmark_options = cfg.extmarkOptions;
    };
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraPackages = [pkgs.git];

      extraConfigLua = ''
        require('gitblame').setup${helpers.toLuaObject setupOptions}
      '';
    };
}
