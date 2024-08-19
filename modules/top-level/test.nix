{ lib, ... }:
{
  options.test = {
    runNvim = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to run `nvim` in the test.";
      default = true;
    };
  };
}
