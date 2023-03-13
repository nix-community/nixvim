modules: {
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkOptionType mkForce mkMerge mkIf types;
in {
  topLevelModules =
    [
      ./modules/output.nix
      (import ./modules/files.nix (modules pkgs))
    ]
    ++ (modules pkgs);

  helpers = mkOption {
    type = mkOptionType {
      name = "helpers";
      description = "Helpers that can be used when writing nixvim configs";
      check = builtins.isAttrs;
    };
    description = "Use this option to access the helpers";
    default = import ../plugins/helpers.nix {inherit (pkgs) lib;};
  };

  configFiles = let
    cfg = config.programs.nixvim;
  in
    lib.mapAttrs'
    (
      _: file:
        lib.nameValuePair
        "nvim/${file.path}"
        {text = file.content;}
    )
    cfg.files;
}
