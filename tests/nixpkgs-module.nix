{
  pkgs,
  lib,
  linkFarmFromDrvs,
  self,
  stdenv,
  runCommandLocal,
}:
let

  defaultPkgs = pkgs;

  evalModule =
    name: module:
    lib.nixvim.modules.evalNixvim {
      modules = lib.toList module ++ [
        {
          test = {
            inherit name;
            buildNixvim = false;
            runNvim = false;
            runCommand = runCommandLocal;
          };
        }
      ];
    };

  testModule = name: module: (evalModule name module).config.build.test;

in
linkFarmFromDrvs "nixpkgs-module-test" [

  # TODO: expect not setting `nixpkgs.pkgs` to throw

  (testModule "nixpkgs-overlays" (
    { pkgs, ... }:
    {
      nixpkgs.pkgs = defaultPkgs;

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
    }
  ))

  # Test that overlays from both `nixpkgs.pkgs` _and_ `nixpkgs.overlays` are applied
  (testModule "nixpkgs-stacked-overlay" (
    { pkgs, ... }:
    {
      nixpkgs.pkgs = import self.inputs.nixpkgs {
        inherit (stdenv.hostPlatform) system;
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
    }
  ))

]
