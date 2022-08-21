{ lib, config, pkgs, ... }:

with lib;
with types;
let

  helpers = import ../../../helpers.nix { inherit lib config; };
  sourceNameAndPlugin = (import ../cmp-helpers.nix { inherit lib config pkgs; }).sourceNameAndPlugin;

  toSourceModule = name: attrs:
    with helpers;
    let
      # cfg = config.programs.nixvim.plugins.nvim-cmp.sources.${name};
      package =
        if isString attrs then
          attrs
        else
          attrs.package;

    in mkOption {
      type = nullOr (submodule {
        options = {
          enable = mkEnableOption "";
          option = mkOption {
            type = nullOr (attrsOf anything);
            description = "If direct lua code is needed use helpers.mkRaw";
            default = null;
          };
          triggerCharacters = mkOption {
            type = nullOr (listOf str);
            default = null;
          };
          keywordLength = intNullOption "";
          keywordPattern = intNullOption "";
          priority = intNullOption "";
          maxItemCount = intNullOption "";
          groupIndex = intNullOption "";
        };
      });
      description = "Module for the ${name} (${package}) source for nvim-cmp";
      default = null;
    };
in mapAttrs (sourceName: value:
  let
    package =
      if isString value then
        value
      else
        value.package;
  in toSourceModule sourceName package) sourceNameAndPlugin
