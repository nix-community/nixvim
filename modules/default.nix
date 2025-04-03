# This module includes the nixvim modules that should always be evaluated.
#
# You may want to use the `/modules/top-level` module instead, unless you're
# using this in a submodule nested within another nixvim config.
{
  imports = [
    ./misc
    ./autocmd.nix
    ./clipboard.nix
    ./colorscheme.nix
    ./commands.nix
    ./diagnostics.nix
    ./doc.nix
    ./editorconfig.nix
    ./files.nix
    ./filetype.nix
    ./highlights.nix
    ./keymaps.nix
    ./lazyload.nix
    ./lua-loader.nix
    ./opts.nix
    ./output.nix
    ./performance.nix
    ./plugins.nix
    ./spellfiles.nix
  ];
}
