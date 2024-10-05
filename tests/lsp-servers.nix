{ pkgs, ... }:
{ lib, options, ... }:
pkgs.lib.optionalAttrs
  # This fails on darwin
  # See https://github.com/NixOS/nix/issues/4119
  (!pkgs.stdenv.isDarwin)
  {
    plugins.lsp = {
      enable = true;

      servers =
        let
          disabled =
            (lib.optionals pkgs.stdenv.isDarwin [
              "fsautocomplete"
            ])
            ++ (lib.optionals pkgs.stdenv.isAarch64 [
              # Broken
              "scheme_langserver"
            ])
            ++ (lib.optionals (pkgs.stdenv.hostPlatform.system == "aarch64-linux") [
              # Binary package not available for this architecture
              "starpls"
              # TODO: 2024-10-05 build failure
              "fstar"
            ])
            ++ (lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-darwin") [
              # Binary package not available for this architecture
              "starpls"
            ]);

          renamed = lib.attrNames (import ../plugins/lsp/language-servers/_renamed.nix);
        in
        lib.mkMerge [
          (lib.pipe options.plugins.lsp.servers [
            (lib.mapAttrs (
              server: opts:
              {
                enable = !(lib.elem server disabled);
              }
              // lib.optionalAttrs (opts ? package && !(opts.package ? default)) { package = null; }
            ))
            (lib.filterAttrs (server: _: !(lib.elem server renamed)))
          ])
          {
            rust_analyzer = {
              installCargo = true;
              installRustc = true;
            };
          }
        ];
    };
  }
