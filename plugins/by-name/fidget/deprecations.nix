{ lib, ... }:
let
  inherit (lib) mkRemovedOptionModule;
in
{
  imports =
    map
      (
        oldOption:
        mkRemovedOptionModule
          [
            "plugins"
            "fidget"
            oldOption
          ]
          ''
            Nixvim: The fidget.nvim plugin has been completely rewritten. Hence, the options have changed.
            Please, take a look at the updated documentation and adapt your configuration accordingly.

            > https://github.com/j-hui/fidget.nvim
          ''
      )
      [
        "text"
        "align"
        "timer"
        "window"
        "fmt"
        "sources"
        "debug"
      ];
}
