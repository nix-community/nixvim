{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.wilder-nvim;
  helpers = import ../helpers.nix {inherit lib;};

  boolToInt = value:
    if value == null
    then null
    else if value
    then "1"
    else "0";
in {
  options.plugins.wilder-nvim =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "wilder-nvim";

      package = helpers.mkPackageOption "wilder-nvim" pkgs.vimPlugins.wilder-nvim;

      modes = helpers.defaultNullOpts.mkNullable (types.listOf types.str) ''["/" "?"]'' ''
        List of modes which wilderw will be active in.
        Possible elements: '/', '?' and ':'
      '';

      enableCmdlineEnter = helpers.defaultNullOpts.mkBool true ''
        If true calls wilder#enable_cmdline_enter().
        Creates a new |CmdlineEnter| autocmd to which will start wilder
        when the cmdline is entered.
      '';

      wildcharm = helpers.defaultNullOpts.mkStr "&wildchar" ''
        Key to set the 'wildcharm' option to. can be set to v:false to skip the setting.
      '';

      nextKey = helpers.defaultNullOpts.mkStr "<Tab>" ''
        A key to map to wilder#next() providing next suggestion.
      '';

      prevKey = helpers.defaultNullOpts.mkStr "<S-Tab>" ''
        A key to map to wilder#prev() providing previous suggestion.
      '';

      acceptKey = helpers.defaultNullOpts.mkStr "<Down>" ''
        Mapping to bind to wilder#accept_completion().
      '';

      rejectKey = helpers.defaultNullOpts.mkStr "<Up>" ''
        Mapping to bind to wilder#reject_completion().
      '';

      acceptCompletionAutoSelect = helpers.defaultNullOpts.mkBool true ''
        The auto_slect option passed to wilder#accept_completion().
      '';
    };

  config = let
    setupOptions = with cfg; {
      enable_cmdline_enter = boolToInt enableCmdlineEnter;
      inherit modes;
      inherit wildcharm;
      next_key = nextKey;
      previous_key = prevKey;
      accept_key = acceptKey;
      reject_key = rejectKey;
      accept_completion_auto_select = boolToInt acceptCompletionAutoSelect;
    };
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = ''
        require("wilder").setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
