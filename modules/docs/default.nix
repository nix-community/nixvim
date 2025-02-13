{ lib, ... }:
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

  config.docs.optionPages = {
    docs = {
      optionScopes = [ "docs" ];
      page.menu.location = [ "docs" ];
      page.text = ''
        Internal options used to construct these docs.
      '';
    };
  };
}
