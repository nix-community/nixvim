{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
  mkExtension = import ./_mk-extension.nix;
in
mkExtension {
  name = "live-grep-args";
  extensionName = "live_grep_args";
  package = "telescope-live-grep-args-nvim";

  dependencies = [ "ripgrep" ];

  settingsOptions = {
    auto_quoting = defaultNullOpts.mkBool true ''
      Enable or disable auto quoting of searches.
    '';

    vimgrep_arguments = defaultNullOpts.mkListOf types.str null ''
      Arguments to pass to command.
    '';

    additional_args = defaultNullOpts.mkListOf types.str null ''
      Additional arguments to pass to command.
    '';

    search_dirs = defaultNullOpts.mkListOf types.str null ''
      Directory/directories/files to search.

      Paths are expanded and appended to the grep command.
    '';

    theme = defaultNullOpts.mkNullable (with types; either str (attrsOf anything)) null ''
      Theme for telescope window.

      Can be a string representing a theme name or a table with theme options.
    '';

    mappings = defaultNullOpts.mkAttrsOf types.anything null ''
      Extension specific mappings to various `live-grep-args` actions.
    '';
  };

  settingsExample = {
    auto_quoting = true;
    mappings = {
      i = {
        "<C-k>".__raw = ''require("telescope-live-grep-args.actions").quote_prompt()'';
        "<C-i>".__raw =
          ''require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " })'';
        "<C-space>".__raw = ''require("telescope.actions").to_fuzzy_refine'';
      };
    };
    theme = "dropdown";
  };
}
