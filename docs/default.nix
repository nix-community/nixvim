{
  pkgs ? import <nixpkgs> { config.enableUnfree = true; },
}:
let
  # Extend nixpkg's lib, so that we can handle recursive leaf types such as `either`
  lib = pkgs.lib.extend (
    final: prev:
    let
      prettyEval =
        value:
        builtins.tryEval (
          lib.generators.toPretty { } (
            lib.generators.withRecursion {
              depthLimit = 10;
              throwOnDepthLimit = false;
            } value
          )
        );
      show =
        value:
        let
          res = prettyEval value;
        in
        if res.success then res.value else "<FAILED>";
    in
    {
      types = prev.types // {
        either =
          t1: t2:
          (prev.types.either t1 t2)
          // {
            getSubOptions =
              prefix:
              let
                t1Ty = t1.getSubOptions prefix;
                t2Ty = t2.getSubOptions prefix;
                res = prev.trace ''
                  either.getsuboptions:
                  prefix = ${prev.showOption prefix}
                  t1.name = ${show t1.name}
                  t1.desc = ${show t1.description}
                  t1Ty = ${show t1Ty}
                  t2.name = ${show t2.name}
                  t2.desc = ${show t2.description}
                  t2Ty = ${show t2Ty}
                '' (t1Ty // t2Ty);
              in
              if t1.name == "rawLua" || t1.name == "rawLua" then res else (t1Ty // t2Ty);
          };

        eitherRecursive =
          t1: t2:
          let
            left = final.types.either t1 t2;
            right.getSubOptions =
              prefix:
              prev.trace ''
                eitherRecursive.getSubOptions
                prefix = ${prev.showOption prefix}
                (no-op)
              '' { };
          in
          left // right;

        oneOfRecursive =
          ts':
          let
            ts = prev.trace ''
              oneOfRecursive:
              ts = ${show ts}
            '' ts';

            head' =
              if ts == [ ] then
                throw "types.oneOfRecursive needs to get at least one type in its argument"
              else
                builtins.head ts;
            tail' = builtins.tail ts;
          in
          builtins.foldl' final.types.eitherRecursive head' tail';
      };
    }
  );

  pkgsDoc = pkgs // {
    inherit lib;
  };

  helpers = import ../lib/helpers.nix {
    inherit lib;
    pkgs = pkgsDoc;
  };

  nixvimPath = toString ./..;

  gitHubDeclaration = user: repo: branch: subpath: {
    url = "https://github.com/${user}/${repo}/blob/${branch}/${subpath}";
    name = "<${repo}/${subpath}>";
  };

  transformOptions =
    opt:
    opt
    // {
      declarations = map (
        decl:
        if lib.hasPrefix nixvimPath (toString decl) then
          gitHubDeclaration "nix-community" "nixvim" "main" (
            lib.removePrefix "/" (lib.removePrefix nixvimPath (toString decl))
          )
        else if decl == "lib/modules.nix" then
          gitHubDeclaration "NixOS" "nixpkgs" "master" decl
        else
          decl
      ) opt.declarations;
    };

  modules = [
    ../modules/top-level
    { isDocs = true; }
  ];

  hmOptions = builtins.removeAttrs (lib.evalModules {
    modules = [ (import ../wrappers/modules/hm.nix { inherit lib; }) ];
  }).options [ "_module" ];
in
rec {
  options-json =
    (pkgsDoc.nixosOptionsDoc {
      inherit
        (lib.evalModules {
          inherit modules;
          specialArgs = {
            inherit helpers;
            defaultPkgs = pkgsDoc;
          };
        })
        options
        ;
      inherit transformOptions;
      warningsAreErrors = false;
    }).optionsJSON;
  man-docs = pkgsDoc.callPackage ./man { inherit options-json; };
}
# Do not check if documentation builds fine on darwin as it fails:
# > sandbox-exec: pattern serialization length 69298 exceeds maximum (65535)
// lib.optionalAttrs (!pkgsDoc.stdenv.isDarwin) {
  docs = pkgsDoc.callPackage ./mdbook {
    inherit
      helpers
      modules
      hmOptions
      transformOptions
      ;
  };
}
