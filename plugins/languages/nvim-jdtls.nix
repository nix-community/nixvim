{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.nvim-jdtls;
in
{
  options.plugins.nvim-jdtls = helpers.neovim-plugin.extraOptionsOptions // {
    enable = mkEnableOption "nvim-jdtls";

    package = helpers.mkPackageOption "nvim-jdtls" pkgs.vimPlugins.nvim-jdtls;

    cmd = helpers.mkNullOrOption (types.listOf types.str) ''
      The command that starts the language server.

      You should either set a value for this option, or, you can instead set the `data` (and
      `configuration`) options.

      ```nix
      plugins.nvim-jdtls = {
        enable = true;
        cmd = [
          (lib.getExe pkgs.jdt-language-server)
          "-data" "/path/to/your/workspace"
          "-configuration" "/path/to/your/configuration"
          "-foo" "bar"
        ];
      };
      ```

      Or,
      ```nix
      plugins.nvim-jdtls = {
        enable = true;
        data =  "/path/to/your/workspace";
        configuration = "/path/to/your/configuration";
      };
      ```
    '';

    data = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "/home/YOUR_USERNAME/.cache/jdtls/workspace";
      description = ''
        eclipse.jdt.ls stores project specific data within the folder set via the -data flag.
        If you're using eclipse.jdt.ls with multiple different projects you must use a dedicated
        data directory per project.
      '';
    };

    configuration = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "/home/YOUR_USERNAME/.cache/jdtls/config";
      description = "Path to the configuration file.";
    };

    rootDir =
      helpers.defaultNullOpts.mkNullable (types.either types.str helpers.nixvimTypes.rawLua)
        ''{ __raw = "require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'})"; }''
        ''
          This is the default if not provided, you can remove it. Or adjust as needed.
          One dedicated LSP server & client will be started per unique root_dir
        '';

    settings = helpers.mkNullOrOption types.attrs ''
      Here you can configure eclipse.jdt.ls specific settings
      See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
      for a list of options.
    '';

    initOptions = helpers.mkNullOrOption types.attrs ''
      Language server `initializationOptions`
      You need to extend the `bundles` with paths to jar files if you want to use additional
      eclipse.jdt.ls plugins.

      See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation

      If you don't plan on using the debugger or other eclipse.jdt.ls plugins, ignore this option
    '';
  };

  config =
    let
      cmd =
        if (cfg.cmd == null) then
          let
            data =
              if (cfg.data == null) then
                throw ''
                  You have to either set the 'plugins.nvim-jdtls.data' or the 'plugins.nvim-jdtls.cmd'
                  option.
                ''
              else
                cfg.data;
          in
          [ (lib.getExe pkgs.jdt-language-server) ]
          ++ [
            "-data"
            data
          ]
          ++ (optionals (cfg.configuration != null) [
            "-configuration"
            cfg.configuration
          ])
        else
          cfg.cmd;

      options = {
        inherit cmd;
        root_dir = cfg.rootDir;
        inherit (cfg) settings;
        init_options = cfg.initOptions;
      } // cfg.extraOptions;
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      extraPackages = [ pkgs.jdt-language-server ];

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
