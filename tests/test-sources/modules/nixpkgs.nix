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
}
