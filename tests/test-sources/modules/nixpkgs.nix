{
  # TODO: expect not setting `nixpkgs.pkgs` to throw

  overlays =
    { pkgs, ... }:
    {
      test.runNvim = false;

      nixpkgs.overlays = [
        (final: prev: {
          foobar = "foobar";
        })
      ];

      assertions = [
        {
          assertion = pkgs.foobar or null == "foobar";
          message = ''
            Expected `pkgs.foobar` to be "foobar"
          '';
        }
      ];
    };

  # Test that overlays from both `nixpkgs.pkgs` _and_ `nixpkgs.overlays` are applied
  stacked_overlays =
    {
      inputs,
      system,
      pkgs,
      lib,
      ...
    }:
    {
      test.runNvim = false;

      nixpkgs.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            foobar = "foobar";
            conflict = "a";
          })
        ];
      };

      nixpkgs.config = lib.mkForce { };

      nixpkgs.overlays = [
        (final: prev: {
          hello = "world";
          conflict = "b";
        })
      ];

      assertions = [
        {
          assertion = pkgs.foobar or null == "foobar";
          message = ''
            Expected `pkgs.foobar` to be "foobar"
          '';
        }
        {
          assertion = pkgs.hello or null == "world";
          message = ''
            Expected `pkgs.hello` to be "world"
          '';
        }
        {
          assertion = pkgs.conflict or null == "b";
          message = ''
            Expected `pkgs.conflict` to be "b"
          '';
        }
      ];
    };

  # Test that a nixpkgs revision can be specified using `nixpkgs.source`
  source =
    { pkgs, ... }:
    {
      test.runNvim = false;

      nixpkgs.source = builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/1807c2b91223227ad5599d7067a61665c52d1295.tar.gz";
        sha256 = "0xnj86751780hg1zhx9rjkbjr0sx0wps4wxz7zryvrj6hgwrng1z";
      };

      assertions = [
        {
          assertion = pkgs.lib.version == "24.11pre-git";
          message = ''
            Expected `pkgs.lib.version` to be "24.11pre-git", but found "${pkgs.lib.version}"
          '';
        }
      ];
    };
}
