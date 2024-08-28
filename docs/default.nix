{
  pkgs ? import <nixpkgs> { config.allowUnfree = true; },
  nuschtosSearch,
}:
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

  evaledModules = lib.evalModules {
    inherit (helpers.modules) specialArgs;
    modules = [
      ../modules/top-level
      { isDocs = true; }
    ];
  };

  hmOptions = builtins.removeAttrs (lib.evalModules { modules = [ ../wrappers/modules/hm.nix ]; })
    .options [ "_module" ];

  options-json =
    (pkgsDoc.nixosOptionsDoc {
      inherit (evaledModules) options;
      inherit transformOptions;
      warningsAreErrors = false;
    }).optionsJSON;

in
{
  inherit options-json;

  man-docs = pkgsDoc.callPackage ./man { inherit options-json; };
}
// lib.optionalAttrs (!pkgsDoc.stdenv.isDarwin) (
  let
    mkSearch =
      baseHref:
      nuschtosSearch.packages.mkSearch {
        optionsJSON = options-json + "/share/doc/nixos/options.json";
        urlPrefix = "https://github.com/nix-community/nixvim/tree/main";
        inherit baseHref;
      };
  in
  {
    # NuschtOS/search does not seem to work on darwin
    search = mkSearch "/";

    # Do not check if documentation builds fine on darwin as it fails:
    # > sandbox-exec: pattern serialization length 69298 exceeds maximum (65535)
    docs = pkgsDoc.callPackage ./mdbook {
      inherit evaledModules hmOptions transformOptions;
      # TODO: Find how to handle stable when 24.11 lands
      search = mkSearch "/nixvim/search/";
    };
  }
)
