{
  lib,
  config,
  options,
  ...
}:
{
  assertions = [
    {
      assertion = config._module.check;
      message = "Expected ${options._module.check} to be true. Definitions:${lib.options.showDefs options._module.check.definitionsWithLocations}";
    }
  ];
}
