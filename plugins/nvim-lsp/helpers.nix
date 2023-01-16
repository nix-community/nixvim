{ pkgs, config, lib, ... }:

{
  mkLsp =
    { name
    , description ? "Enable ${name}."
    , serverName ? name
    , package ? pkgs.${name}
    , extraPackages ? { }
    , cmd ? null
    , settings ? null
    , extraOptions ? { }
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

        extraPackagesOptions = mapAttrs'
          (name: defaultPackage: {
            name = "${name}Package";
            value = mkOption {
              default = defaultPackage;
              type = types.package;
            };
          })
          extraPackages;
      in
      {
        options = {
          plugins.lsp.servers.${name} = {
            enable = mkEnableOption description;
          } // packageOption // extraPackagesOptions;
        };

        config = mkIf cfg.enable {
          extraPackages = (optional (package != null) cfg.package) ++
            (mapAttrsToList (name: _: cfg."${name}Package") extraPackages);

          plugins.lsp.enabledServers = [{
            name = serverName;
            extraOptions = {
              inherit cmd;
              settings = if settings != null then settings cfg else { };
            };
          }];
        };
      };
}
