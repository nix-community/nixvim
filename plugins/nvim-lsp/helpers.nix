{ pkgs, config, lib, ... }:

{
  mkLsp =
    { name
    , description ? "Enable ${name}."
    , serverName ? name
    , package ? pkgs.${name}
    , extraPackages ? { }
    , cmd ? (cfg: null)
    , settings ? (cfg: { })
    , settingsOptions ? { }
    , ...
    }:
    # returns a module
    { pkgs, config, lib, ... }:
      with lib;
      let
        cfg = config.plugins.lsp.servers.${name};

        packageOption =
          if package != null then {
            package = mkOption {
              default = package;
              type = types.nullOr types.package;
            };
          } else { };
      in
      {
        options = {
          plugins.lsp.servers.${name} = {
            enable = mkEnableOption description;
            settings = settingsOptions;
          } // packageOption;
        };

        config = mkIf cfg.enable
          {
            extraPackages = (optional (package != null) cfg.package) ++
              (mapAttrsToList (name: _: cfg."${name}Package") extraPackages);

            plugins.lsp.enabledServers = [{
              name = serverName;
              extraOptions = {
                cmd = cmd cfg;
                settings = settings cfg.settings;
              };
            }];
          };
      };
}
