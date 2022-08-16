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
      name = "cssls";
      description = "Enable cssls, for CSS";
      packages = [ pkgs.nodePackages.vscode-langservers-extracted ];
    }
    {
      name = "eslint";
      description = "Enable eslint";
      packages = [ pkgs.nodePackages.vscode-langservers-extracted ];
    }
    {
      name = "gdscript";
      description = "Enable gdscript, for Godot";
      packages = [];
    }
    {
      name = "gopls";
      description = "Enable gopls, for Go.";
    }
    {
      name = "html";
      description = "Enable html, for HTML";
      packages = [ pkgs.nodePackages.vscode-langservers-extracted ];
    }
    {
      name = "jsonls";
      description = "Enable jsonls, for JSON";
      packages = [ pkgs.nodePackages.vscode-langservers-extracted ];
    }
    # {
    #   name = "ltex-ls";
    #   description = "Enable ltex-ls, for text files.";
    # }
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
      packages = [ pkgs.cargo ];
    }
    {
      name = "texlab";
      description = "Enable texlab, for latex.";
    }
    {
      name = "vuels";
      description = "Enable vuels, for Vue";
      packages = [ pkgs.nodePackages.vue-language-server ];
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
