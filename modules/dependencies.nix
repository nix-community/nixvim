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
      // lib.optionalAttrs (builtins.isList properties.example) {
        example = {
          _type = "literalExpression";
          text = "pkgs.${lib.showAttrPath properties.example}";
          path = properties.example;
        };
      }
      // lib.optionalAttrs (literalExpressionType.check properties.example) {
        inherit (properties) example;
      };
  };

  # Motivation:
  # If one were to define `__depPackages.foo.default = "gzip";` in two places (by accident),
  # the module system would merge the two definitions as `["gzip" "gzip"]`.
  #
  # Solution:
  # -> Make attrPathType unique so the option can only be set once.
  attrPathType =
    with types;
    unique { message = "attrPathType must be unique"; } (coercedTo str lib.toList (listOf str));

  literalExpressionType = lib.types.mkOptionType {
    name = "literal-expression";
    description = "literal expression";
    descriptionClass = "noun";
    merge = lib.options.mergeEqualOption;
    check = v: v ? _type && (v._type == "literalExpression" || v._type == "literalMD");
  };
in
{
  options = {
    __depPackages = lib.mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            default = lib.mkOption {
              type = attrPathType;
              description = ''
                Attribute path for this dependency's default package, relative to `pkgs`.
              '';
              example = "git";
            };

            example = lib.mkOption {
              type = types.nullOr (types.either attrPathType literalExpressionType);
              description = ''
                Attribute path for an alternative package that provides dependency, relative to `pkgs`.
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
      claude-code.default = "claude-code";
      codeium.default = "codeium";
      copilot.default = "github-copilot-cli";
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
      gemini.default = "gemini-cli";
      gh.default = "gh";
      git = {
        default = "git";
        example = "gitMinimal";
      };
      glow.default = "glow";
      go.default = "go";
      godot.default = "godot_4";
      gzip.default = "gzip";
      imagemagick.default = "imagemagick";
      lazygit.default = "lazygit";
      lean.default = "lean4";
      ledger.default = "ledger";
      llm-ls.default = "llm-ls";
      manix.default = "manix";
      nodejs = {
        default = "nodejs";
        example = "nodejs_22";
      };
      opencode.default = "opencode";
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
      zf.default = "zf";
      zk.default = "zk";
    };
  };
}
