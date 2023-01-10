{ pkgs, config, lib, ... }:

{
  mkLsp =
    { name
    , description ? "Enable ${name}."
    , serverName ? name
    , packages ? [ pkgs.${name} ]
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
      in
      {
        options = {
          plugins.lsp.servers.${name} = {
            enable = mkEnableOption description;
          } // extraOptions;
        };

        config = mkIf cfg.enable {
          extraPackages = packages;

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
