{
  pkgs,
  config,
  lib,
  ...
}: {
  mkLsp = {
    name,
    description ? "Enable ${name}.",
    serverName ? name,
    package ? pkgs.${name},
    extraPackages ? {},
    cmd ? (cfg: null),
    settings ? (cfg: {}),
    settingsOptions ? {},
    ...
  }:
  # returns a module
  {
    pkgs,
    config,
    lib,
    ...
  }:
    with lib; let
      cfg = config.plugins.lsp.servers.${name};

      packageOption =
        if package != null
        then {
          package = mkOption {
            default = package;
            type = types.nullOr types.package;
          };
        }
        else {};
    in {
      options = {
        plugins.lsp.servers.${name} =
          {
            enable = mkEnableOption description;
            cmd = mkOption {
              type = with types; nullOr (listOf str);
              default = cmd cfg;
            };
            settings = settingsOptions;
            extraSettings = mkOption {
              default = {};
              type = types.attrs;
              description = ''
                Extra settings for the ${name} language server.
              '';
            };
          }
          // packageOption;
      };

      config =
        mkIf cfg.enable
        {
          extraPackages =
            (optional (package != null) cfg.package)
            ++ (mapAttrsToList (name: _: cfg."${name}Package") extraPackages);

          plugins.lsp.enabledServers = [
            {
              name = serverName;
              extraOptions = {
                cmd = cfg.cmd;
                settings = settings (cfg.settings // cfg.extraSettings);
              };
            }
          ];
        };
    };
}
