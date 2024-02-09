{
  mkServer = {
    name,
    sourceType,
    description ? "${name} source, for none-ls.",
    package ? null,
    extraPackages ? [],
    ...
  }:
  # returns a module
  {
    pkgs,
    config,
    lib,
    helpers,
    ...
  }:
    with lib; let
      cfg = config.plugins.none-ls.sources.${sourceType}.${name};
      # does this evaluate package?
      packageOption =
        if package == null
        then {}
        else {
          package = mkOption {
            type = types.package;
            default = package;
            description = "Package to use for ${name} by none-ls";
          };
        };
    in {
      options.plugins.none-ls.sources.${sourceType}.${name} =
        {
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
        }
        // packageOption;

      config = mkIf cfg.enable {
        # Does this evaluate package?
        extraPackages = extraPackages ++ optional (package != null) cfg.package;

        # Add source to list of sources
        plugins.none-ls.sourcesItems = let
          sourceItem = "${sourceType}.${name}";
          withArgs =
            if (cfg.withArgs == null)
            then sourceItem
            else "${sourceItem}.with ${cfg.withArgs}";
          finalString = ''require("null-ls").builtins.${withArgs}'';
        in [(helpers.mkRaw finalString)];
      };
    };
}
