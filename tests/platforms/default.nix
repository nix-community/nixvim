{
  callTest,
  lib,
  stdenv,
}:
let
  inherit (stdenv.hostPlatform)
    isLinux
    isDarwin
    ;
in
{
  home-manager-module = (callTest ./hm.nix { }).activationPackage;
  home-manager-extra-files-byte-compiling = callTest ./hm-extra-files-byte-compiling.nix { };
  home-manager-submodule-merge = callTest ./hm-submodule-merge.nix { };
}
// lib.optionalAttrs isLinux {
  nixos-module = (callTest ./nixos.nix { }).config.system.build.toplevel;
}
// lib.optionalAttrs isDarwin {
  darwin-module = (callTest ./darwin.nix { }).system;
}
