{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "blink-cmp-nixpkgs-maintainers";

  maintainers = [ lib.maintainers.GaetanLepage ];

  description = ''
    nixpkgs-maintainers source for blink-cmp.

    ---

    This plugin should be configured through blink-cmp's `sources.providers` settings.

    For example:

    ```nix
    plugins.blink-cmp = {
      enable = true;
      settings.sources = {
        per_filetype = {
          markdown = [ "nixpkgs_maintainers" ];
        };
        providers = {
          nixpkgs_maintainers = {
            module = "blink_cmp_nixpkgs_maintainers";
            name = "nixpkgs maintainers";
            opts = {
              # Number of days after which the list of maintainers is refreshed
              cache_lifetime = 14;
              # Do not print status messages
              silent = false;
              # Customize the `nixpkgs` source flake for fetching the maintainers list
              # Example: "github:NixOS/nixpkgs/master"
              nixpkgs_flake_uri = "nixpkgs";
            };
          };
        };
      };
    };
    ```
  '';

  # Configured through blink-cmp
  callSetup = false;
  hasLuaConfig = false;
  hasSettings = false;
}
