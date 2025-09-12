{
  pkgs,
  lib,
  ...
}:
let
  inherit (builtins)
    elem
    filter
    isString
    isAttrs
    attrValues
    concatMap
    partition
    ;

  unpackaged = null;
  ignore = null;

  specialCases = with pkgs; {
    format-queries = ignore; # Uses neovim itself
    init = ignore; # Internal thingamajig
    injected = ignore; # Internal formatter
    trim_newlines = ignore; # Conform native formatter
    trim_whitespace = ignore; # Conform native formatter

    auto_optional = unpackaged;
    inherit (python313Packages) autopep8;
    awk = gawk;
    bake = unpackaged;
    bean-format = beancount;
    biome-check = biome;
    biome-organize-imports = biome;
    blue = unpackaged;
    bpfmt = unpackaged;
    bsfmt = unpackaged;
    cabal_fmt = haskellPackages.cabal-fmt;
    caramel_fmt = unpackaged;
    clang_format = clang-tools;
    clang-format = clang-tools;
    cmake_format = cmake-format;
    crlfmt = unpackaged;
    css_beautify = nodePackages.js-beautify;
    cue_fmt = cue;
    darker = unpackaged;
    dart_format = dart;
    dcm_fix = unpackaged;
    dcm_format = unpackaged;
    deno_fmt = deno;
    dioxus = dioxus-cli;
    inherit (python313Packages) docformatter;
    easy-coding-standard = unpackaged;
    elm_format = elmPackages.elm-format;
    erb_format = rubyPackages.erb-formatter;
    findent = unpackaged;
    fish_indent = fishMinimal;
    forge_fmt = foundry;
    format-dune-file = dune_3;
    gdformat = gdtoolkit_4;
    ghokin = unpackaged;
    gluon_fmt = unpackaged;
    gofmt = go;
    goimports = gotools;
    grain_format = unpackaged;
    hcl = hclfmt;
    inherit (haskellPackages) hindent;
    hledger-fmt = unpackaged;
    html_beautify = nodePackages.js-beautify;
    inherit (rubyPackages) htmlbeautifier;
    hurlfmt = hurl;
    imba_fmt = unpackaged;
    janet-format = unpackaged;
    js_beautify = nodePackages.js-beautify;
    jsonnetfmt = jsonnet;
    inherit (texlive.pkgs) latexindent;
    liquidsoap-prettier = unpackaged;
    llf = unpackaged;
    lua-format = luaformatter;
    mago_format = mago;
    mago_lint = mago;
    markdown-toc = unpackaged;
    markdownfmt = unpackaged;
    markdownlint = markdownlint-cli;
    mdslw = unpackaged;
    mix = beamMinimal28Packages.elixir;
    mojo_format = unpackaged;
    nginxfmt = nginx-config-formatter;
    nimpretty = nim;
    nixpkgs_fmt = nixpkgs-fmt;
    nomad_fmt = unpackaged;
    npm-groovy-lint = unpackaged;
    inherit (ocamlPackages) ocp-indent;
    odinfmt = ols;
    opa_fmt = open-policy-agent;
    packer_fmt = unpackaged;
    pangu = unpackaged;
    perlimports = unpackaged;
    perltidy = perl538Packages.PerlTidy;
    pg_format = pgformatter;
    php_cs_fixer = php83Packages.php-cs-fixer;
    phpcbf = php84Packages.php-codesniffer;
    inherit (php84Packages) phpinsights;
    pint = unpackaged;
    prolog = swi-prolog;
    purs-tidy = unpackaged;
    pycln = unpackaged;
    pyink = unpackaged;
    pymarkdownlnt = unpackaged;
    pyproject-fmt = python313Packages.pyproject-parser;
    inherit (python313Packages) python-ly;
    qmlformat = libsForQt5.qt5.qtdeclarative;
    reformat-gherkin = unpackaged;
    inherit (python313Packages) reorder-python-imports;
    rescript-format = unpackaged;
    ruff_fix = ruff;
    ruff_format = ruff;
    ruff_organize_imports = ruff;
    runic = unpackaged;
    spotless_gradle = unpackaged;
    spotless_maven = unpackaged;
    sql_formatter = sql-formatter;
    inherit (python313Packages) sqlfmt;
    squeeze_blanks = coreutils;
    standard-clj = unpackaged;
    standardjs = unpackaged;
    standardrb = rubyPackages.standard;
    styler = R;
    swift_format = if !pkgs.stdenv.isDarwin then null else swift-format;
    swiftlint = if !pkgs.stdenv.isDarwin then null else swiftlint;
    inherit (rubyPackages) syntax_tree;
    terraform_fmt = tenv;
    terragrunt_hclfmt = terragrunt;
    tlint = unpackaged;
    tofu_fmt = opentofu;
    twig-cs-fixer = unpackaged;
    v = vlang;
    vsg = unpackaged;
    xmlformatter = xmlformat;
    xmllint = libxml2;
    zigfmt = zig;
    ziggy = unpackaged;
    ziggy_schema = unpackaged;
  };
in
rec {
  getPkgFromConformName =
    ignoredFormatters: cn:
    lib.optionals (!(elem cn ignoredFormatters)) [ (specialCases.${cn} or pkgs.${cn}) ];

  collectFormatters =
    a:
    let
      filteredAttrs = filter (x: isString x || isAttrs x) (lib.flatten a);
      partitioned = partition isString filteredAttrs;
    in
    lib.optionals (a != [ ]) (
      partitioned.right ++ concatMap (a: collectFormatters (attrValues a)) partitioned.wrong
    );
}
