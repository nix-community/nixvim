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

  disabledTests = [
    # TODO 2025-10-24
    # build failure (fixed in https://github.com/NixOS/nixpkgs/pull/455238)
    "yamlfix"

    # TODO: 2025-10-03
    # Transient dependency `vmr` has a build failure
    # https://github.com/NixOS/nixpkgs/issues/431811
    "roslyn-ls"

    # 2025-07-25 python313Packages.lsp-tree-sitter is marked as broken
    "autotools-language-server"

    # 2025-04-01 php-cs-fixer is marked as broken
    "php-cs-fixer"

    # 2025-10-12 build failure (luaformatter depends on broken antlr-runtime-cpp)
    "luaformatter"

    # 2025-10-12 dependency mbedtls is marked as insecure
    "haxe"
  ]
  ++ lib.optionals (hostPlatform.isLinux && hostPlatform.isAarch64) [
    # "tabnine"
    "cmp-tabnine"

    # luajitPackages.neotest is flaky: (temporarily?) disable tests that depend on it
    "compiler.nvim"
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
    # 2025-10-20 dependency rubyPackages.nokogiri build failure
    # gumbo.c:32:10: fatal error: 'nokogiri_gumbo.h' file not found
    "actionlint"
    "ruby3.3-solargraph"

    # Transient dependency `kicad-base` is marked broken
    # https://github.com/NixOS/nixpkgs/pull/403987
    "atopile"

    # xdotool is not available on darwin
    "fontpreview"

    # 2025-09-27 build failure
    "open-policy-agent"

    # 2025-09-26 build failure
    "verilator"

    # 2025-09-08 build failure
    "mint"

    # Marked as broken
    "akku-scheme-langserver"
    "muon"
    "rubyfmt"
    "wl-clipboard" # wayland
  ]
  ++ lib.optionals (hostPlatform.isDarwin && hostPlatform.isx86_64) [
    # 2025-10-20 build failure
    # error: concurrency is only available in macOS 10.15.0 or newer
    "sourcekit-lsp"

    # As of 2024-07-31, dmd is broken on x86_64-darwin
    # https://github.com/NixOS/nixpkgs/pull/331373
    "dmd"

    # 2025-10-02 zig-hook is marked as broken
    "superhtml"

    # 2025-09-16 marked as broken
    # https://github.com/NixOS/nixpkgs/pull/440273/commits/e71ade9ba7c5feca1160acb68c643812e14e67f3
    "fpc"

    # Marked as broken
    "mesonlsp"

    # No hash for system
    "verible"

    # 2025-06-24 build failure
    "gleam"

    # 2024-01-04 build failure
    "texlive-combined-medium"
    "texlive"

    # 2025-09-16 zig/zig-hook is marked as broken
    # https://github.com/NixOS/nixpkgs/commit/bc725b12b2595951a3f4b112d59716d30b41001a
    "zf"
    "zls"
  ]
  ++ lib.optionals (hostPlatform.isDarwin && hostPlatform.isAarch64) [
    # 2025-10-20: build failure
    # error: 'to_chars' is unavailable: introduced in macOS 13.3 unknown
    "mesonlsp"

    # 2025-10-20: dependency mlton build failure
    "smlfmt"

    # As of 2025-07-25, zig-zlint is failing on aarch64-darwin
    "zig-zlint"

    # 2025-09-08, build failure
    # https://github.com/NixOS/nixpkgs/pull/441058
    "verible"

    # 2025-09-08 ttfautohint hangs forever
    "texlive-combined-medium"
    "texlive"
  ];

  isEnabled = p: !(builtins.elem (lib.getName p) disabledTests);
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
