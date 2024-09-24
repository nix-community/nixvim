{ lib, ... }:
# Based on https://github.com/NixOS/nixpkgs/blob/814a4e48/nixos/modules/misc/meta.nix
let
  maintainer = lib.mkOptionType {
    name = "maintainer";
    check = m: lib.elem m (lib.attrValues lib.maintainers);
    merge =
      loc: defs:
      let
        def = lib.last defs;
      in
      {
        ${def.file} = def.value;
      };
  };

  listOfMaintainers = lib.types.listOf maintainer // {
    # Returns attrset of
    #   { "module-file" = [
    #        "maintainer1 <first@nixos.org>"
    #        "maintainer2 <second@nixos.org>" ];
    #   }
    merge =
      loc: defs:
      lib.pipe defs [
        (lib.imap1 (
          n: def:
          lib.imap1 (
            m: value:
            maintainer.merge (loc ++ [ "[${toString n}-${toString m}]" ]) [
              {
                inherit (def) file;
                inherit value;
              }
            ]
          ) def.value
        ))
        lib.flatten
        lib.zipAttrs
      ];
  };
in
{
  options.meta = {
    maintainers = lib.mkOption {
      type = listOfMaintainers;
      internal = true;
      default = [ ];
      example = lib.literalExpression "[ lib.maintainers.all ]";
      description = ''
        List of maintainers of each module.  This option should be defined at
        most once per module.
      '';
    };
  };
}
