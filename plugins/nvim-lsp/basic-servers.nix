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
      name = "denols";
      description = "Enable denols, for Deno";
      packages = [ pkgs.deno ];
    }
    {
      name = "eslint";
      description = "Enable eslint";
      packages = [ pkgs.nodePackages.vscode-langservers-extracted ];
    }
    {
      name = "elixirls";
      description = "Enable elixirls";
      packages = [ ];
      cmd = [ "${pkgs.elixir_ls}/bin/elixir-ls" ];
    }
    {
      name = "gdscript";
      description = "Enable gdscript, for Godot";
      packages = [ ];
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
      name = "tailwindcss";
      description = "Enable tailwindcss language server, for tailwindcss";
      packages = [ pkgs.nodePackages."@tailwindcss/language-server" ];
    }
    {
      name = "tsserver";
      description = "Enable tsserver for typescript";
      packages = with pkgs; [
        nodePackages.typescript
        nodePackages.typescript-language-server
      ];
    }
    {
      name = "vuels";
      description = "Enable vuels, for Vue";
      packages = [ pkgs.nodePackages.vls ];
    }
    {
      name = "zls";
      description = "Enable zls, for Zig.";
    }
    {
      name = "hls";
      description = "Enable haskell language server";
      packages = [ pkgs.haskell-language-server ];
      cmd = [ "haskell-language-server-wrapper" ];
    }
  ];
in
{
  imports = lib.lists.map (helpers.mkLsp) servers;
}
