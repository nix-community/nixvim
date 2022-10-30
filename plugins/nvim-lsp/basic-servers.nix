{ pkgs, config, lib, ... }@args:
let
  helpers = import ./helpers.nix args;
  servers = [
    {
      name = "clangd";
      description = "Enable clangd LSP, for C/C++.";
      package = pkgs.clang-tools;
    }
    {
      name = "cssls";
      description = "Enable cssls, for CSS";
      package = pkgs.nodePackages.vscode-langservers-extracted;
    }
    {
      name = "eslint";
      description = "Enable eslint";
      package = pkgs.nodePackages.vscode-langservers-extracted;
    }
    {
      name = "elixirls";
      description = "Enable elixirls";
      package = null;
      cmd = ["${pkgs.elixir_ls}/bin/elixir-ls"];
    }
    {
      name = "gdscript";
      description = "Enable gdscript, for Godot";
      package = null;
    }
    {
      name = "gopls";
      description = "Enable gopls, for Go.";
    }
    {
      name = "html";
      description = "Enable html, for HTML";
      package = pkgs.nodePackages.vscode-langservers-extracted;
    }
    {
      name = "jsonls";
      description = "Enable jsonls, for JSON";
      package = pkgs.nodePackages.vscode-langservers-extracted;
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
      name = "tsserver";
      description = "Enable tsserver for typescript";
      package = pkgs.nodePackages.typescript-language-server;
      extraPackages = {
        typescript = pkgs.nodePackages.typescript;
      };
    }
    {
      name = "vuels";
      description = "Enable vuels, for Vue";
      package = pkgs.nodePackages.vue-language-server;
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
