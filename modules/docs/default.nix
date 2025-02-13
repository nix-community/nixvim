{ lib, pkgs, ... }:
let
  # Replaces absolute links to the docs with relative links
  # FIXME: use pandoc filters to do this with an AST
  fixLinks =
    name: src:
    pkgs.runCommand name
      {
        inherit src;
        github = "https://github.com/nix-community/nixvim/blob/main/";
        baseurl = "https://nix-community.github.io/nixvim/";
      }
      ''

        cp $src $out

        # replace relative links with links to github
        # TODO: it'd be nice to match relative links without a leading ./
        # but that is less trivial
        substituteInPlace $out --replace-quiet "./" "$github"

        # replace absolute links
        substituteInPlace $out --replace-quiet "$baseurl" "./"

        # TODO: replace .html with .md
      '';
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
      source =
        let
          src = pkgs.callPackage ./readme.nix {
            # TODO: get `availableVersions` and `baseHref` from module options
          };
        in
        fixLinks src.name src;
    };
    pages.contributing = {
      menu.section = "footer";
      menu.location = [ "Contributing" ];
      source = fixLinks "contributing" ../../CONTRIBUTING.md;
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
