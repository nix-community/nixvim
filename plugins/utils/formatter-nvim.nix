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
      formatterPackages = with pkgs; {
        alejandra = helpers.mkPackageOption "alejandra" alejandra;
        astyle = helpers.mkPackageOption "astyle" astyle;
        autoflake = helpers.mkPackageOption "autoflake" autoflake;
        autopep8 = helpers.mkPackageOption "autopep8" python3Packages.autopep8;
        beautysh = helpers.mkPackageOption "beautysh" beautysh;
        biome = helpers.mkPackageOption "biome" biome;
        black = helpers.mkPackageOption "black" black;
        buf-format = helpers.mkPackageOption "buf-format" buf;
        clangformat = helpers.mkPackageOption "clangformat" clang-tools;
        cmake-format = helpers.mkPackageOption "cmake-format" cmake-format;
        csharpier = helpers.mkPackageOption "csharpier" (abort "Can't find a csharpier package");
        cssbeautifier = helpers.mkPackageOption "cssbeautifier" python3Packages.cssbeautifier;
        csscomb = helpers.mkPackageOption "csscomb" (abort "Can't find a csscomb package");
        dartformat = helpers.mkPackageOption "dartformat" dart;
        denofmt = helpers.mkPackageOption "denofmt" deno;
        docformatter = helpers.mkPackageOption "docformatter" python3Packages.docformatter;
        dotnetformat = helpers.mkPackageOption "dotnetformat" dotnet-sdk;
        erbformatter = helpers.mkPackageOption "erbformatter" rubyPackages.erb-formatter;
        esformatter = helpers.mkPackageOption "esformatter" (abort "Can't find a esformatter package");
        eslint_d = helpers.mkPackageOption "eslint_d" nodePackages.eslint_d;
        fishindent = helpers.mkPackageOption "fishindent" fish;
        fixjson = helpers.mkPackageOption "fixjson" nodePackages.fixjson;
        gofmt = helpers.mkPackageOption "gofmt" go;
        gofumports = helpers.mkPackageOption "gofumports" (abort "Can't find a gofumports package");
        gofumpt = helpers.mkPackageOption "gofumpt" gofumpt;
        goimports = helpers.mkPackageOption "goimports" gotools;
        golines = helpers.mkPackageOption "golines" golines;
        google-java-format = helpers.mkPackageOption "google-java-format" google-java-format;
        html-tidy = helpers.mkPackageOption "html-tidy" html-tidy;
        htmlbeautifier = helpers.mkPackageOption "htmlbeautifier" rubyPackages.htmlbeautifier;
        isort = helpers.mkPackageOption "isort" isort;
        jq = helpers.mkPackageOption "jq" jq;
        js-beautify = helpers.mkPackageOption "js-beautify" nodePackages.js-beautify;
        ktlint = helpers.mkPackageOption "ktlint" ktlint;
        latexindent = helpers.mkPackageOption "latexindent" (texlive.combine {inherit (pkgs.texlive) scheme-minimal latexindent;});
        liquidsoap-prettier = helpers.mkPackageOption "liquidsoap-prettier" (abort "Can't find a liquidsoap-prettier package");
        lua-format = helpers.mkPackageOption "lua-format" (abort "Can't find a lua-format package");
        luafmt = helpers.mkPackageOption "luafmt" (abort "Can't find a luafmt package");
        luaformatter = helpers.mkPackageOption "luaformatter" luaformatter;
        mixformat = helpers.mkPackageOption "mixformat" elixir;
        nixfmt = helpers.mkPackageOption "nixfmt" nixfmt;
        nixpkgs-fmt = helpers.mkPackageOption "nixpkgs-fmt" nixpkgs-fmt;
        ocamlformat = helpers.mkPackageOption "ocamlformat" ocamlPackages.ocamlformat;
        perltidy = helpers.mkPackageOption "perltidy" perlPackages.PerlTidy;
        php-cs-fixer = helpers.mkPackageOption "php-cs-fixer" phpPackages.php-cs-fixer;
        phpcbf = helpers.mkPackageOption "phpcbf" phpPackages.phpcbf;
        pint = helpers.mkPackageOption "pint" (abort "Can't find a pint package");
        prettier = helpers.mkPackageOption "prettier" nodePackages.prettier;
        prettier-eslint = helpers.mkPackageOption "prettier-eslint" (abort "Can't find a prettier-eslint package");
        prettierd = helpers.mkPackageOption "prettierd" prettierd;
        prettydiff = helpers.mkPackageOption "prettydiff" (abort "Can't find a prettydiff package");
        pgformatter = helpers.mkPackageOption "pgformatter" pgformatter;
        pyaml = helpers.mkPackageOption "pyaml" python3Packages.pyaml;
        pydevf = helpers.mkPackageOption "pydevf" (abort "Can't find a pydevf package");
        pyment = helpers.mkPackageOption "pyment" python3Packages.pyment;
        rubocop = helpers.mkPackageOption "rubocop" rubocop;
        ruff = helpers.mkPackageOption "ruff" ruff;
        rustfmt = helpers.mkPackageOption "rustfmt" rustfmt;
        shfmt = helpers.mkPackageOption "shfmt" shfmt;
        semistandard = helpers.mkPackageOption "semistandard" (abort "Can't find a semistandard package");
        sqlfluff = helpers.mkPackageOption "sqlfluff" sqlfluff;
        standard = helpers.mkPackageOption "standard" (abort "Can't find a standard package");
        standardrb = helpers.mkPackageOption "standardrb" (abort "Can't find a standardrb package");
        stylefmt = helpers.mkPackageOption "stylefmt" (abort "Can't find a stylefmt package");
        styler = helpers.mkPackageOption "styler" rWrapper.override {packages = with rPackages; [styler];};
        stylish-haskell = helpers.mkPackageOption "stylish-haskell" stylish-haskell;
        stylua = helpers.mkPackageOption "stylua" stylua;
        taplo = helpers.mkPackageOption "taplo" taplo;
        terraform = helpers.mkPackageOption "terraform" terraform;
        tsfmt = helpers.mkPackageOption "tsfmt" (abort "Can't find a tsfmt package");
        uncrustify = helpers.mkPackageOption "uncrustify" uncrustify;
        xmlformat = helpers.mkPackageOption "xmlformat" xmlformat;
        xmllint = helpers.mkPackageOption "xmllint" libxml2;
        yamlfmt = helpers.mkPackageOption "yamlfmt" yamlfmt;
        yapf = helpers.mkPackageOption "yapf" yapf;
        zigfmt = helpers.mkPackageOption "zigfmt" zig;
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
                lists.remove "" (concat (
                    formatter:
                      if (builtins.typeOf formatter) == "set"
                      then ""
                      else
                        with pkgs;
                          {
                            "any.remove_trailing_whitespace" = "";
                            "any.substitute_trailing_whitespace" = "";
                            "awk.prettier" = cfg.formatterPackages.prettier;
                            "awk.prettierd" = cfg.formatterPackages.prettierd;
                            "c.uncrustify" = cfg.formatterPackages.uncrustify;
                            "c.clangformat" = cfg.formatterPackages.clang-toolsy;
                            "c.astyle" = cfg.formatterPackages.astyle;
                            "cmake.cmakeformat" = cfg.formatterPackages.cmake-format;
                            "cpp.uncrustify" = cfg.formatterPackages.uncrustify;
                            "cpp.clangformat" = cfg.formatterPackages.clang-toolsy;
                            "cpp.astyle" = cfg.formatterPackages.astyle;
                            "cs.uncrustify" = cfg.formatterPackages.uncrustify;
                            "cs.clangformat" = cfg.formatterPackages.clang-toolsy;
                            "cs.astyle" = cfg.formatterPackages.astyle;
                            "cs.dotnetformat" = cfg.formatterPackages.dotnetformat;
                            "cs.csharpier" = cfg.formatterPackages.csharpier;
                            "css.prettydiff" = cfg.formatterPackages.prettydiff;
                            "css.prettier" = cfg.formatterPackages.prettier;
                            "css.prettierd" = cfg.formatterPackages.prettierd;
                            "css.eslint_d" = cfg.formatterPackages.eslint_d;
                            "css.stylefmt" = cfg.formatterPackages.stylefmt;
                            "css.cssbeautify" = cfg.formatterPackages.cssbeautifier;
                            "css.csscomb" = cfg.formatterPackages.csscomb;
                            "dart.dartformat" = cfg.formatterPackages.dartformat;
                            "elixir.mixformat" = cfg.formatterPackages.mixformat;
                            "eruby.erbformatter" = cfg.formatterPackages.erbformatter;
                            "eruby.htmlbeautifier" = cfg.formatterPackages.htmlbeautifier;
                            "fish.fishindent" = cfg.formatterPackages.fishindent;
                            "go.gofmt" = cfg.formatterPackages.gofmt;
                            "go.goimports" = cfg.formatterPackages.goimports;
                            "go.gofumpt" = cfg.formatterPackages.gofumpt;
                            "go.gofumports" = cfg.formatterPackages.gofumports;
                            "go.golines" = cfg.formatterPackages.golines;
                            "graphql.prettier" = cfg.formatterPackages.prettier;
                            "graphql.prettierd" = cfg.formatterPackages.prettierd;
                            "haskell.stylish_haskell" = cfg.formatterPackages.stylish-haskell;
                            "html.prettier" = cfg.formatterPackages.prettier;
                            "html.prettierd" = cfg.formatterPackages.prettierd;
                            "html.prettydiff" = cfg.formatterPackages.prettydiff;
                            "html.htmlbeautifier" = cfg.formatterPackages.htmlbeautifier;
                            "html.tidy" = cfg.formatterPackages.html-tidy;
                            "java.clangformat" = cfg.formatterPackages.clang-toolsy;
                            "java.google_java_format" = cfg.formatterPackages.google-java-format;
                            "javascript.jsbeautify" = cfg.formatterPackages.js-beautify;
                            "javascript.clangformat" = cfg.formatterPackages.clang-toolsy;
                            "javascript.prettydiff" = cfg.formatterPackages.prettydiff;
                            "javascript.esformatter" = cfg.formatterPackages.esformatter;
                            "javascript.prettier" = cfg.formatterPackages.prettier;
                            "javascript.prettierd" = cfg.formatterPackages.prettierd;
                            "javascript.prettiereslint" = cfg.formatterPackages.prettier-eslint;
                            "javascript.eslint_d" = cfg.formatterPackages.eslint_d;
                            "javascript.standard" = cfg.formatterPackages.standard;
                            "javascript.denofmt" = cfg.formatterPackages.denofmt;
                            "javascript.semistandard" = cfg.formatterPackages.semistandard;
                            "javascript.biome" = cfg.formatterPackages.biome;
                            "javascriptreact.jsbeautify" = cfg.formatterPackages.js-beautify;
                            "javascriptreact.clangformat" = cfg.formatterPackages.clang-toolsy;
                            "javascriptreact.prettydiff" = cfg.formatterPackages.prettydiff;
                            "javascriptreact.esformatter" = cfg.formatterPackages.esformatter;
                            "javascriptreact.prettier" = cfg.formatterPackages.prettier;
                            "javascriptreact.prettierd" = cfg.formatterPackages.prettierd;
                            "javascriptreact.prettiereslint" = cfg.formatterPackages.prettier-eslint;
                            "javascriptreact.eslint_d" = cfg.formatterPackages.eslint_d;
                            "javascriptreact.standard" = cfg.formatterPackages.standard;
                            "javascriptreact.denofmt" = cfg.formatterPackages.denofmt;
                            "javascriptreact.semistandard" = cfg.formatterPackages.semistandard;
                            "javascriptreact.biome" = cfg.formatterPackages.biome;
                            "json.jsbeautify" = cfg.formatterPackages.js-beautify;
                            "json.prettydiff" = cfg.formatterPackages.prettydiff;
                            "json.prettier" = cfg.formatterPackages.prettier;
                            "json.prettierd" = cfg.formatterPackages.prettierd;
                            "json.denofmt" = cfg.formatterPackages.denofmt;
                            "json.biome" = cfg.formatterPackages.biome;
                            "json.jq" = cfg.formatterPackages.jq;
                            "json.fixjson" = cfg.formatterPackages.fixjson;
                            "kotlin.ktlint" = cfg.formatterPackages.ktlint;
                            "latex.latexindent" = cfg.formatterPackages.latexindent;
                            "liquidsoap.liquidsoap_prettier" = cfg.formatterPackages.liquidsoap-prettier;
                            "lua.luaformatter" = cfg.formatterPackages.luaformatter;
                            "lua.luafmt" = cfg.formatterPackages.luafmt;
                            "lua.luaformat" = cfg.formatterPackages.lua-format;
                            "lua.stylua" = cfg.formatterPackages.stylua;
                            "markdown.prettier" = cfg.formatterPackages.prettier;
                            "markdown.prettierd" = cfg.formatterPackages.prettierd;
                            "markdown.denofmt" = cfg.formatterPackages.denofmt;
                            "nix.alejandra" = cfg.formatterPackages.alejandra;
                            "nix.nixfmt" = cfg.formatterPackages.nixfmt;
                            "nix.nixpkgs_fmt" = cfg.formatterPackages.nixpkgs-fmt;
                            "ocaml.ocamlformat" = cfg.formatterPackages.ocamlformat;
                            "perl.perltidy" = cfg.formatterPackages.perltidy;
                            "php.phpcbf" = cfg.formatterPackages.phpcbf;
                            "php.php_cs_fixer" = cfg.formatterPackages.php-cs-fixer;
                            "php.pint" = cfg.formatterPackages.pint;
                            "proto.buf_format" = cfg.formatterPackages.buf;
                            "python.yapf" = cfg.formatterPackages.yapf;
                            "python.autopep8" = cfg.formatterPackages.autopep8;
                            "python.isort" = cfg.formatterPackages.isort;
                            "python.docformatter" = cfg.formatterPackages.docformatter;
                            "python.black" = cfg.formatterPackages.black;
                            "python.ruff" = cfg.formatterPackages.ruff;
                            "python.pyment" = cfg.formatterPackages.pyment;
                            "python.pydevf" = cfg.formatterPackages.pydevf;
                            "python.autoflake" = cfg.formatterPackages.autoflake;
                            "r.styler" = cfg.formatterPackages.styler;
                            "ruby.rubocop" = cfg.formatterPackages.rubocop;
                            "ruby.standardrb" = cfg.formatterPackages.standardrb;
                            "rust.rustfmt" = cfg.formatterPackages.rustfmt;
                            "sh.shfmt" = cfg.formatterPackages.shfmt;
                            "sql.pgformat" = cfg.formatterPackages.pgformatter;
                            "sql.sqlfluff" = cfg.formatterPackages.sqlfluff;
                            "svelte.prettier" = cfg.formatterPackages.prettier;
                            "terraform.terraformfmt" = cfg.formatterPackages.terraform;
                            "tex.latexindent" = cfg.formatterPackages.latexindent;
                            "toml.taplo" = cfg.formatterPackages.taplo;
                            "typescript.tsfmt" = cfg.formatterPackages.tsfmt;
                            "typescript.prettier" = cfg.formatterPackages.prettier;
                            "typescript.prettierd" = cfg.formatterPackages.prettierd;
                            "typescript.prettiereslint" = cfg.formatterPackages.prettier-eslint;
                            "typescript.eslint_d" = cfg.formatterPackages.eslint_d;
                            "typescript.clangformat" = cfg.formatterPackages.clang-toolsy;
                            "typescript.denofmt" = cfg.formatterPackages.denofmt;
                            "typescript.biome" = cfg.formatterPackages.biome;
                            "typescriptreact.tsfmt" = cfg.formatterPackages.tsfmt;
                            "typescriptreact.prettier" = cfg.formatterPackages.prettier;
                            "typescriptreact.prettierd" = cfg.formatterPackages.prettierd;
                            "typescriptreact.prettiereslint" = cfg.formatterPackages.prettier-eslint;
                            "typescriptreact.eslint_d" = cfg.formatterPackages.eslint_d;
                            "typescriptreact.clangformat" = cfg.formatterPackages.clang-toolsy;
                            "typescriptreact.denofmt" = cfg.formatterPackages.denofmt;
                            "typescriptreact.biome" = cfg.formatterPackages.biome;
                            "vue.prettier" = cfg.formatterPackages.prettier;
                            "xhtml.tidy" = cfg.formatterPackages.html-tidy;
                            "xml.tidy" = cfg.formatterPackages.html-tidy;
                            "xml.xmllint" = cfg.formatterPackages.xmllint;
                            "xml.xmlformat" = cfg.formatterPackages.xmlformat;
                            "yaml.prettier" = cfg.formatterPackages.prettier;
                            "yaml.prettierd" = cfg.formatterPackages.prettierd;
                            "yaml.pyaml" = cfg.formatterPackages.pyaml;
                            "yaml.yamlfmt" = cfg.formatterPackages.yamlfmt;
                            "zig.zigfmt" = cfg.formatterPackages.zigfmt;
                            "zsh.beautysh" = cfg.formatterPackages.beautysh;
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
