default_pkgs: modules: {pkgs ? default_pkgs, configuration}:

let

  inherit (pkgs) lib;

  wrap = { wrapRc = true; };

  eval = lib.evalModules {
    modules = (modules pkgs) ++ [ { config = configuration; } wrap ];
  };

in eval.config.finalPackage
