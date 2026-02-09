{
  pkgs,
  ...
}:
with pkgs;
let
  states = {
    broken = _package: "broken";
    darwinOnly = _package: "Darwin only";
    unpackaged = "unpackaged";
  };
in
{
  inherit states;
  formatter-packages = {
    format-queries = null; # Uses neovim itself
    init = null; # Internal thingamajig
    injected = null; # Internal formatter
    trim_newlines = null; # Conform native formatter
    trim_whitespace = null; # Conform native formatter

    auto_optional = states.unpackaged;
    bake = states.unpackaged;
    blue = states.unpackaged;
    bpfmt = states.unpackaged;
    bsfmt = states.unpackaged;
    caramel_fmt = states.unpackaged;
    crlfmt = states.unpackaged;
    darker = states.unpackaged;
    dcm_fix = states.unpackaged;
    dcm_format = states.unpackaged;
    easy-coding-standard = states.unpackaged;
    findent = states.unpackaged;
    ghokin = states.unpackaged;
    gluon_fmt = states.unpackaged;
    grain_format = states.unpackaged;
    hledger-fmt = states.unpackaged;
    imba_fmt = states.unpackaged;
    janet-format = states.unpackaged;
    json_repair = states.unpackaged;
    liquidsoap-prettier = states.unpackaged;
    llf = states.unpackaged;
    markdown-toc = states.unpackaged;
    markdownfmt = states.unpackaged;
    mdslw = states.unpackaged;
    mojo_format = states.unpackaged;
    nomad_fmt = states.unpackaged;
    npm-groovy-lint = states.unpackaged;
    packer_fmt = states.unpackaged;
    palantir-java-format = states.unpackaged;
    pangu = states.unpackaged;
    perlimports = states.unpackaged;
    pint = states.unpackaged;
    purs-tidy = states.unpackaged;
    pycln = states.unpackaged;
    pyink = states.unpackaged;
    pymarkdownlnt = states.unpackaged;
    reformat-gherkin = states.unpackaged;
    rescript-format = states.unpackaged;
    runic = states.unpackaged;
    spotless_gradle = states.unpackaged;
    spotless_maven = states.unpackaged;
    standard-clj = states.unpackaged;
    standardjs = states.unpackaged;
    tlint = states.unpackaged;
    twig-cs-fixer = states.unpackaged;
    typstfmt = states.unpackaged;
    vsg = states.unpackaged;
    ziggy = states.unpackaged;
    ziggy_schema = states.unpackaged;

    inherit (python313Packages) autopep8;
    awk = gawk;
    bean-format = beancount;
    biome-check = biome;
    biome-organize-imports = biome;
    cabal_fmt = haskellPackages.cabal-fmt;
    clang-format = clang-tools;
    clang_format = clang-tools;
    cmake_format = cmake-format;
    css_beautify = nodePackages.js-beautify;
    cue_fmt = cue;
    dart_format = dart;
    deno_fmt = deno;
    dioxus = dioxus-cli;
    inherit (python313Packages) docformatter;
    # FIXME: 2026-01-23 docstrfmt test failure in nixpkgs
    docstrfmt = states.broken python313Packages.docstrfmt;
    elm_format = elmPackages.elm-format;
    erb_format = rubyPackages.erb-formatter;
    fish_indent = fishMinimal;
    forge_fmt = foundry;
    format-dune-file = dune_3;
    # FIXME: 2025-09-17 build failure
    gci = states.broken gci;
    # TODO: 2026-01-23 gdscript-formatter hash mismatch in nixpkgs
    gdformat = states.broken gdtoolkit_4;
    gofmt = go;
    goimports = gotools;
    hcl = hclfmt;
    # FIXME: 2025-10-08 build failure (haskellPackages.hindent)
    hindent = states.broken haskellPackages.hindent;
    html_beautify = nodePackages.js-beautify;
    inherit (rubyPackages) htmlbeautifier;
    hurlfmt = hurl;
    # FIXME: 2025-09-13 build failure
    inko = states.broken inko;
    js_beautify = nodePackages.js-beautify;
    jsonnetfmt = jsonnet;
    inherit (texlive.pkgs) latexindent;
    lua-format = luaformatter;
    mago_format = mago;
    mago_lint = mago;
    markdownlint = markdownlint-cli;
    mh_style = python3Packages.miss-hit;
    mix = beamMinimal28Packages.elixir;
    nginxfmt = nginx-config-formatter;
    nimpretty = nim;
    nixpkgs_fmt = nixpkgs-fmt;
    inherit (ocamlPackages) ocp-indent;
    odinfmt = ols;
    # TODO: added 2026-02-08 broken on darwin
    opa_fmt = if stdenv.isDarwin then states.broken open-policy-agent else open-policy-agent;
    perltidy = perlPackages.PerlTidy;
    pg_format = pgformatter;
    # FIXME: 2025-12-24: phpPackages.php-codesniffer is broken
    # https://github.com/NixOS/nixpkgs/pull/459254#issuecomment-3689578764
    phpcbf = states.broken php84Packages.php-codesniffer;
    php_cs_fixer = php83Packages.php-cs-fixer;
    inherit (php84Packages) phpinsights;
    prolog = swi-prolog;
    pyproject-fmt = python313Packages.pyproject-parser;
    inherit (python313Packages) python-ly;
    qmlformat = libsForQt5.qt5.qtdeclarative;
    # TODO: added 2026-02-08 marked unsupported on darwin
    racketfmt = if stdenv.hostPlatform.isLinux then racket else states.broken racket;
    inherit (python313Packages) reorder-python-imports;
    # FIXME: 2025-11-25 build failure
    roc = states.broken roc;
    ruff_fix = ruff;
    ruff_format = ruff;
    ruff_organize_imports = ruff;
    # FIXME: 2025-10-12 build failure on Darwin
    smlfmt = if stdenv.isDarwin then states.broken smlfmt else smlfmt;
    sql_formatter = sql-formatter;
    inherit (python313Packages) sqlfmt;
    squeeze_blanks = coreutils;
    standardrb = rubyPackages.standard;
    styler = R;
    swift = states.darwinOnly swift;
    swiftformat = states.darwinOnly swiftformat;
    swift_format = states.darwinOnly swift-format;
    swiftlint = states.darwinOnly swiftlint;
    inherit (rubyPackages) syntax_tree;
    tclfmt = tclint;
    terraform_fmt = tenv;
    terragrunt_hclfmt = terragrunt;
    tofu_fmt = opentofu;
    v = vlang;
    xmlformatter = xmlformat;
    xmllint = libxml2;
    zigfmt = zig;
  };
}
