{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.dependencies;

  packages = {
    ctags.default = "ctags";
    curl.default = "curl";
    gcc.default = "gcc";
    git = {
      default = "git";
      example = [ "gitMinimal" ];
    };
    nodejs = {
      default = "nodejs";
      example = "pkgs.nodejs_22";
    };
    texpresso.default = "texpresso";
    tree-sitter.default = "tree-sitter";
    typst.default = "typst";
    ueberzug.default = "ueberzugpp";
    which.default = "which";
  };

  mkDependencyOption = name: properties: {
    enable = lib.mkEnableOption "Add ${name} to dependencies.";

    package = lib.mkPackageOption pkgs name properties;
  };
in
{
  options.dependencies = lib.mapAttrs mkDependencyOption packages;

  config = {
    extraPackages = lib.pipe cfg [
      builtins.attrValues
      (builtins.filter (p: p.enable))
      (builtins.map (p: p.package))
    ];
  };
}
