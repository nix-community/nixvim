{
  lib,
  helpers,
  config,
  pkgs,
  ...
}: let
  cfg = config.plugins.formatter-nix;
in
  with lib; {
    # TODO examples & descriptions
    options.plugins.formatter-nix = {
      enable = mkEnableOption "formatter-nix";
      package = helpers.mkPackageOption "formatter-nix" pkgs.vimPlugins.formatter-nvim;
      filetype =
        helpers.defaultNullOpts.mkNullable
        (
          with types;
            attrsOf
            (listOf
              (either
                (enum [
                  "javascript.prettier"
                  "javascript.eslint_d"
                  "rust.rustfmt"
                  "sh.shfmt"
                  "haskell.stylish_haskell"
                  "latex.latexindent"
                  "cpp.astyle"
                  "cmake.cmakeformat"
                  "any.remove_trailing_whitespace"
                ])
                helpers.rawType))
        )
        "none"
        "Map a list of formatters to a filetype";
    };

    config = let
      setupOptions.filetype =
        mapAttrs (
          filetype: formatters:
            map (
              formatter:
                if (builtins.typeOf formatter) == "set"
                then formatter
                else {__raw = "require(\"formatter.filetypes.${elemAt (strings.splitString "." formatter) 0}\").${elemAt (strings.splitString "." formatter) 1}";}
            )
            formatters
        )
        cfg.filetype;
      packages = lists.unique (
        concatMap (
          formatters:
            lists.remove "" (map (
                formatter:
                  if (builtins.typeOf formatter) == "set"
                  then ""
                  else
                    with pkgs;
                      {
                        "javascript.prettier" = nodePackages.prettier;
                        "javascript.eslint_d" = nodePackages.eslint_d;
                        "rust.rustfmt" = rustfmt;
                        "sh.shfmt" = shfmt;
                        "haskell.stylish_haskell" = stylish-haskell;
                        "latex.latexindent" = texlive.combine {inherit (pkgs.texlive) scheme-minimal latexindent;};
                        "cpp.astyle" = astyle;
                        "cmake.cmakeformat" = cmake-format;
                        "any.remove_trailing_whitespace" = "";
                      }
                      ."${formatter}"
              )
              formatters)
        )
        (attrValues cfg.filetype)
      );
    in
      mkIf cfg.enable {
        extraPlugins = [cfg.package];
        extraConfigLua = ''
          require("formatter").setup${helpers.toLuaObject setupOptions}
        '';
        extraPackages = packages;
      };
  }
