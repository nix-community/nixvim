{
  lib,
  stdenv,
  pkgsForTest,
  linkFarmFromDrvs,
}:
let
  inherit (stdenv) hostPlatform;

  # Enable unfree packages
  nixvimConfig = lib.nixvim.modules.evalNixvim {
    extraSpecialArgs.pkgs = pkgsForTest;
  };

  disabledPackages = [
    # 2026-07-12: build failure: cpplint_unittest.py:7209: AssertionError
    "cpplint"

    # 2026-07-12 transitive broken dependency: py-evm-0.12.1-beta.1 not supported for interpreter python3.14
    "slither-analyzer"

    # 2026-07-02 insecure dependency (pnpm-9.15.9)
    "stylelint-lsp"
    "vue-language-server"

    # 2026-02-02 build failure
    "crystalline"

    # 2026-01-22 build failure
    "shopify"

    # 2026-01-22 build failure
    "dmd"

    # 2025-12-24: phpPackages.php-codesniffer is broken
    # https://github.com/NixOS/nixpkgs/pull/459254#issuecomment-3689578764
    "php-codesniffer"

    # 2025-11-15 dependency swift is broken
    # https://github.com/NixOS/nixpkgs/issues/461474
    "sourcekit-lsp"
    "swift-format"

    # 2025-10-12 dependency mbedtls is marked as insecure
    "haxe"

    # 2026-02-05: build failure
    "skim"
  ]
  ++ lib.optionals (hostPlatform.isLinux && hostPlatform.isx86_64) [
    # 2026-07-12 dependency python3.frictionless has a build failure
    "vectorcode"
    "vectorcode.nvim"

    # TODO: 2026-07-12 dependency swift is broken
    "swiftformat"
    "swift-format"
  ]
  ++ lib.optionals hostPlatform.isLinux [
    # 2026-07-12 dependency z3 has a build failure
    "fstar"
  ]
  ++ lib.optionals (hostPlatform.isLinux && hostPlatform.isAarch64) [
    # 2026-06-15: semgrep fails its installCheckPhase
    "semgrep"

    # "tabnine"
    "cmp-tabnine"

    # 2026-05-20: vectorcode is marked badPlatforms on aarch64-linux
    "vectorcode.nvim"

    # luajitPackages.neotest is flaky: (temporarily?) disable tests that depend on it
    "compiler.nvim"
    "hardhat.nvim"
    "neotest-bash"
    "neotest-ctest"
    "neotest-dart"
    "neotest-deno"
    "neotest-dotnet"
    "neotest-elixir"
    "neotest-foundry"
    "neotest-go"
    "neotest-golang"
    "neotest-gradle"
    "neotest-gtest"
    "neotest-haskell"
    "neotest-java"
    "neotest-jest"
    "neotest-minitest"
    "neotest-pest"
    "neotest-phpunit"
    "neotest-playwright"
    "neotest-plenary"
    "neotest-python"
    "neotest-rspec"
    "neotest-rust"
    "neotest-scala"
    "neotest-testthat"
    "neotest-vitest"
    "neotest-zig"
    "nvim-coverage"
    "overseer.nvim"
    "rustaceanvim"
  ]
  ++ lib.optionals hostPlatform.isDarwin [
    # 2026-07-12 transitive build failure: qtspeech
    "sioyek"

    # 2026-05-28: build failure (compiler-rt-libc)
    "ols"

    # 2026-05-04: build failure (appstream)
    "blueprint-compiler"
    "openscad.nvim"
    "zathura-with-plugins"

    # 2026-05-01: ghc is not cached on CNO and is too heavy to build for the nix-community builders
    "elm-format"

    # 2026-04-28: d2 depends on mesa-libgbm -> libdrm, which fails on Darwin
    "d2"
    "wl-clipboard" # wayland

    # 2026-04-28: bundled tree-sitter grammar build failure on Darwin
    "kulala.nvim"

    # 2026-04-28: long Darwin build timing out in all-package-defaults
    "deno"
    "ghc"

    # 2026-04-09: OCaml toolchain build failure on Darwin
    "flow"
    "fstar"

    # 2026-04-09: build failure
    "fortitude"

    # 2026-02-05: build failure
    "marksman"

    # 2026-02-04 dependency llvmPackages_22.llvm is broken
    "ameba"
    "crystal"

    # 2026-01-23: build failure on aarch64-darwin
    "github-copilot-cli"

    # 2025-11-26 build failure
    "nvim-spectre"

    # 2025-11-16 dependencies pyarrow and kvazaar are broken
    "aider.nvim"

    # 2025-11-16 dependency pyarrow is broken
    "vectorcode"
    "vectorcode.nvim"

    # 2026-06-16: veridian depends on sv-lang-9.1 which is broken on Darwin
    "veridian"

    # 2025-11-16 fish is broken
    "direnv"
    "direnv.vim"
    "fish"
    "fish-lsp"

    # 2025-10-24 dependency wayland is not available on darwin
    "qtdeclarative"

    # 2025-10-20 dependency rubyPackages.nokogiri build failure
    # gumbo.c:32:10: fatal error: 'nokogiri_gumbo.h' file not found
    "actionlint"
    "ruby3.3-solargraph"

    # 2025-10-27: dependency cargo-nextest build failure
    # https://github.com/NixOS/nixpkgs/pull/455250#issuecomment-3451295118
    "air-formatter"

    # 2025-10-20: build failure
    # error: 'to_chars' is unavailable: introduced in macOS 13.3 unknown
    "mesonlsp"

    # 2025-10-20: dependency mlton build failure
    "smlfmt"

    # 2025-10-03: Transient dependency `kicad-base` is marked broken
    # https://github.com/NixOS/nixpkgs/pull/403987
    "atopile"

    # 2025-09-27 build failure
    "open-policy-agent"

    # 2025-09-16: zig/zig-hook fails on aarch64-darwin
    "zf"

    # 2025-09-08 build failure
    "mint"

    # 2025-09-08: build failure
    # https://github.com/NixOS/nixpkgs/pull/441058
    "verible"

    # 2025-07-25: zig-zlint is failing on aarch64-darwin
    "zig-zlint"

    # xdotool is not available on darwin
    "fontpreview"

    # Marked as broken
    "akku-scheme-langserver"
    "rubyfmt"
  ];

  isEnabled = p: !(builtins.elem (lib.getName p) disabledPackages);
  isAvailable = lib.meta.availableOn hostPlatform;

  # Collects all visible options, including sub options
  collectAllOptions =
    options:
    lib.concatMap (
      opt:
      let
        visible = opt.visible or true;
        optVisible = if lib.isBool visible then visible else visible == "shallow";
        subOptionsVisible = if lib.isBool visible then visible else visible == "transparent";
        subOptionSet = opt.type.getSubOptions opt.loc;
        subOptions = lib.optionals (subOptionSet != { }) (collectAllOptions subOptionSet);
      in
      lib.optional optVisible opt ++ lib.optionals subOptionsVisible subOptions
    ) (lib.collect lib.isOption options);

in
# Collect all derivation-type option defaults in Nixvim
lib.pipe nixvimConfig.options [
  collectAllOptions

  (lib.catAttrs "default")

  # Some options throw when not defined
  (builtins.filter (p: (builtins.tryEval p).success))

  (builtins.filter lib.isDerivation)

  (builtins.filter isEnabled)
  (builtins.filter isAvailable)

  (linkFarmFromDrvs "all-package-defaults")
]
