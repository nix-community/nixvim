{ pkgs, config, lib, ... }:

{
  mkLsp =
    { name
    , description ? "Enable ${name}."
    , serverName ? name
    , packages ? [ pkgs.${name} ]
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
          };
        };

        config = mkIf cfg.enable {
          extraPackages = packages;

          plugins.lsp.enabledServers = [ serverName ];
        };
      };
}
