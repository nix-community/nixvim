{
  system,
  nixpkgs,
  nuschtosSearch,
}:
let
  # We overlay a few tweaks into pkgs, for use in the docs
  pkgs = import ./pkgs.nix { inherit system nixpkgs; };
  inherit (pkgs) lib;
  helpers = import ../lib { inherit lib; };

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

  evaledModules = helpers.modules.evalNixvim {
    modules = [
      {
        isDocs = true;
        nixpkgs.pkgs = pkgs;
      }
    ];
  };

  hmOptions = builtins.removeAttrs (lib.evalModules {
    modules = [
      ../wrappers/modules/hm.nix
      { _module.check = false; } # Ignore missing option declarations
    ];
  }).options [ "_module" ];

  options-json =
    (pkgs.nixosOptionsDoc {
      inherit (evaledModules) options;
      inherit transformOptions;
      warningsAreErrors = false;
    }).optionsJSON;

in
{
  inherit options-json;
  inherit (pkgs) nixos-render-docs;

  gfm-alerts-to-admonitions = pkgs.python3.pkgs.callPackage ./gfm-alerts-to-admonitions { };

  man-docs = pkgs.callPackage ./man { inherit options-json; };
}
// lib.optionalAttrs (!pkgs.stdenv.isDarwin) (
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
    docs = pkgs.callPackage ./mdbook {
      inherit evaledModules hmOptions transformOptions;
      # TODO: Find how to handle stable when 24.11 lands
      search = mkSearch "/nixvim/search/";
    };
  }
)
