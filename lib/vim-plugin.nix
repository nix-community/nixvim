{
  lib,
  mkPackageOption,
}:
with lib; {
  mkPlugin = {
    config,
    lib,
    ...
  }: {
    name,
    description ? null,
    package ? null,
    extraPlugins ? [],
    extraPackages ? [],
    options ? {},
    globalPrefix ? "",
    ...
  }: let
    cfg = config.plugins.${name};

    # TODO support nested options!
    pluginOptions =
      mapAttrs
      (
        optName: opt:
          opt.option
      )
      options;
    globals =
      mapAttrs'
      (optName: opt: {
        name = let
          optGlobal =
            if opt.global == null
            then optName
            else opt.global;
        in
          globalPrefix + optGlobal;
        value = cfg.${optName};
      })
      options;
    # does this evaluate package?
    packageOption =
      if package == null
      then {}
      else {
        package = mkPackageOption name package;
      };

    extraConfigOption =
      if (isString globalPrefix) && (globalPrefix != "")
      then {
        extraConfig = mkOption {
          type = with types; attrsOf anything;
          description = ''
            The configuration options for ${name} without the '${globalPrefix}' prefix.
            Example: To set '${globalPrefix}_foo_bar' to 1, write
            ```nix
              extraConfig = {
                foo_bar = true;
              };
            ```
          '';
          default = {};
        };
      }
      else {};
  in {
    options.plugins.${name} =
      {
        enable = mkEnableOption (
          if description == null
          then name
          else description
        );
      }
      // extraConfigOption
      // packageOption
      // pluginOptions;

    config = mkIf cfg.enable {
      inherit extraPackages globals;
      # does this evaluate package? it would not be desired to evaluate pacakge if we use another package.
      extraPlugins = extraPlugins ++ optional (package != null) cfg.package;
    };
  };

  mkDefaultOpt = {
    type,
    global ? null,
    description ? null,
    example ? null,
    default ? null,
    ...
  }: {
    option = mkOption {
      type = types.nullOr type;
      inherit default description example;
    };

    inherit global;
  };
}
