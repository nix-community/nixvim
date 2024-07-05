{ getHelpers, pkgs }:
let
  # Extend nixpkg's lib, so that we can handle recursive leaf types such as `either`
  lib = pkgs.lib.extend (
    final: prev: {
      types = prev.types // {
        either =
          t1: t2:
          (prev.types.either t1 t2)
          // {
            getSubOptions = prefix: (t1.getSubOptions prefix) // (t2.getSubOptions prefix);
          };

        eitherRecursive = t1: t2: (final.types.either t1 t2) // { getSubOptions = _: { }; };

        oneOfRecursive =
          ts:
          let
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

  helpers = getHelpers pkgsDoc false;

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

  modules = [ ../modules/top-level ];

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
            isDocs = true;
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
