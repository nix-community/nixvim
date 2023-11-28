{
  lib,
  helpers,
  config,
  pkgs,
  ...
}: let
  cfg = config.plugins.formatter-nvim;
in
  with lib; {
    # TODO examples & descriptions
    options.plugins.formatter-nvim = {
      enable = mkEnableOption "formatter-nvim";
      package = helpers.mkPackageOption "formatter-nvim" pkgs.vimPlugins.formatter-nvim;
      logging = helpers.defaultNullOpts.mkBool true "If logging should be enabled";
      logLevel = helpers.defaultNullOpts.mkEnum ["DEBUG" "ERROR" "INFO" "TRACE" "WARN" "OFF"] "WARN" "The level to log at";
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
      setupOptions = {
        filetype =
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
        inherit (cfg) logging;
        log_level.__raw =
          if (cfg.log_level == null)
          then null
          else "vim.log.levels.${cfg.log_level}";
      };
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
