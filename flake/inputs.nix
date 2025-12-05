{ lib, inputs, ... }:
{
  options.inputs = lib.mkOption {
    type = lib.types.raw;
    description = "Flake inputs.";
    readOnly = true;
  };
  config.inputs = inputs;
}
