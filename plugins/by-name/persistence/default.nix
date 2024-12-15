{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
{
  options.plugins.persistence = lib.nixvim.neovim-plugin.extraOptionsOptions // {
    enable = mkEnableOption "persistence.nvim";

    package = lib.mkPackageOption pkgs "persistence.nvim" {
      default = [
        "vimPlugins"
        "persistence-nvim"
      ];
    };

    dir = helpers.defaultNullOpts.mkStr {
      __raw = ''vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/")'';
    } "directory where session files are saved";

    options =
      let
        # https://neovim.io/doc/user/options.html#'sessionoptions'
        sessionOpts = [
          "blank"
          "buffers"
          "curdir"
          "folds"
          "globals"
          "help"
          "localoptions"
          "options"
          "skiprtp"
          "resize"
          "sesdir"
          "tabpages"
          "terminal"
          "winpos"
          "winsize"
        ];
      in
      helpers.defaultNullOpts.mkListOf (types.enum sessionOpts) [
        "buffers"
        "curdir"
        "tabpages"
        "winsize"
        "skiprtp"
      ] "sessionoptions used for saving";

    preSave = helpers.defaultNullOpts.mkLuaFn "nil" "a function to call before saving the session";

    saveEmpty = helpers.defaultNullOpts.mkBool false ''
      don't save if there are no open file buffers
    '';
  };

  config =
    let
      cfg = config.plugins.persistence;
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      extraConfigLua =
        let
          opts = {
            inherit (cfg) dir options;
            pre_save = cfg.preSave;
            save_empty = cfg.saveEmpty;
          };
        in
        ''
          require('persistence').setup(${lib.nixvim.toLuaObject opts})
        '';
    };
}
