# Regression test to ensure `config.lib` can be used to define nixvim modules.
# This causes infinite recursion if any of `config.lib`'s own definitions depend on `program.nixvim`'s result.
{ config, ... }:
{
  lib.test.nixvimModule = { };
  programs.nixvim = config.lib.test.nixvimModule;
}
