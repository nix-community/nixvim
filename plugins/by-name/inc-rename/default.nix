{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
{
  options.plugins.inc-rename = {
    enable = mkEnableOption "inc-rename, a plugin previewing LSP renaming";

    package = lib.mkPackageOption pkgs "inc-rename" {
      default = [
        "vimPlugins"
        "inc-rename-nvim"
      ];
    };

    cmdName = helpers.defaultNullOpts.mkStr "IncRename" "the name of the command";

    hlGroup = helpers.defaultNullOpts.mkStr "Substitute" "the highlight group used for highlighting the identifier's new name";

    previewEmptyName = helpers.defaultNullOpts.mkBool false ''
      whether an empty new name should be previewed; if false the command preview will be cancelled
      instead
    '';

    showMessage = helpers.defaultNullOpts.mkBool true ''
      whether to display a `Renamed m instances in n files` message after a rename operation
    '';

    inputBufferType = helpers.defaultNullOpts.mkNullable (types.enum [ "dressing" ]) null ''
      the type of the external input buffer to use
    '';

    postHook = helpers.defaultNullOpts.mkLuaFn null ''
      callback to run after renaming, receives the result table (from LSP handler) as an argument
    '';
  };

  config =
    let
      cfg = config.plugins.inc-rename;
      setupOptions = {
        cmd_name = cfg.cmdName;
        hl_group = cfg.hlGroup;
        preview_empty_name = cfg.previewEmptyName;
        show_message = cfg.showMessage;
        input_buffer_type = cfg.inputBufferType;
        post_hook = cfg.postHook;
      };
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      extraConfigLua = ''
        require("inc_rename").setup(${lib.nixvim.toLuaObject setupOptions})
      '';
    };
}
