{ pkgs, config, lib, ... }@args:
let
  helpers = import ./helpers.nix args;
  servers = [
    {
      name = "clangd";
      description = "Enable clangd LSP, for C/C++.";
      packages = [ pkgs.clang-tools ];
    }
    {
      name = "gopls";
      description = "Enable gopls, for Go.";
    }
    {
      name = "pyright";
      description = "Enable pyright, for Python.";
    }
    {
      name = "rnix-lsp";
      description = "Enable rnix LSP, for Nix";
      serverName = "rnix";
    }
    {
      name = "rust-analyzer";
      description = "Enable rust-analyzer, for Rust.";
      serverName = "rust_analyzer";
    }
    {
      name = "zls";
      description = "Enable zls, for Zig.";
    }
  ];
in
{
  imports = lib.lists.map (helpers.mkLsp) servers;
}
