{
  pkgs,
  ...
}:
with pkgs;
rec {
  sType = {
    broken = "broken";
    darwinOnly = "Darwin only";
    unpackaged = "unpackaged";
  };

  formatter-packages = {
    swift_format = if !stdenv.isDarwin then sType.darwinOnly else swift-format;
    swiftlint = if !stdenv.isDarwin then sType.darwinOnly else swiftlint;

    # 2025-10-12 build failure on Darwin
    smlfmt = if stdenv.isDarwin then sType.broken else smlfmt;

    # 2025-09-13 build failure
    inko = sType.broken;
    # 2025-09-17 build failure
    gci = sType.broken;
    # 2025-10-08 build failure (haskellPackages.hindent)
    hindent = sType.broken;

    format-queries = null; # Uses neovim itself
    init = null; # Internal thingamajig
    injected = null; # Internal formatter
    trim_newlines = null; # Conform native formatter
    trim_whitespace = null; # Conform native formatter

    auto_optional = sType.unpackaged;
    bake = sType.unpackaged;
    blue = sType.unpackaged;
    bpfmt = sType.unpackaged;
    bsfmt = sType.unpackaged;
    caramel_fmt = sType.unpackaged;
    crlfmt = sType.unpackaged;
    darker = sType.unpackaged;
    dcm_fix = sType.unpackaged;
    dcm_format = sType.unpackaged;
    easy-coding-standard = sType.unpackaged;
    findent = sType.unpackaged;
    ghokin = sType.unpackaged;
    gluon_fmt = sType.unpackaged;
    grain_format = sType.unpackaged;
    hledger-fmt = sType.unpackaged;
    imba_fmt = sType.unpackaged;
    janet-format = sType.unpackaged;
    json_repair = sType.unpackaged;
    liquidsoap-prettier = sType.unpackaged;
    llf = sType.unpackaged;
    markdown-toc = sType.unpackaged;
    markdownfmt = sType.unpackaged;
    mdslw = sType.unpackaged;
    mojo_format = sType.unpackaged;
    nomad_fmt = sType.unpackaged;
    npm-groovy-lint = sType.unpackaged;
    packer_fmt = sType.unpackaged;
    pangu = sType.unpackaged;
    perlimports = sType.unpackaged;
    pint = sType.unpackaged;
    purs-tidy = sType.unpackaged;
    pycln = sType.unpackaged;
    pyink = sType.unpackaged;
    pymarkdownlnt = sType.unpackaged;
    reformat-gherkin = sType.unpackaged;
    rescript-format = sType.unpackaged;
    runic = sType.unpackaged;
    spotless_gradle = sType.unpackaged;
    spotless_maven = sType.unpackaged;
    standard-clj = sType.unpackaged;
    standardjs = sType.unpackaged;
    tlint = sType.unpackaged;
    twig-cs-fixer = sType.unpackaged;
    typstfmt = sType.unpackaged;
    vsg = sType.unpackaged;
    ziggy = sType.unpackaged;
    ziggy_schema = sType.unpackaged;

    inherit (python313Packages) autopep8;
    awk = gawk;
    bean-format = beancount;
    biome-check = biome;
    biome-organize-imports = biome;
    cabal_fmt = haskellPackages.cabal-fmt;
    clang_format = clang-tools;
    clang-format = clang-tools;
    cmake_format = cmake-format;
    css_beautify = nodePackages.js-beautify;
    cue_fmt = cue;
    dart_format = dart;
    deno_fmt = deno;
    dioxus = dioxus-cli;
    inherit (python313Packages) docformatter;
    elm_format = elmPackages.elm-format;
    erb_format = rubyPackages.erb-formatter;
    fish_indent = fishMinimal;
    forge_fmt = foundry;
    format-dune-file = dune_3;
    gdformat = gdtoolkit_4;
    gofmt = go;
    goimports = gotools;
    hcl = hclfmt;
    html_beautify = nodePackages.js-beautify;
    inherit (rubyPackages) htmlbeautifier;
    hurlfmt = hurl;
    js_beautify = nodePackages.js-beautify;
    jsonnetfmt = jsonnet;
    inherit (texlive.pkgs) latexindent;
    lua-format = luaformatter;
    mago_format = mago;
    mago_lint = mago;
    markdownlint = markdownlint-cli;
    mix = beamMinimal28Packages.elixir;
    nginxfmt = nginx-config-formatter;
    nimpretty = nim;
    nixpkgs_fmt = nixpkgs-fmt;
    inherit (ocamlPackages) ocp-indent;
    odinfmt = ols;
    opa_fmt = open-policy-agent;
    perltidy = perl538Packages.PerlTidy;
    pg_format = pgformatter;
    php_cs_fixer = php83Packages.php-cs-fixer;
    phpcbf = php84Packages.php-codesniffer;
    inherit (php84Packages) phpinsights;
    prolog = swi-prolog;
    pyproject-fmt = python313Packages.pyproject-parser;
    inherit (python313Packages) python-ly;
    qmlformat = libsForQt5.qt5.qtdeclarative;
    racketfmt = racket;
    inherit (python313Packages) reorder-python-imports;
    ruff_fix = ruff;
    ruff_format = ruff;
    ruff_organize_imports = ruff;
    sql_formatter = sql-formatter;
    inherit (python313Packages) sqlfmt;
    squeeze_blanks = coreutils;
    standardrb = rubyPackages.standard;
    styler = R;
    inherit (rubyPackages) syntax_tree;
    terraform_fmt = tenv;
    terragrunt_hclfmt = terragrunt;
    tofu_fmt = opentofu;
    v = vlang;
    xmlformatter = xmlformat;
    xmllint = libxml2;
    zigfmt = zig;
  };
}
