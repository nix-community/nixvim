{
  lib,
  config,
  helpers,
  pkgs,
  ...
}:
with lib;
with helpers.vim-plugin;
helpers.vim-plugin.mkVimPlugin config {
  name = "copilot-vim";
  originalName = "copilot.vim";
  defaultPackage = pkgs.vimPlugins.copilot-vim;
  globalPrefix = "copilot_";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO introduced 2024-03-02: remove 2024-05-02
  deprecateExtraConfig = true;
  optionsRenamedToSettings = [
    "nodeCommand"
    "filetypes"
    "proxy"
  ];

  settingsOptions = {
    node_command = mkOption {
      type = with types; nullOr str;
      default = "${pkgs.nodejs-18_x}/bin/node";
      description = "Tell Copilot what `node` binary to use.";
    };

    filetypes = mkOption {
      type = with types; nullOr (attrsOf bool);
      default = null;
      description = "A dictionary mapping file types to their enabled status.";
      example = {
        "*" = false;
        python = true;
      };
    };

    proxy = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
        Tell Copilot what proxy server to use.

        If this is not set, Copilot will use the value of environment variables like
        `$HTTPS_PROXY`.
      '';
      example = "localhost:3128";
    };

    proxy_strict_ssl = helpers.mkNullOrOption types.bool ''
      Corporate proxies sometimes use a man-in-the-middle SSL certificate which is incompatible
      with GitHub Copilot.
      To work around this, SSL certificate verification can be disabled by setting this option to
      `false`.

      You can also tell `Node.js` to disable SSL verification by setting the
      `$NODE_TLS_REJECT_UNAUTHORIZED` environment variable to `"0"`.
    '';

    workspace_folders = helpers.mkNullOrOption (with types; listOf str) ''
      A list of "workspace folders" or project roots that Copilot may use to improve to improve
      the quality of suggestions.

      Example: ["~/Projects/myproject"]

      You can also set `b:workspace_folder` for an individual buffer and newly seen values will be
      added automatically.
    '';
  };

  settingsExample = {
    filetypes = {
      "*" = false;
      python = true;
    };
    proxy = "localhost:3128";
    proxy_strict_ssl = false;
    workspace_folders = [ "~/Projects/myproject" ];
  };
}
