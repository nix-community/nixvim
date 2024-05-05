{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; {
  options.plugins.zk = {
    enable = mkEnableOption "zk.nvim, a plugin to integrate with zk";

    package = helpers.mkPackageOption "zk.nvim" pkgs.vimPlugins.zk-nvim;

    picker =
      helpers.defaultNullOpts.mkEnumFirstDefault
      [
        "select"
        "fzf"
        "telescope"
      ]
      ''
        it's recommended to use "telescope" or "fzf"
      '';

    lsp = {
      config =
        helpers.neovim-plugin.extraOptionsOptions
        // {
          cmd = helpers.defaultNullOpts.mkNullable (types.listOf types.str) ''["zk" "lsp"]'' "";
          name = helpers.defaultNullOpts.mkStr "zk" "";
        };

      autoAttach = {
        enabled = helpers.defaultNullOpts.mkBool true "automatically attach buffers in a zk notebook";
        filetypes =
          helpers.defaultNullOpts.mkNullable (types.listOf types.str) ''["markdown"]''
          "matching the given filetypes";
      };
    };
  };
  config = let
    cfg = config.plugins.zk;
    setupOptions = {
      inherit (cfg) picker;
      lsp = {
        inherit (cfg.lsp) config;
        auto_attach = {
          inherit (cfg.lsp.autoAttach) enabled filetypes;
        };
      };
    };
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];
      extraPackages = [pkgs.zk];

      extraConfigLua = ''
        require("zk").setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
