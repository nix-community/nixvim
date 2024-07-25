{ lib, ... }:
{
  options.iconsEnabled = lib.mkOption {
    type = lib.types.bool;
    description = "Toggle icon support. Installs nvim-web-devicons.";
    default = true;
  };
}
