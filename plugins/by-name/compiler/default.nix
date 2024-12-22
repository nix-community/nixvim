{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "compiler";
  packPathName = "compiler.nvim";
  package = "compiler-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  description = ''
    > [!Note]
    > Some languages require you manually install their compilers in your machine, so `compiler.nvim` is able to call them.
    > Please check [here], as the packages will be different depending your operative system.

    [here]: https://github.com/Zeioth/Compiler.nvim/wiki/how-to-install-the-required-dependencies
  '';
}
