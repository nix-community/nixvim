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
    direnv.default = "direnv";
    distant.default = "distant";
    fish.default = "fish";
    gcc.default = "gcc";
    gh.default = "gh";
    git = {
      default = "git";
      example = [ "gitMinimal" ];
    };
    go.default = "go";
    lean.default = "lean4";
    ledger.default = "ledger";
    manix.default = "manix";
    nodejs = {
      default = "nodejs";
      example = "pkgs.nodejs_22";
    };
    ripgrep.default = "ripgrep";
    texpresso.default = "texpresso";
    tinymist.default = "tinymist";
    tree-sitter.default = "tree-sitter";
    typst.default = "typst";
    ueberzug.default = "ueberzugpp";
    websocat.default = "websocat";
    which.default = "which";
    yazi.default = "yazi";
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
