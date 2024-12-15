{
  lib,
  helpers,
  ...
}:
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "helm";
  packPathName = "vim-helm";
  package = "vim-helm";

  description = ''
    To ensure that `helm_ls` (and not `yamlls`) is used on helm files, add the following autocmd:

    ```nix
      autoCmd = [
        {
          event = "FileType";
          pattern = "helm";
          command = "LspRestart";
        }
      ];
    ```

    See [nix-community/nixvim#989](https://github.com/nix-community/nixvim/issues/989#issuecomment-2333728503)
    for details.
  '';

  maintainers = [ lib.maintainers.GaetanLepage ];
}
