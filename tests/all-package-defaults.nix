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
    # 2025-07-25 python313Packages.lsp-tree-sitter is marked as broken
    "autotools-language-server"

    # 2025-04-01 php-cs-fixer is marked as broken
    "php-cs-fixer"
  ]
  ++ lib.optionals (hostPlatform.isLinux && hostPlatform.isAarch64) [
    # "tabnine"
    "cmp-tabnine"
  ]
  ++ lib.optionals hostPlatform.isDarwin [
    # xdotool is not available on darwin
    "fontpreview"

    # Marked as broken
    "akku-scheme-langserver"
    "muon"
    "rubyfmt"
  ]
  ++ lib.optionals (hostPlatform.isDarwin && hostPlatform.isx86_64) [
    # As of 2024-07-31, dmd is broken on x86_64-darwin
    # https://github.com/NixOS/nixpkgs/pull/331373
    "dmd"

    # Marked as broken
    "mesonlsp"

    # No hash for system
    "verible"

    # 2025-06-24 build failure
    "gleam"

    # 2024-01-04 build failure
    "texlive-combined-medium"
    "texlive"

    # python3Packages.sentence-transformers hangs forever
    "vectorcode"
  ]
  ++ lib.optionals (hostPlatform.isDarwin && hostPlatform.isAarch64) [
    # As of 2025-07-25, zig-zlint is failing on aarch64-darwin
    "zig-zlint"
  ];

  isEnabled = p: !(builtins.elem (lib.getName p) disabledTests);
  isAvailable = lib.meta.availableOn hostPlatform;
in
/*
  Collect all derivation-type option defaults in the top-level option set.

  NOTE: This doesn't currently recurse into submodule option sets.
*/
lib.pipe nixvimConfig.options [
  (lib.collect lib.isOption)

  (lib.catAttrs "default")

  # Some options throw when not defined
  (builtins.filter (p: (builtins.tryEval p).success))

  (builtins.filter lib.isDerivation)

  (builtins.filter isEnabled)
  (builtins.filter isAvailable)

  (linkFarmFromDrvs "all-package-defaults")
]
