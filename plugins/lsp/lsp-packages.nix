{
  unpackaged = [
    "ada_ls"
    "agda_ls"
    "alloy_ls"
    "anakin_language_server"
    "antlersls"
    "apex_ls"
    "autohotkey_lsp"
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
    "bufls"
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
    # coqPackages.coq-lsp is unavailable since the bump to coq 9.0: https://github.com/NixOS/nixpkgs/pull/389454
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
    "drools_lsp"
    "ds_pinyin_lsp"
    "dts_lsp"
    "ecsact"
    "ember"
    "esbonio"
    "facility_language_server"
    "fennel_language_server"
    "flux_lsp"
    "foam_ls"
    "fsharp_language_server"
    "gdscript"
    "gdshader_lsp"
    "gh_actions_ls"
    "ghdl_ls"
    "ginko_ls"
    "glasgow"
    "glint"
    "gradle_ls"
    "grammarly"
    "graphql" # nodePackages.graphql-language-service-cli was removed in https://github.com/NixOS/nixpkgs/pull/382557
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
    "ltex_plus"
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
    "nextflow_ls"
    "nomad_lsp"
    "ntt"
    "nxls"
    "ocamlls"
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
    "rnix"
    "robotcode"
    "robotframework_ls"
    "roc_ls"
    "rome"
    "salt_ls"
    "scry" # deprecated and removed from nixpkgs
    "selene3p_ls"
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
    "stylua3p_ls"
    "svlangserver"
    "tabby_ml"
    "textlsp"
    "theme_check"
    "tsp_server"
    "turbo_ls"
    "turtle_ls"
    # typst-lsp has been removed from nixpkgs as the project is archived
    "typst_lsp"
    "tvm_ffi_navigator"
    "twiggy_language_server"
    "ungrammar_languageserver"
    "unison" # Unison is packaged, but the lsp is not managed by neovim
    "unocss"
    "uvls"
    "v_analyzer"
    "vdmj"
    "veridian"
    "visualforce_ls"
    # coqPackages.vscoq-language-server is unavailable since the bump to coq 9.0: https://github.com/NixOS/nixpkgs/pull/389454
    "vscoqtop"
    "vuels"
    "wasm_language_tools"
    "yang_lsp"
    "yls"
    "ziggy"
    "ziggy_schema"
  ];

  packages = {
    aiken = "aiken";
    air = "air-formatter";
    angularls = "angular-language-server";
    ansiblels = "ansible-language-server";
    arduino_language_server = "arduino-language-server";
    asm_lsp = "asm-lsp";
    ast_grep = "ast-grep";
    astro = "astro-language-server";
    atlas = "atlas";
    autotools_ls = "autotools-language-server";
    ballerina = "ballerina";
    basedpyright = "basedpyright";
    bashls = "bash-language-server";
    beancount = "beancount-language-server";
    biome = "biome";
    bitbake_language_server = "bitbake-language-server";
    blueprint_ls = "blueprint-compiler";
    buck2 = "buck2";
    buf_ls = "buf";
    ccls = "ccls";
    clangd = "clang-tools";
    clojure_lsp = "clojure-lsp";
    cmake = "cmake-language-server";
    crystalline = "crystalline";
    csharp_ls = "csharp-ls";
    cssls = "vscode-langservers-extracted";
    cue = "cue";
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
    dolmenls = [
      "ocamlPackages"
      "dolmen_lsp"
    ];
    dotls = "dot-language-server";
    dprint = "dprint";
    earthlyls = "earthlyls";
    efm = "efm-langserver";
    elmls = [
      "elmPackages"
      "elm-language-server"
    ];
    elp = "erlang-language-platform";
    emmet_language_server = "emmet-language-server";
    emmet_ls = "emmet-ls";
    erg_language_server = "erg";
    erlangls = "erlang-ls";
    eslint = "vscode-langservers-extracted";
    fennel_ls = "fennel-ls";
    fish_lsp = "fish-lsp";
    fortls = "fortls";
    fsautocomplete = "fsautocomplete";
    fstar = "fstar";
    futhark_lsp = "futhark";
    ghcide = [
      "haskellPackages"
      "ghcide"
    ];
    gitlab_ci_ls = "gitlab-ci-ls";
    gleam = "gleam";
    glsl_analyzer = "glsl_analyzer";
    glslls = "glslls";
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
    ocamllsp = [
      "ocamlPackages"
      "ocaml-lsp"
    ];
    ols = "ols";
    openscad_lsp = "openscad-lsp";
    oxlint = "oxlint";
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
    protols = "protols";
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
    rescriptls = "rescript-language-server";
    # This is not entirely true, but the server is deprecated
    rls = "rustup";
    rubocop = "rubocop";
    ruby_lsp = "ruby-lsp";
    ruff_lsp = "ruff-lsp";
    ruff = "ruff";
    rune_languageserver = "rune-languageserver";
    rust_analyzer = "rust-analyzer";
    scheme_langserver = [
      "akkuPackages"
      "scheme-langserver"
    ];
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
    superhtml = "superhtml";
    svelte = "svelte-language-server";
    svls = "svls";
    swift_mesonls = "mesonlsp";
    syntax_tree = [
      "rubyPackages"
      "syntax_tree"
    ];
    systemd_ls = "systemd-language-server";
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
    thriftls = "thrift-ls";
    tilt_ls = "tilt";
    tinymist = "tinymist";
    ts_ls = "typescript-language-server";
    ts_query_ls = "ts_query_ls";
    ttags = "ttags";
    typeprof = "ruby";
    typos_lsp = "typos-lsp";
    uiua = "uiua";
    vacuum = "vacuum-go";
    vala_ls = "vala-language-server";
    vale_ls = "vale-ls";
    verible = "verible";
    veryl_ls = "veryl";
    vhdl_ls = "vhdl-ls";
    vimls = "vim-language-server";
    vls = "vlang";
    volar = "vue-language-server";
    vtsls = "vtsls";
    wgsl_analyzer = "wgsl-analyzer";
    yamlls = "yaml-language-server"; # Not available in coq 9.0: https://github.com/NixOS/nixpkgs/pull/389454
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
