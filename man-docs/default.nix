{
  pkgs,
  modules,
}: let
  nixvimPath = toString ./..;

  gitHubDeclaration = user: repo: subpath: {
    url = "https://github.com/${user}/${repo}/blob/master/${subpath}";
    name = "<${repo}/${subpath}>";
  };
in rec {
  nixvim-render-docs = pkgs.callPackage ./nixvim-render-docs {};

  man-docs = let
    eval = pkgs.lib.evalModules {
      inherit modules;
    };

    options = pkgs.nixosOptionsDoc {
      inherit (eval) options;
      warningsAreErrors = false;
      transformOptions = opt:
        opt
        // {
          declarations =
            map (
              decl:
                if pkgs.lib.hasPrefix nixvimPath (toString decl)
                then
                  gitHubDeclaration "nix-community" "nixvim"
                  (pkgs.lib.removePrefix "/" (pkgs.lib.removePrefix nixvimPath (toString decl)))
                else if decl == "lib/modules.nix"
                then gitHubDeclaration "NixOS" "nixpkgs" decl
                else decl
            )
            opt.declarations;
        };
    };
  in
    pkgs.runCommand "nixvim-configuration-reference-manpage" {
      nativeBuildInputs = with pkgs; [installShellFiles nixvim-render-docs];
    } ''
      # Generate man-pages
      mkdir -p $out/share/man/man5
      nixvim-render-docs -j $NIX_BUILD_CORES options manpage \
        --revision unstable \
        ${options.optionsJSON}/share/doc/nixos/options.json \
        $out/share/man/man5/nixvim.5
    '';
}
