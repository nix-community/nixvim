{
  lib,
  config,
  options,
  ...
}:
let
  cfg = config.nixpkgs;
  opts = options.nixpkgs;
  argOpts = lib.modules.mergeAttrDefinitionsWithPrio options._module.args;

  normalPrio = lib.modules.defaultOverridePriority;
  defaultPrio = (lib.mkDefault null).priority;
  optionDefaultPrio = (lib.mkOptionDefault null).priority;
  # FIXME: buildPlatform can't use mkOptionDefault because it already defaults to hostPlatform
  buildPlatformPrio = optionDefaultPrio - 1;

  mkGlobalPackagesAssertion =
    {
      assertion,
      option ? null,
      loc ? option.loc,
      issue ? "is overridden",
    }:
    {
      assertion = cfg.useGlobalPackages -> assertion;
      message =
        "`${lib.showOption opts.useGlobalPackages.loc}' is enabled, "
        + "but `${lib.showOption loc}' ${issue}. "
        + lib.optionalString (
          option != null
        ) "Definition values:${lib.options.showDefs option.definitionsWithLocations}";
    };
in
{
  options = {
    nixpkgs.useGlobalPackages = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether Nixvim should use the ${config.meta.wrapper.name} configuration's `pkgs`,
        instead of constructing its own instance.

        > [!CAUTION]
        > Changing this option can lead to issues that may be difficult to debug.
      '';
    };
  };

  config = {
    assertions = map mkGlobalPackagesAssertion [
      {
        assertion = opts.pkgs.highestPrio == defaultPrio;
        option = opts.pkgs;
        issue = "is overridden";
      }
      {
        assertion = argOpts.pkgs.highestPrio == normalPrio;
        # FIXME: can't showDefs for an attrOf an option
        loc = options._module.args.loc ++ [ "pkgs" ];
        issue = "is overridden";
      }
      {
        assertion = opts.hostPlatform.highestPrio == optionDefaultPrio;
        option = opts.hostPlatform;
        issue = "is overridden";
      }
      {
        assertion = opts.buildPlatform.highestPrio == buildPlatformPrio;
        option = opts.buildPlatform;
        issue = "is overridden";
      }
      {
        assertion = cfg.config == { };
        option = opts.config;
        issue = "is not empty";
      }
      {
        assertion = cfg.overlays == [ ];
        option = opts.overlays;
        issue = "is not empty";
      }
    ];
  };
}
