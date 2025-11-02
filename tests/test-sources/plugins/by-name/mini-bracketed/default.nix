{ lib, ... }:
{
  empty = {
    plugins.mini-bracketed.enable = true;
  };

  defaults = {
    plugins.mini-bracketed = {
      enable = true;
      settings = {
        buffer = {
          suffix = "b";
          options = lib.nixvim.emptyTable;
        };
        comment = {
          suffix = "c";
          options = lib.nixvim.emptyTable;
        };
        conflict = {
          suffix = "x";
          options = lib.nixvim.emptyTable;
        };
        diagnostic = {
          suffix = "d";
          options = lib.nixvim.emptyTable;
        };
        file = {
          suffix = "f";
          options = lib.nixvim.emptyTable;
        };
        indent = {
          suffix = "i";
          options = lib.nixvim.emptyTable;
        };
        jump = {
          suffix = "j";
          options = lib.nixvim.emptyTable;
        };
        location = {
          suffix = "l";
          options = lib.nixvim.emptyTable;
        };
        oldfile = {
          suffix = "o";
          options = lib.nixvim.emptyTable;
        };
        quickfix = {
          suffix = "q";
          options = lib.nixvim.emptyTable;
        };
        treesitter = {
          suffix = "t";
          options = lib.nixvim.emptyTable;
        };
        undo = {
          suffix = "u";
          options = lib.nixvim.emptyTable;
        };
        window = {
          suffix = "w";
          options = lib.nixvim.emptyTable;
        };
        yank = {
          suffix = "y";
          options = lib.nixvim.emptyTable;
        };
      };
    };
  };
}
