let
  mkExtension = import ./_mk-extension.nix;
in
mkExtension {
  name = "ast-grep";
  extensionName = "ast_grep";
  package = "telescope-ast-grep-nvim";
}
