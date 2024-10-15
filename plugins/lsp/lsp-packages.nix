{
  unpackaged = [
    "agda_ls"
    "anakin_language_server"
    "angularls"
    "antlersls"
    "apex_ls"
    "awk_ls"
    "azure_pipelines_ls"
    "bacon_ls"
    "basics_ls"
    "bazelrc_lsp"
    "bicep" # Bicep.Cli is packaged, but not Bicep.LangServer
    "bitbake_ls"
    "bqnlsp"
    "bright_script"
    "bsl_ls"
    "buddy_ls"
    "bzl"
    "c3_lsp"
    "cadence"
    "cairo_ls"
    "cds_lsp"
    "circom-lsp"
    "clarity_lsp"
    "cobol_ls"
    "codeqlls"
    "coffeesense"
    "contextive"
    "coq_lsp"
    "css_variables"
    "cssmodules_ls"
    "cucumber_language_server"
    "custom_elements_ls"
    "cypher_ls"
    "daedalus_ls"
    "dcmls"
    "debputy"
    "delphi_ls"
    "djlsp"
    "dolmenls"
    "drools_lsp"
    "ds_pinyin_lsp"
    "earthlyls"
    "ecsact"
    "elp"
    "ember"
    "esbonio"
    "facility_language_server"
    "fennel_language_server"
    "fish_lsp"
    "flux_lsp"
    "foam_ls"
    "fsharp_language_server"
    "gdscript"
    "gdshader_lsp"
    "ghdl_ls"
    "ginko_ls"
    "gitlab_ci_ls"
    "glasgow"
    "glint"
    "gradle_ls"
    "grammarly"
    "groovyls"
    "guile_ls"
    "haxe_language_server"
    "hdl_checker"
    "hhvm"
    "hie"
    "hlasm"
    "hoon_ls"
    "hydra_lsp"
    "intelephense"
    "janet_lsp"
    "jinja_lsp"
    "julials"
    "kcl"
    "kulala_ls"
    "lean3ls"
    "lelwel_ls"
    "luau_lsp"
    "lwc_ls"
    "m68k"
    "marko-js"
    "mdx_analyzer"
    "millet"
    "mm0_ls"
    "mojo"
    "motoko_lsp"
    "move_analyzer"
    "msbuild_project_tools_server"
    "mutt_ls"
    "nelua_lsp"
    "nomad_lsp"
    "ntt"
    "nxls"
    "ocamlls"
    "ocamllsp"
    "opencl_ls"
    "openedge_ls"
    "openscad_ls"
    "pact_ls"
    "pasls"
    "pbls"
    "perlls"
    "pico8_ls"
    "pkgbuild_language_server"
    "please"
    "poryscript_pls"
    "powershell_es"
    "prismals"
    "prolog_ls"
    "prosemd_lsp"
    "protols"
    "pug"
    "puppet"
    "purescriptls"
    "pyre"
    "qml_lsp"
    "r_language_server"
    "racket_langserver"
    "raku_navigator"
    "reason_ls"
    "relay_lsp"
    "remark_ls"
    "rescriptls"
    "rnix"
    "robotframework_ls"
    "roc_ls"
    "rome"
    "rune_languageserver"
    "salt_ls"
    "sixtyfps"
    "slangd"
    "smarty_ls"
    "smithy_ls"
    "snakeskin_ls"
    "snyk_ls"
    "solang"
    "solidity"
    "solidity_ls"
    "solidity_ls_nomicfoundation"
    "somesass_ls"
    "sorbet"
    "sourcery"
    "spyglassmc_language_server"
    "sqlls"
    "steep"
    "stimulus_ls"
    "superhtml"
    "svlangserver"
    "tabby_ml"
    "textlsp"
    "theme_check"
    "thriftls"
    "tsp_server"
    "turtle_ls"
    "tvm_ffi_navigator"
    "twiggy_language_server"
    "ungrammar_languageserver"
    "unison" # Unison is packaged, but the lsp is not managed by neovim
    "unocss"
    "uvls"
    "v_analyzer"
    "vdmj"
    "veridian"
    "veryl_ls"
    "visualforce_ls"
    "vscoqtop"
    "vtsls"
    "vuels"
    "wgsl_analyzer"
    "yang_lsp"
    "yls"
    "ziggy"
    "ziggy_schema"
  ];

  packages = {
    aiken = "aiken";
    ansiblels = "ansible-language-server";
    arduino_language_server = "arduino-language-server";
    asm_lsp = "asm-lsp";
    ast_grep = "ast-grep";
    astro = "astro-language-server";
    autotools_ls = "autotools-language-server";
    ballerina = "ballerina";
    basedpyright = "basedpyright";
    bashls = "bash-language-server";
    beancount = "beancount-language-server";
    biome = "biome";
    bitbake_language_server = "bitbake-language-server";
    blueprint_ls = "blueprint-compiler";
    buck2 = "buck2";
    bufls = "buf-language-server";
    ccls = "ccls";
    clangd = "clang-tools";
    clojure_lsp = "clojure-lsp";
    cmake = "cmake-language-server";
    crystalline = "crystalline";
    csharp_ls = "csharp-ls";
    cssls = "vscode-langservers-extracted";
    dafny = "dafny";
    dagger = "cuelsp";
    dartls = "dart";
    denols = "deno";
    dhall_lsp_server = "dhall-lsp-server";
    diagnosticls = "diagnostic-languageserver";
    digestif = [
      "lua54Packages"
      "digestif"
    ];
    docker_compose_language_service = "docker-compose-language-service";
    dockerls = "dockerfile-language-server-nodejs";
    dotls = "dot-language-server";
    dprint = "dprint";
    efm = "efm-langserver";
    elmls = [
      "elmPackages"
      "elm-language-server"
    ];
    emmet_language_server = "emmet-language-server";
    emmet_ls = "emmet-ls";
    erg_language_server = "erg";
    erlangls = "erlang-ls";
    eslint = "vscode-langservers-extracted";
    fennel_ls = "fennel-ls";
    fortls = "fortls";
    fsautocomplete = "fsautocomplete";
    fstar = "fstar";
    futhark_lsp = "futhark";
    ghcide = [
      "haskellPackages"
      "ghcide"
    ];
    gleam = "gleam";
    glsl_analyzer = "glsl_analyzer";
    glslls = "glslls";
    graphql = [
      "nodePackages"
      "graphql-language-service-cli"
    ];
    golangci_lint_ls = "golangci-lint-langserver";
    gopls = "gopls";
    harper_ls = "harper";
    helm_ls = "helm-ls";
    hls = "haskell-language-server";
    html = "vscode-langservers-extracted";
    htmx = "htmx-lsp";
    hyprls = "hyprls";
    idris2_lsp = [
      "idris2Packages"
      "idris2Lsp"
    ];
    jdtls = "jdt-language-server";
    jedi_language_server = [
      "python3Packages"
      "jedi-language-server"
    ];
    jqls = "jq-lsp";
    jsonls = "vscode-langservers-extracted";
    jsonnet_ls = "jsonnet-language-server";
    koka = "koka";
    kotlin_language_server = "kotlin-language-server";
    leanls = "lean4";
    lemminx = "lemminx";
    lsp_ai = "lsp-ai";
    ltex = "ltex-ls";
    lua_ls = "lua-language-server";
    markdown_oxide = "markdown-oxide";
    marksman = "marksman";
    matlab_ls = "matlab-language-server";
    mesonlsp = "mesonlsp";
    metals = "metals";
    mint = "mint";
    mlir_lsp_server = [
      "llvmPackages"
      "mlir"
    ];
    mlir_pdll_lsp_server = [
      "llvmPackages"
      "mlir"
    ];
    neocmake = "neocmakelsp";
    nginx_language_server = "nginx-language-server";
    nickel_ls = "nls";
    nil_ls = "nil";
    nim_langserver = "nimlangserver";
    nimls = "nimlsp";
    nixd = "nixd";
    nushell = "nushell";
    ols = "ols";
    openscad_lsp = "openscad-lsp";
    perlnavigator = "perlnavigator";
    perlpls = [
      "perlPackages"
      "PLS"
    ];
    pest_ls = "pest-ide-tools";
    phan = [
      "phpPackages"
      "phan"
    ];
    phpactor = "phpactor";
    postgres_lsp = "postgres-lsp";
    psalm = [
      "phpPackages"
      "psalm"
    ];
    pylsp = [
      "python3Packages"
      "python-lsp-server"
    ];
    pylyzer = "pylyzer";
    pyright = "pyright";
    qmlls = [
      "kdePackages"
      "qtdeclarative"
    ];
    quick_lint_js = "quick-lint-js";
    regal = "regal";
    regols = "regols";
    # This is not entirely true, but the server is deprecated
    rls = "rustup";
    rubocop = "rubocop";
    ruby_lsp = "ruby-lsp";
    ruff = "ruff";
    ruff_lsp = "ruff-lsp";
    rust_analyzer = "rust-analyzer";
    scheme_langserver = [
      "akkuPackages"
      "scheme-langserver"
    ];
    scry = "scry";
    serve_d = "serve-d";
    shopify_theme_ls = "shopify-cli";
    slint_lsp = "slint-lsp";
    solargraph = [
      "rubyPackages"
      "solargraph"
    ];
    solc = "solc";
    sourcekit = "sourcekit-lsp";
    spectral = "spectral-language-server";
    sqls = "sqls";
    standardrb = [
      "rubyPackages"
      "standard"
    ];
    starlark_rust = "starlark-rust";
    starpls = "starpls-bin";
    statix = "statix";
    stylelint_lsp = "stylelint-lsp";
    svelte = "svelte-language-server";
    svls = "svls";
    swift_mesonls = "mesonlsp";
    syntax_tree = [
      "rubyPackages"
      "syntax_tree"
    ];
    tailwindcss = "tailwindcss-language-server";
    taplo = "taplo";
    tblgen_lsp_server = [
      "llvmPackages"
      "mlir"
    ];
    teal_ls = [
      "luaPackages"
      "teal-language-server"
    ];
    templ = "templ";
    terraform_lsp = "terraform-lsp";
    terraformls = "terraform-ls";
    texlab = "texlab";
    tflint = "tflint";
    tilt_ls = "tilt";
    tinymist = "tinymist";
    ts_ls = "typescript-language-server";
    ttags = "ttags";
    typeprof = "ruby";
    typos_lsp = "typos-lsp";
    typst_lsp = "typst-lsp";
    uiua = "uiua";
    vacuum = "vacuum-go";
    vala_ls = "vala-language-server";
    vale_ls = "vale-ls";
    verible = "verible";
    vhdl_ls = "vhdl-ls";
    vimls = "vim-language-server";
    vls = "vlang";
    volar = "vue-language-server";
    yamlls = "yaml-language-server";
    zk = "zk";
    zls = "zls";
  };

  # Servers that can't/don't use the provided upstream command in Nix, or packages with no upstream commands
  customCmd = {
    flow = {
      package = "flow";
      cmd = [
        "flow"
        "lsp"
      ];
    };
    elixirls = {
      package = "elixir-ls";
      cmd = [ "elixir-ls" ];
    };
    java_language_server = {
      package = "java-language-server";
      cmd = [ "java-language-server" ];
    };
    lexical = {
      package = "lexical";
      cmd = [ "lexical" ];
    };
    nextls = {
      package = "next-ls";
      cmd = [
        "nextls"
        "--stdio"
      ];
    };
    omnisharp = {
      package = "omnisharp-roslyn";
      cmd = [ "OmniSharp" ];
    };
  };

}
