/*
  Byte compiling of normalized plugin list

  Inputs: List of normalized plugins
  Outputs: List of normalized (compiled) plugins
*/
{ lib, pkgs }:
let
  builders = lib.nixvim.builders.withPkgs pkgs;

  byteCompile =
    p:
    (builders.byteCompileLuaDrv p).overrideAttrs (
      prev: lib.optionalAttrs (prev ? dependencies) { dependencies = map byteCompile prev.dependencies; }
    );
in
map (p: p // { plugin = byteCompile p.plugin; })
