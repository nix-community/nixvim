{
  lib,
  helpers,
  config,
  pkgs,
  ...
}: let
  cfg = config.plugins.lastplace;
in
  with lib; {
    options.plugins.lastplace =
      helpers.neovim-plugin.extraOptionsOptions
      // {
        enable = mkEnableOption "lastplace";

        package = helpers.mkPackageOption "lastplace" pkgs.vimPlugins.nvim-lastplace;

        ignoreBuftype =
          helpers.defaultNullOpts.mkNullable (types.listOf types.str)
          ''["quickfix" "nofix" "help"]''
          "The list of buffer types to ignore by lastplace.";

        ignoreFiletype =
          helpers.defaultNullOpts.mkNullable (types.listOf types.str)
          ''["gitcommit" "gitrebase" "svn" "hgcommit"]''
          "The list of file types to ignore by lastplace.";

        openFolds =
          helpers.defaultNullOpts.mkBool true
          "Whether closed folds are automatically opened when jumping to the last edit position.";
      };

    config = let
      options =
        {
          lastplace_ignore_buftype = cfg.ignoreBuftype;
          lastplace_ignore_filetype = cfg.ignoreFiletype;
          lastplace_open_folds = cfg.openFolds;
        }
        // cfg.extraOptions;
    in
      mkIf cfg.enable {
        extraPlugins = [cfg.package];

        extraConfigLua = ''
          require('nvim-lastplace').setup(${helpers.toLuaObject options})
        '';
      };
  }
