{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.gitblame;
in
{
  options = {
    plugins.gitblame = {
      enable = mkEnableOption "gitblame";

      autoEnable = defaultNullOpts.mkBool true "Dictates the git blame messages should be enabled on startup, can be toggled with :GitBlameToggle";

      package = helpers.mkPluginPackageOption "gitblame" pkgs.vimPlugins.git-blame-nvim;

      messageTemplate = helpers.defaultNullOpts.mkStr "  <author> • <date> • <summary>" "The template for the blame message that will be shown.";

      dateFormat = helpers.defaultNullOpts.mkStr "%c" "The format of the date fields in messageTemplate.";

      messageWhenNotCommitted = helpers.defaultNullOpts.mkStr "  Not Committed Yet" "The blame message that will be shown when the current modification hasn't been committed yet.";

      highlightGroup = helpers.defaultNullOpts.mkStr "Comment" "The highlight group for virtual text.";

      displayVirtualText = helpers.defaultNullOpts.mkBool true "If the blame message should be displayed as virtual text. You may want to disable this if you display the blame message in statusline.";

      ignoredFiletypes =
        helpers.defaultNullOpts.mkListOf types.str [ ]
          "A list of filetypes for which gitblame information will not be displayed.";

      delay =
        helpers.defaultNullOpts.mkUnsignedInt 0
          "The delay in milliseconds after which the blame info will be displayed.";

      virtualTextColumn =
        helpers.defaultNullOpts.mkNullable types.ints.unsigned null
          "Have the blame message start at a given column instead of EOL. If the current line is longer than the specified column value the blame message will default to being displayed at EOL.";

      extmarkOptions = helpers.defaultNullOpts.mkAttributeSet null "nvim_buf_set_extmark optional parameters. (Warning: overwriting id and virt_text will break the plugin behavior)";
    };
  };

  config =
    let
      setupOptions = {
        enabled = cfg.autoEnable;
        message_template = cfg.messageTemplate;
        date_format = cfg.dateFormat;
        message_when_not_committed = cfg.messageWhenNotCommitted;
        highlight_group = cfg.highlightGroup;
        display_virtual_text = helpers.ifNonNull' cfg.displayVirtualText (
          if cfg.displayVirtualText then 1 else 0
        );
        ignored_filetypes = cfg.ignoredFiletypes;
        inherit (cfg) delay;
        virtual_text_column = cfg.virtualTextColumn;
        set_extmark_options = cfg.extmarkOptions;
      };
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      extraPackages = [ pkgs.git ];

      extraConfigLua = ''
        require('gitblame').setup${helpers.toLuaObject setupOptions}
      '';
    };
}
