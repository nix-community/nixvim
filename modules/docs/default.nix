{ lib, ... }:
{
  options.enableMan = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Install the man pages for NixVim options.";
  };

  imports = [
    ./_util.nix
    ./all.nix
    ./files.nix
    ./mdbook
    ./menu
    ./options.nix
    ./platforms.nix
  ];

  config.docs.options = {
    docs = {
      menu.location = [ "docs" ];
      optionScopes = [ "docs" ];
      description = ''
        Internal options used to construct these docs.
      '';
    };
  };
}
