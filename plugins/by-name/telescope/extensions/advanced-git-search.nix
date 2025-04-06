let
  mkExtension = import ./_mk-extension.nix;
in
mkExtension {
  name = "advanced-git-search";
  extensionName = "advanced_git_search";
  package = "advanced-git-search-nvim";

  settingsExample = {
    diff_plugin = "diffview";
    git_flags = [
      "-c"
      "delta.side-by-side=false"
    ];
  };
}
