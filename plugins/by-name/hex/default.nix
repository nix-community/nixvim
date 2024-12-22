{ lib, pkgs, ... }:
let
  inherit (lib.nixvim) defaultNullOpts mkNullOrLuaFn;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "hex";
  packPathName = "hex.nvim";
  package = "hex-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraOptions = {
    xxdPackage = lib.mkPackageOption pkgs [
      "unixtools"
      "xxd"
    ] { nullable = true; };
  };

  extraConfig = cfg: { extraPackages = [ cfg.xxdPackage ]; };

  settingsOptions = {
    dump_cmd = defaultNullOpts.mkStr "xxd -g 1 -u" ''
      cli command used to dump hex data.
    '';

    assemble_cmd = defaultNullOpts.mkStr "xxd -r" ''
      cli command used to dump hex data.
    '';

    is_buf_binary_pre_read = mkNullOrLuaFn ''
      Function that runs on `BufReadPre` to determine if it's binary or not.
      It should return a boolean value.
    '';

    is_buf_binary_post_read = mkNullOrLuaFn ''
      Function that runs on `BufReadPost` to determine if it's binary or not.
      It should return a boolean value.
    '';
  };

  settingsExample = {
    dump_cmd = "xxd -g 1 -u";
    assemble_cmd = "xxd -r";
  };
}
