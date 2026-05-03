{
  lib,
  pkgs,
}:
let
  inherit (builtins)
    tryEval
    ;
  inherit (pkgs) stdenv;

  toPackage = loc: lib.getAttrFromPath (lib.toList loc) pkgs;

  states = {
    broken = "it is currently broken in nixpkgs";
    darwinOnly = p: if stdenv.hostPlatform.isDarwin then p else "it is only available on Darwin";
    linuxOnly = p: if stdenv.hostPlatform.isLinux then p else "it is only available on Linux";
    unpackaged = "it is not packaged in nixpkgs";
    unknown = "nixvim does not know which package provides it";
    userDefined = "it is a user-defined linter";
  };

  evalOr =
    fallback: value:
    let
      result = tryEval value;
    in
    if result.success then result.value else fallback;

  getTopLevelPackageByName = name: evalOr states.broken (pkgs.${name} or null);

  resolvePackageState = name: lib.defaultTo states.unpackaged (getTopLevelPackageByName name);

  resolvePackage =
    name: loc:
    let
      default = resolvePackageState name;
    in
    if loc == null then default else evalOr default (toPackage loc);

  resolvePackages = packaged: lib.mapAttrs resolvePackage packaged;

  resolveNames =
    names: builtins.listToAttrs (map (name: lib.nameValuePair name (resolvePackageState name)) names);

  efmlsPackages = import ../efmls-configs/packages.nix lib;
  noneLsPackages = import ../none-ls/packages.nix lib;
in
{
  inherit states;

  linter-packages =
    # These upstream package maps can contain stale "unpackaged" markers and broken aliases.
    # Resolve them against the current nixpkgs first so auto-install warns instead of exploding.
    resolveNames efmlsPackages.unpackaged
    // resolvePackages efmlsPackages.packaged
    // resolvePackages noneLsPackages.packaged
    // {
      biomejs = pkgs.biome;
      buf_lint = pkgs.buf;
      clazy = states.linuxOnly pkgs.clazy;
      clangtidy = pkgs."clang-tools";
      inherit (pkgs) clj-kondo;
      cmakelint = pkgs."cmake-format";
      dmypy = pkgs.mypy;
      inherit (pkgs.luaPackages) fennel;
      ghdl = states.linuxOnly pkgs.ghdl;
      golangcilint = pkgs."golangci-lint";
      json_tool = pkgs.python3;
      ls_lint = pkgs."ls-lint";
      mago_analyze = pkgs.mago;
      mago_lint = pkgs.mago;
      opa_check = pkgs."open-policy-agent";
      inherit (pkgs.phpPackages) phpinsights;
      inherit (pkgs) phpstan;
      pony = pkgs.ponyc;
      inherit (pkgs.python3Packages) pycodestyle;
      inherit (pkgs.python3Packages) pydocstyle;
      rstlint = pkgs.python3Packages."restructuredtext-lint";
      systemd-analyze = states.linuxOnly pkgs.systemd;
      tofu = pkgs.opentofu;
      vacuum = pkgs.vacuum-go;
    };
}
