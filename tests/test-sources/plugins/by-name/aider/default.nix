{ pkgs }:
let
  # TODO: 2026-10-05 remove once https://github.com/NixOS/nixpkgs/pull/569679 hits flake.lock
  # These tests load the Lua plugin without invoking the broken aider-chat executable.
  package = pkgs.vimPlugins.aider-nvim.overrideAttrs { runtimeDeps = [ ]; };
in
{
  empty = {
    plugins.aider = {
      enable = true;
      inherit package;
    };
  };

  defaults = {
    plugins.aider = {
      enable = true;
      inherit package;
      settings = {
        auto_manage_context = true;
        default_bindings = true;
        debug = false;
        ignore_buffers = [
          "^term://"
          "NeogitConsole"
          "NvimTree_"
          "neo-tree filesystem"
        ];
      };
    };
  };

  example = {
    plugins.aider = {
      enable = true;
      inherit package;

      settings = {
        auto_manage_context = false;
        default_bindings = false;
        debug = true;
        vim = true;
        ignore_buffers.__empty = { };
        border = {
          style = [
            "╭"
            "─"
            "╮"
            "│"
            "╯"
            "─"
            "╰"
            "│"
          ];
          color = "#fab387";
        };
      };
    };
  };
}
