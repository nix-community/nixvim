{ lib, ... }:
{
  options.enableMan = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Install the man pages for Nixvim options.";
  };
}
