{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) types;

  cfg = config.dependencies;

  mkDependencyOption = name: properties: {
    enable = lib.mkEnableOption "Add ${name} to dependencies.";

    package =
      lib.mkPackageOption pkgs name properties
      # Handle example manually so that we can embed the original attr-path within
      # the literalExpression object. This simplifies testing the examples.
      // lib.optionalAttrs (properties.example != null) {
        example =
          if properties.example._type or null == "literalExpression" then
            properties.example
          else
            rec {
              _type = "literalExpression";
              text = "pkgs.${lib.showAttrPath path}";
              path = lib.toList properties.example;
            };
      };
  };
in
{
  options = {
    __depPackages = lib.mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            default = lib.mkOption {
              type = with types; either str (listOf str);
              description = ''
                Default name (or path) for this package.
              '';
              example = "git";
            };

            example = lib.mkOption {
              type = with types; nullOr str;
              description = ''
                Example of another package to use instead of the default.
              '';
              example = "gitMinimal";
              default = null;
            };
          };
        }
      );
      description = ''
        A set of dependency packages, used internally to construct the `dependencies.<name>` options.
      '';
      default = { };
      example = {
        curl.default = "curl";
        git = {
          default = "git";
          example = "gitMinimal";
        };
      };
      internal = true;
      visible = false;
    };

    dependencies = lib.mapAttrs mkDependencyOption config.__depPackages;
  };

  config = {
    extraPackages = lib.pipe cfg [
      builtins.attrValues
      (builtins.filter (p: p.enable))
      (builtins.map (p: p.package))
    ];

    __depPackages = {
      bat.default = "bat";
      codeium.default = "codeium";
      coreutils = {
        default = "coreutils";
        example = "uutils-coreutils";
      };
      cornelis.default = "cornelis";
      ctags.default = "ctags";
      curl.default = "curl";
      direnv.default = "direnv";
      distant.default = "distant";
      fish.default = "fish";
      flutter.default = "flutter";
      fzf = {
        default = "fzf";
        example = "skim";
      };
      gcc.default = "gcc";
      gh.default = "gh";
      git = {
        default = "git";
        example = "gitMinimal";
      };
      glow.default = "glow";
      go.default = "go";
      godot.default = "godot_4";
      gzip.default = "gzip";
      lazygit.default = "lazygit";
      lean.default = "lean4";
      ledger.default = "ledger";
      llm-ls.default = "llm-ls";
      manix.default = "manix";
      nodejs = {
        default = "nodejs";
        example = "nodejs_22";
      };
      plantuml.default = "plantuml";
      ripgrep.default = "ripgrep";
      rust-analyzer.default = "rust-analyzer";
      sd.default = "sd";
      sed.default = "gnused";
      texpresso.default = "texpresso";
      tinymist.default = "tinymist";
      tmux.default = "tmux";
      tree-sitter.default = "tree-sitter";
      typst.default = "typst";
      ueberzug.default = "ueberzugpp";
      util-linux.default = "util-linux";
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
  };
}
