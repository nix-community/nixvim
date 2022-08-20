{ lib, ... }:

with lib;

mkOption {
  default = null;
  type = types.nullOr (types.submodule ({ ... }: {
    options = {
      keyword_length = mkOption {
        default = null;
        type = types.nullOr types.int;
      };

      keyword_pattern = mkOption {
        default = null;
        type = types.nullOr types.str;
      };

      autocomplete = mkOption {
        default = null;
        type = types.nullOr types.str;
        description = "Lua code for the event.";
        example = ''"false"'';
      };

      completeopt = mkOption {
        default = null;
        type = types.nullOr types.str;
      };
    };
  }));
}
