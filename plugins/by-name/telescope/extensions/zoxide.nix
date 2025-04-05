let
  mkExtension = import ./_mk-extension.nix;
in
mkExtension {
  name = "zoxide";
  package = "telescope-zoxide";

  settingsExample = {
    prompt_title = "Zoxide Folder List";
    mappings = {
      "<C-b>" = {
        keepinsert = true;
        action.__raw = ''
          function(selection)
            file_browser.file_browser({ cwd = selection.path })
          end
        '';
      };
    };
  };
}
