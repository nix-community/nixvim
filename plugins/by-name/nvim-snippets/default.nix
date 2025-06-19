{
  lib,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "nvim-snippets";
  moduleName = "snippets";
  description = "Allow vscode style snippets to be used with native neovim snippets `vim.snippet`.";

  maintainers = [ lib.maintainers.psfloyd ];

  settingsOptions = {
    create_autocmd = defaultNullOpts.mkBool false ''
      Optionally load all snippets when opening a file.
      Only needed if not using nvim-cmp.
    '';

    create_cmp_source = defaultNullOpts.mkBool true ''
      Optionally create a nvim-cmp source.
      Source name will be snippets.
    '';

    friendly_snippets = defaultNullOpts.mkBool false ''
      Set to true if using friendly-snippets.
    '';

    ignored_filetypes = defaultNullOpts.mkListOf types.str null ''
      Filetypes to ignore when loading snippets.
    '';

    extended_filetypes = defaultNullOpts.mkAttrsOf types.anything null ''
      Filetypes to load snippets for in addition to the default ones. ex: {typescript = {
      'javascript'}}'';

    global_snippets = defaultNullOpts.mkListOf types.str [ "all" ] ''
      Snippets to load for all filetypes.
    '';

    search_paths =
      defaultNullOpts.mkListOf types.str [ { __raw = "vim.fn.stdpath('config') .. '/snippets'"; } ]
        ''
          Paths to search for snippets.
        '';
  };

  settingsExample = {
    create_autocmd = true;
    create_cmp_source = true;
    friendly_snippets = true;
    ignored_filetypes = [ "lua" ];
    extended_filetypes = {
      typescript = [ "javascript" ];
    };
    global_snippets = [ "all" ];
    search_paths = [ { __raw = "vim.fn.stdpath('config') .. '/snippets'"; } ];
  };
}
