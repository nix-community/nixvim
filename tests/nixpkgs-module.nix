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

  # Only imports the bare minimum modules, to ensure we are not accidentally evaluating `pkgs.*`
  evalModule =
    name: module:
    lib.evalModules {
      modules = lib.toList module ++ [
        {
          _module.check = false;
          flake = self;
          test = {
            inherit name;
            buildNixvim = false;
            runNvim = false;
            runCommand = runCommandLocal;
          };
        }
        ../modules/misc
        ../modules/top-level/test.nix
        ../modules/top-level/nixpkgs.nix
      ];
    };

  testModule = name: module: (evalModule name module).config.build.test;

in
linkFarmFromDrvs "nixpkgs-module-test" [

  # Test that pkgs-config is affected by `nixpkgs.config`
  (testModule "nixpkgs-config" (
    { pkgs, ... }:
    {
      nixpkgs.config = {
        permittedInsecurePackages = [
          "foobar123"
        ];
      };

      nixpkgs.hostPlatform = {
        inherit (stdenv.hostPlatform) system;
      };

      assertions = [
        {
          assertion = pkgs.config.permittedInsecurePackages == [ "foobar123" ];
          message = ''
            Expected `pkgs.config.permittedInsecurePackages` to match [ "foobar123" ], but found:
            ${lib.generators.toPretty { } pkgs.config.permittedInsecurePackages}'';
        }
      ];
    }
  ))

  # Test that a nixpkgs revision can be specified using `nixpkgs.source`
  (testModule "nixpkgs-source" (
    { pkgs, ... }:
    {
      nixpkgs.source = ./nixpkgs-mock.nix;

      nixpkgs.hostPlatform = {
        inherit (stdenv.hostPlatform) system;
      };

      assertions = [
        {
          assertion = pkgs.mock or false;
          message = "Expected `pkgs.mock` to be true, but ${
            if pkgs ? mock then "found " + lib.generators.toPretty { } pkgs.mock else "isn't present"
          }";
        }
      ];
    }
  ))

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
