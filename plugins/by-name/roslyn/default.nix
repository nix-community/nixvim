{ lib, pkgs, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "roslyn";
  packPathName = "roslyn.nvim";
  package = "roslyn-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraConfig = {
    plugins.roslyn.settings.exe = lib.mkDefault "Microsoft.CodeAnalysis.LanguageServer";
  };

  # TODO: Figure out how to add this package, as it's the source of the `Microsoft.CodeAnalysis.LanguageServer` command, which is required for the LSP to function
  # home.packages = [ pkgs.roslyn-ls ];
}
