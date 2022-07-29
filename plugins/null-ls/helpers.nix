{ pkgs, config, lib, ... }:

{
  mkServer = {
    name,
    sourceType,
    description ? "Enable ${name} source, for null-ls.",
    packages ? [],
    ... }: 
      # returns a module
      { pkgs, config, lib, ... }@args:
        with lib;
        let
          helpers = import ../helpers.nix args;
          cfg = config.programs.nixvim.plugins.null-ls.sources.${sourceType}.${name};
        in
        {
          options.programs.nixvim.plugins.null-ls.sources.${sourceType}.${name} = {
            enable = mkEnableOption description;

            # TODO: withArgs can exist outside of the module in a generalized manner
            withArgs = mkOption {
              default = null;
              type = with types; nullOr str;
              description = ''Raw Lua code to be called with the with function'';
              # Not sure that it makes sense to have the same example for all servers
              # example = ''
              #   '\'{ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }'\'
              # '';
            };
          };

          config = mkIf cfg.enable {
            programs.nixvim = {
              extraPackages = packages;

              # Add source to list of sources
              plugins.null-ls.sourcesItems = let
                sourceItem = "${sourceType}.${name}";
                withArgs = if (isNull cfg.withArgs) then sourceItem else "${sourceItem}.with ${cfg.withArgs}";
                finalString = ''require("null-ls").builtins.${withArgs}'';
              in [ (helpers.mkRaw finalString) ];
            };
          };
        };
}
