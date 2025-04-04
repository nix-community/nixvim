{ lib, pkgs, ... }:
let
  # Convert links relative to github -> relative to docs
  fixLinks = pkgs.callPackage ../../docs/fix-links { };
in
{
  options.enableMan = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Install the man pages for NixVim options.";
  };

  imports = [
    ./_utils.nix
    ./mdbook
    ./menu
    ./option-pages
    ./pages.nix
    ./platforms.nix
    ./user-guide
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
