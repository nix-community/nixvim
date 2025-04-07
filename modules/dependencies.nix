{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.dependencies;

  packages = {
    bat.default = "bat";
    cornelis.default = "cornelis";
    ctags.default = "ctags";
    curl.default = "curl";
    direnv.default = "direnv";
    distant.default = "distant";
    fish.default = "fish";
    fzf = {
      default = "fzf";
      example = "pkgs.skim";
    };
    gcc.default = "gcc";
    gh.default = "gh";
    git = {
      default = "git";
      example = [ "gitMinimal" ];
    };
    glow.default = "glow";
    go.default = "go";
    lazygit.default = "lazygit";
    lean.default = "lean4";
    ledger.default = "ledger";
    llm-ls.default = "llm-ls";
    manix.default = "manix";
    nodejs = {
      default = "nodejs";
      example = "pkgs.nodejs_22";
    };
    plantuml.default = "plantuml";
    ripgrep.default = "ripgrep";
    sd.default = "sd";
    sed.default = "gnused";
    texpresso.default = "texpresso";
    tinymist.default = "tinymist";
    tmux.default = "tmux";
    tree-sitter.default = "tree-sitter";
    typst.default = "typst";
    ueberzug.default = "ueberzugpp";
    websocat.default = "websocat";
    wezterm.default = "wezterm";
    which.default = "which";
    xxd.default = [
      "unixtools"
      "xxd"
    ];
    yazi.default = "yazi";
    yq.default = "yq";
    zk.default = "zk";
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
