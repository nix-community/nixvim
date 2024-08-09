{ lib, ... }:
{
  options.tests = {
    dontRun = lib.mkEnableOption "" // {
      description = "Whether to disable running `nvim` in the test.";
    };
  };
}
