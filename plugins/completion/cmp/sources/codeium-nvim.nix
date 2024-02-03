{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.codeium-nvim;
in {
  meta.maintainers = [maintainers.GaetanLepage];

  options.plugins.codeium-nvim =
    helpers.neovim-plugin.extraOptionsOptions
    // {
      package = helpers.mkPackageOption "codeium.nvim" pkgs.vimPlugins.codeium-nvim;

      configPath =
        helpers.defaultNullOpts.mkStr
        ''{__raw = "vim.fn.stdpath('cache') .. '/codeium/config.json'";}''
        "The path to the config file, used to store the API key.";

      binPath =
        helpers.defaultNullOpts.mkStr
        ''{__raw = "vim.fn.stdpath('cache') .. '/codeium/bin'";}''
        "The path to the directory where the Codeium server will be downloaded to.";

      api = {
        host = helpers.defaultNullOpts.mkStr "server.codeium.com" ''
          The hostname of the API server to use.
        '';

        port = helpers.defaultNullOpts.mkPositiveInt 443 ''
          The port of the API server to use.
        '';
      };

      tools = {
        uname = helpers.mkNullOrOption types.str "The path to the `uname` binary.";

        uuidgen = helpers.mkNullOrOption types.str "The path to the `uuidgen` binary.";

        curl = helpers.mkNullOrOption types.str "The path to the `curl` binary.";

        gzip = helpers.mkNullOrOption types.str "The path to the `gzip` binary.";

        languageServer = helpers.mkNullOrOption types.str ''
          The path to the language server downloaded from the official source.
        '';
      };

      wrapper = helpers.mkNullOrOption types.str ''
        The path to a wrapper script/binary that is used to execute any binaries not listed under
        tools.
        This is primarily useful for NixOS, where a FHS wrapper can be used for the downloaded
        codeium server.
      '';
    };

  config = mkIf cfg.enable {
    extraConfigLua = let
      setupOptions = with cfg;
        {
          config_path = configPath;
          bin_path = binPath;
          api = with api; {
            inherit host;
            port =
              if isInt port
              then toString port
              else port;
          };
          tools = with tools; {
            inherit
              uname
              uuidgen
              curl
              gzip
              ;
            language_server = languageServer;
          };
          inherit wrapper;
        }
        // cfg.extraOptions;
    in ''
      require('codeium').setup(${helpers.toLuaObject setupOptions})
    '';
  };
}
