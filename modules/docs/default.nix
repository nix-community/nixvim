{ lib, pkgs, ... }:
let
  # Replaces absolute links to the docs with relative links
  fixLinks = pkgs.callPackage ../../docs/fix-linkx {
    githubUrl = "https://github.com/nix-community/nixvim/blob/main/";
    baseurlUrl = "https://nix-community.github.io/nixvim/";
  };
in
{
  options.enableMan = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Install the man pages for NixVim options.";
  };

  imports = [
    ./_util.nix
    ./files.nix
    ./mdbook
    ./menu
    ./options.nix
    ./pages.nix
    ./platforms.nix
  ];

  config.docs = {
    pages."" = {
      menu.section = "header";
      menu.location = [ "Home" ];
      source = pkgs.callPackage ./readme.nix {
        inherit fixLinks;
        # TODO: get `availableVersions` and `baseHref` from module options
      };
    };
    pages.contributing = {
      menu.section = "footer";
      menu.location = [ "Contributing" ];
      source = fixLinks ../../CONTRIBUTING.md;
    };
    optionPages.docs = {
      optionScopes = [ "docs" ];
      page.menu.location = [ "docs" ];
      page.text = ''
        Internal options used to construct these docs.
      '';
    };
  };
}
