{
  system ? builtins.currentSystem,
  pkgs ? import <nixpkgs> { inherit system; },
  lib ? import <nixpkgs/lib>,
  channelsJSON ? throw "Neither `channels` or `channelsJSON` provided",
  channels ? builtins.fromJSON channelsJSON,
}:
let
  # Pick out supported stable channels
  supported = [
    "beta"
    "stable"
    "deprecated"
  ];

  stable_versions =
    channels.channels
    |> builtins.mapAttrs (channel: entry: entry // { inherit channel; })
    |> builtins.attrValues
    |> builtins.filter (entry: entry.variant or null == "primary")
    |> builtins.filter (entry: builtins.elem entry.status supported)
    |> builtins.map (entry: {
      name = entry.channel |> builtins.match "nixos-(.+)" |> builtins.head;
      value = {
        inherit (entry) channel status;
        # Currently, Nixvim stable branches match NixOS channel names
        branch = entry.channel;
      };
    })
    |> builtins.listToAttrs;

  newest_stable =
    stable_versions |> builtins.attrNames |> builtins.sort (a: b: a > b) |> builtins.head;

  bumpYear = y: toString (lib.toIntBase10 y + 1);
  bumpMonth =
    m:
    assert m == "05" || m == "11";
    if m == "05" then "11" else "05";

  unstable =
    newest_stable
    |> builtins.match "(.+)[.](.+)"
    |> (v: {
      y = builtins.elemAt v 0;
      m = builtins.elemAt v 1;
    })
    |> (v: {
      y = if v.m == "11" then bumpYear v.y else v.y;
      m = bumpMonth v.m;
    })
    |> (v: "${v.y}.${v.m}");
in
pkgs.writers.writeTOML "channels.toml" {
  versions = stable_versions // {
    ${unstable} = {
      branch = "main";
      channel = "nixpkgs-unstable";
      status = "rolling";
    };
  };
}
