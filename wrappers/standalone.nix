default_pkgs: modules: {
  pkgs ? default_pkgs,
  module,
}: let
  inherit (pkgs) lib;

  wrap = {wrapRc = true;};

  eval = lib.evalModules {
    modules = (modules pkgs) ++ [module wrap];
  };
in
  eval.config.finalPackage
