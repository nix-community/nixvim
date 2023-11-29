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
                  "any.remove_trailing_whitespace"
                  "any.substitute_trailing_whitespace"
                  "awk.prettier"
                  "awk.prettierd"
                  "c.uncrustify"
                  "c.clangformat"
                  "c.astyle"
                  "cmake.cmakeformat"
                  "cpp.uncrustify"
                  "cpp.clangformat"
                  "cpp.astyle"
                  "cs.uncrustify"
                  "cs.clangformat"
                  "cs.astyle"
                  "cs.dotnetformat"
                  "cs.csharpier"
                  "css.prettydiff"
                  "css.prettier"
                  "css.prettierd"
                  "css.eslint_d"
                  "css.stylefmt"
                  "css.cssbeautify"
                  "css.csscomb"
                  "dart.dartformat"
                  "elixir.mixformat"
                  "eruby.erbformatter"
                  "eruby.htmlbeautifier"
                  "fish.fishindent"
                  "go.gofmt"
                  "go.goimports"
                  "go.gofumpt"
                  "go.gofumports"
                  "go.golines"
                  "graphql.prettier"
                  "graphql.prettierd"
                  "haskell.stylish_haskell"
                  "html.prettier"
                  "html.prettierd"
                  "html.prettydiff"
                  "html.htmlbeautifier"
                  "html.tidy"
                  "java.clangformat"
                  "java.google_java_format"
                  "javascript.jsbeautify"
                  "javascript.clangformat"
                  "javascript.prettydiff"
                  "javascript.esformatter"
                  "javascript.prettier"
                  "javascript.prettierd"
                  "javascript.prettiereslint"
                  "javascript.eslint_d"
                  "javascript.standard"
                  "javascript.denofmt"
                  "javascript.semistandard"
                  "javascript.biome"
                  "javascriptreact.jsbeautify"
                  "javascriptreact.prettydiff"
                  "javascriptreact.esformatter"
                  "javascriptreact.prettier"
                  "javascriptreact.prettierd"
                  "javascriptreact.prettiereslint"
                  "javascriptreact.eslint_d"
                  "javascriptreact.standard"
                  "javascriptreact.denofmt"
                  "javascriptreact.semistandard"
                  "javascriptreact.clangformat"
                  "javascriptreact.biome"
                  "json.jsbeautify"
                  "json.prettydiff"
                  "json.prettier"
                  "json.prettierd"
                  "json.denofmt"
                  "json.biome"
                  "json.jq"
                  "json.fixjson"
                  "kotlin.ktlint"
                  "latex.latexindent"
                  "liquidsoap.liquidsoap_prettier"
                  "lua.luaformatter"
                  "lua.luafmt"
                  "lua.luaformat"
                  "lua.stylua"
                  "markdown.prettier"
                  "markdown.prettierd"
                  "markdown.denofmt"
                  "nix.alejandra"
                  "nix.nixfmt"
                  "nix.nixpkgs_fmt"
                  "ocaml.ocamlformat"
                  "perl.perltidy"
                  "php.phpcbf"
                  "php.php_cs_fixer"
                  "php.pint"
                  "proto.buf_format"
                  "python.yapf"
                  "python.autopep8"
                  "python.isort"
                  "python.docformatter"
                  "python.black"
                  "python.ruff"
                  "python.pyment"
                  "python.pydevf"
                  "python.autoflake"
                  "r.styler"
                  "ruby.rubocop"
                  "ruby.standardrb"
                  "rust.rustfmt"
                  "rust.rustfmt"
                  "sh.shfmt"
                  "sh.shfmt"
                  "sql.pgformat"
                  "sql.sqlfluff"
                  "svelte.prettier"
                  "terraform.terraformfmt"
                  "tex.latexindent"
                  "toml.taplo"
                  "typescript.tsfmt"
                  "typescript.prettier"
                  "typescript.prettierd"
                  "typescript.prettiereslint"
                  "typescript.eslint_d"
                  "typescript.clangformat"
                  "typescript.denofmt"
                  "typescript.biome"
                  "typescriptreact.tsfmt"
                  "typescriptreact.prettier"
                  "typescriptreact.prettierd"
                  "typescriptreact.prettiereslint"
                  "typescriptreact.eslint_d"
                  "typescriptreact.clangformat"
                  "typescriptreact.denofmt"
                  "typescriptreact.biome"
                  "vue.prettier"
                  "xhtml.tidy"
                  "xml.tidy"
                  "xml.xmllint"
                  "xml.xmlformat"
                  "yaml.prettier"
                  "yaml.prettierd"
                  "yaml.pyaml"
                  "yaml.yamlfmt"
                  "zig.zigfmt"
                  "zsh.beautysh"
                ])
                helpers.rawType))
        )
        "none"
        ''
          Map a list of formatters to a filetype

          Example:
          {
            lua = [
              "lua.stylua"
              {
                __raw = \'\'
                  function()
                    if util.get_current_buffer_file_name() == "special.lua" then
                      return nil
                    end

                    return {
                      exe = "stylua",
                      args = {
                        "--search-parent-directories",
                        "--stdin-filepath",
                        util.escape_path(util.get_current_buffer_file_path()),
                        "--",
                        "-",
                      },
                      stdin = true,
                    }
                  end
                \'\';
              }
            ];
            "*" = [ "any.remove_trailing_whitespace" ]
          }
        '';
      installFormatters = mkOption {
        type = bool;
        default = true;
        description = ''
          If the formatters should automatically be installed
        '';
      };
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
      packages =
        if cfg.installFormatters
        then
          lists.unique (
            concatMap (
              formatters:
                lists.remove "" (concatMap (
                    formatter:
                      if (builtins.typeOf formatter) == "set"
                      then ""
                      else
                        with pkgs;
                          {
                            "any.remove_trailing_whitespace" = "";
                            "any.substitute_trailing_whitespace" = "";
                            "awk.prettier" = nodePackages.prettier;
                            "awk.prettierd" = prettierd;
                            "c.uncrustify" = uncrustify;
                            "c.clangformat" = clang-tools;
                            "c.astyle" = astyle;
                            "cmake.cmakeformat" = cmake-format;
                            "cpp.uncrustify" = uncrustify;
                            "cpp.clangformat" = clang-tools;
                            "cpp.astyle" = astyle;
                            "cs.uncrustify" = uncrustify;
                            "cs.clangformat" = clang-tools;
                            "cs.astyle" = astyle;
                            "cs.dotnetformat" = dotnet-sdk;
                            "cs.csharpier" = abort "Can't find a csharpier package";
                            "css.prettydiff" = abort "Can't find a prettydiff package";
                            "css.prettier" = nodePackages.prettier;
                            "css.prettierd" = prettierd;
                            "css.eslint_d" = nodePackages.eslint_d;
                            "css.stylefmt" = abort "Can't find a stylefmt package";
                            "css.cssbeautify" = python3Packages.cssbeautifier;
                            "css.csscomb" = abort "Can't find a csscomb package";
                            "dart.dartformat" = dart;
                            "elixir.mixformat" = elixir;
                            "eruby.erbformatter" = rubyPackages.erb-formatter;
                            "eruby.htmlbeautifier" = rubyPackages.htmlbeautifier;
                            "fish.fishindent" = fish;
                            "go.gofmt" = go;
                            "go.goimports" = gotools;
                            "go.gofumpt" = gofumpt;
                            "go.gofumports" = abort "Can't find a gofumports package";
                            "go.golines" = golines;
                            "graphql.prettier" = nodePackages.prettier;
                            "graphql.prettierd" = prettierd;
                            "haskell.stylish_haskell" = stylish-haskell;
                            "html.prettier" = nodePackages.prettier;
                            "html.prettierd" = prettierd;
                            "html.prettydiff" = abort "Can't find a prettydiff package";
                            "html.htmlbeautifier" = rubyPackages.htmlbeautifier;
                            "html.tidy" = html-tidy;
                            "java.clangformat" = clang-tools;
                            "java.google_java_format" = google-java-format;
                            "javascript.jsbeautify" = nodePackages.js-beautify;
                            "javascript.clangformat" = clang-tools;
                            "javascript.prettydiff" = abort "Can't find a prettydiff package";
                            "javascript.esformatter" = abort "Can't find a esformatter package";
                            "javascript.prettier" = nodePackages.prettier;
                            "javascript.prettierd" = prettierd;
                            "javascript.prettiereslint" = abort "Can't find a prettier-eslint package";
                            "javascript.eslint_d" = nodePackages.eslint_d;
                            "javascript.standard" = abort "Can't find a standard package";
                            "javascript.denofmt" = deno;
                            "javascript.semistandard" = abort "Can't find a semistandard package";
                            "javascript.biome" = biome;
                            "javascriptreact.jsbeautify" = nodePackages.js-beautify;
                            "javascriptreact.clangformat" = clang-tools;
                            "javascriptreact.prettydiff" = abort "Can't find a prettydiff package";
                            "javascriptreact.esformatter" = abort "Can't find a esformatter package";
                            "javascriptreact.prettier" = nodePackages.prettier;
                            "javascriptreact.prettierd" = prettierd;
                            "javascriptreact.prettiereslint" = abort "Can't find a prettier-eslint package";
                            "javascriptreact.eslint_d" = nodePackages.eslint_d;
                            "javascriptreact.standard" = abort "Can't find a standard package";
                            "javascriptreact.denofmt" = deno;
                            "javascriptreact.semistandard" = abort "Can't find a semistandard package";
                            "javascriptreact.biome" = biome;
                            "json.jsbeautify" = nodePackages.js-beautify;
                            "json.prettydiff" = abort "Can't find a prettydiff package";
                            "json.prettier" = nodePackages.prettier;
                            "json.prettierd" = prettierd;
                            "json.denofmt" = deno;
                            "json.biome" = biome;
                            "json.jq" = jq;
                            "json.fixjson" = nodePackages.fixjson;
                            "kotlin.ktlint" = ktlint;
                            "rust.rustfmt" = rustfmt;
                            "sh.shfmt" = shfmt;
                            "latex.latexindent" = texlive.combine {inherit (pkgs.texlive) scheme-minimal latexindent;};
                            "liquidsoap.liquidsoap_prettier" = abort "Can't find a liquidsoap-prettier package";
                            "lua.luaformatter" = luaformatter;
                            "lua.luafmt" = abort "Can't find a luafmt package";
                            "lua.luaformat" = abort "Can't find a lua-format package";
                            "lua.stylua" = stylua;
                            "markdown.prettier" = nodePackages.prettier;
                            "markdown.prettierd" = prettierd;
                            "markdown.denofmt" = deno;
                            "nix.alejandra" = alejandra;
                            "nix.nixfmt" = nixfmt;
                            "nix.nixpkgs_fmt" = nixpkgs-fmt;
                            "ocaml.ocamlformat" = ocamlPackages.ocamlformat;
                            "perl.perltidy" = perlPackages.PerlTidy;
                            "php.phpcbf" = phpPackages.phpcbf;
                            "php.php_cs_fixer" = phpPackages.php-cs-fixer;
                            "php.pint" = abort "Can't find a pint package";
                            "proto.buf_format" = buf;
                            "python.yapf" = yapf;
                            "python.autopep8" = python3Packages.autopep8;
                            "python.isort" = isort;
                            "python.docformatter" = python3Packages.docformatter;
                            "python.black" = black;
                            "python.ruff" = ruff;
                            "python.pyment" = python3Packages.pyment;
                            "python.pydevf" = abort "Can't find a pydevf package";
                            "python.autoflake" = autoflake;
                            "r.styler" = [R rPackages.styler];
                            "ruby.rubocop" = rubocop;
                            "ruby.standardrb" = abort "Can't find a standardrb package";
                            "rust.rustfmt" = rustfmt;
                            "sh.shfmt" = shfmt;
                            "sql.pgformat" = pgformatter;
                            "sql.sqlfluff" = sqlfluff;
                            "svelte.prettier" = nodePackages.prettier;
                            "terraform.terraformfmt" = terraform;
                            "tex.latexindent" = texlive.combine {inherit (pkgs.texlive) scheme-minimal latexindent;};
                            "toml.taplo" = taplo;
                            "typescript.tsfmt" = abort "Can't find a tsfmt package";
                            "typescript.prettier" = nodePackages.prettier;
                            "typescript.prettierd" = prettierd;
                            "typescript.prettiereslint" = abort "Can't find a prettier-eslint package";
                            "typescript.eslint_d" = nodePackages.eslint_d;
                            "typescript.clangformat" = clang-tools;
                            "typescript.denofmt" = deno;
                            "typescript.biome" = biome;
                            "typescriptreact.tsfmt" = abort "Can't find a tsfmt package";
                            "typescriptreact.prettier" = nodePackages.prettier;
                            "typescriptreact.prettierd" = prettierd;
                            "typescriptreact.prettiereslint" = abort "Can't find a prettier-eslint package";
                            "typescriptreact.eslint_d" = nodePackages.eslint_d;
                            "typescriptreact.clangformat" = clang-tools;
                            "typescriptreact.denofmt" = deno;
                            "typescriptreact.biome" = biome;
                            "vue.prettier" = nodePackages.prettier;
                            "xhtml.tidy" = html-tidy;
                            "xml.tidy" = html-tidy;
                            "xml.xmllint" = libxml2;
                            "xml.xmlformat" = xmlformat;
                            "yaml.prettier" = nodePackages.prettier;
                            "yaml.prettierd" = prettierd;
                            "yaml.pyaml" = python3Packages.pyaml;
                            "yaml.yamlfmt" = yamlfmt;
                            "zig.zigfmt" = zig;
                            "zsh.beautysh" = beautysh;
                          }
                          ."${formatter}"
                  )
                  formatters)
            )
            (attrValues cfg.filetype)
          )
        else [];
    in
      mkIf cfg.enable {
        extraPlugins = [cfg.package];
        extraConfigLua = ''
          require("formatter").setup${helpers.toLuaObject setupOptions}
        '';
        extraPackages = packages;
      };
  }
