{lib, ...}:
with lib; let
  misc = {
    listToUnkeyedAttrs = list:
      builtins.listToAttrs
      (lib.lists.imap0 (idx: lib.nameValuePair "__unkeyed-${toString idx}") list);

    emptyTable = {"__empty" = null;};

    mkIfNonNull' = x: y: (mkIf (x != null) y);

    mkIfNonNull = x: (mkIfNonNull' x x);

    ifNonNull' = x: y:
      if (x == null)
      then null
      else y;

    mkRaw = r:
      if (isString r && (r != ""))
      then {__raw = r;}
      else null;

    wrapDo = string: ''
      do
        ${string}
      end
    '';
  };

  nixvimTypes = import ./types.nix {inherit lib nixvimOptions;};
  nixvimOptions = import ./options.nix {
    inherit lib;
    inherit
      (misc)
      mkIf
      mkIfNonNull
      mkRaw
      ;
    inherit nixvimTypes;
  };
in
  {
    maintainers = import ./maintainers.nix;
    keymaps = import ./keymap-helpers.nix {inherit lib;};
    autocmd = import ./autocmd-helpers.nix {inherit lib;};
    vim-plugin = import ./vim-plugin.nix {inherit lib nixvimOptions;};
    inherit (import ./to-lua.nix {inherit lib;}) toLuaObject;
    inherit nixvimTypes;
  }
  // misc
  // nixvimOptions
