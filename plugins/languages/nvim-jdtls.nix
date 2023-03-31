{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.nvim-jdtls;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options.plugins.nvim-jdtls =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "nvim-jdtls";

      package = helpers.mkPackageOption "nvim-jdtls" pkgs.vimPlugins.nvim-jdtls;

      cmd = mkOption {
        type = types.listOf types.str;
        description = "The command that starts the language server";
        default = ["${pkgs.jdt-language-server}/bin/jdt-language-server" "-data" "~/.cache/jdtls/workspace/"];
      };

      rootDir =
        helpers.defaultNullOpts.mkNullable
        (types.either types.str helpers.rawType)
        ''{ __raw = "require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'})"; }''
        ''
          This is the default if not provided, you can remove it. Or adjust as needed.
          One dedicated LSP server & client will be started per unique root_dir
        '';

      settings =
        helpers.mkNullOrOption (types.attrs)
        ''
          Here you can configure eclipse.jdt.ls specific settings
          See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
          for a list of options.
        '';

      initOptions =
        helpers.mkNullOrOption (types.attrs)
        ''
          Language server `initializationOptions`
          You need to extend the `bundles` with paths to jar files if you want to use additional
          eclipse.jdt.ls plugins.

          See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation

          If you don't plan on using the debugger or other eclipse.jdt.ls plugins, ignore this option
        '';
    };

  config = let
    options =
      {
        inherit (cfg) cmd;
        root_dir = cfg.rootDir;
        inherit (cfg) settings;
        init_options = cfg.initOptions;
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraPackages = [pkgs.jdt-language-server];

      autoCmd = [
        {
          event = "FileType";
          pattern = "java";
          callback.__raw = ''
            function ()
              require('jdtls').start_or_attach(${helpers.toLuaObject options})
            end
          '';
        }
      ];
    };
}
