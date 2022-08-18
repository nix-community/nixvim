{ pkgs, config, lib, ... }:

with lib;

{
  mkLsp = { name
    , description ? "Enable ${name}."
    , serverName ? name
    , packages ? [ pkgs.${name} ]
    , ... }: 

      # returns a module
      { pkgs, config, lib, ... }:
        let
          cfg = config.programs.nixvim.plugins.lsp.servers.${name};
        in
        {
          options = {
            programs.nixvim.plugins.lsp.servers.${name} = {
              enable = mkEnableOption description;
            };
          };

          config = mkIf cfg.enable {
            programs.nixvim.extraPackages = packages;

            programs.nixvim.plugins.lsp.enabledServers = [ serverName ];
          };
        };
}
