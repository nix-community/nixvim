pkgs: modules: configuration:

let

  inherit (pkgs) lib;

  wrap = { wrapRc = true; };

  eval = lib.evalModules {
    modules = modules ++ [ { config = configuration; } wrap ];
  };

in eval.config.finalPackage
