{ lib, ... }:

with lib;
with types;

let
  optionsFormat = submodule ({ ... }: {
    options = {
      action = mkOption {
        type = nonEmptyStr;
        description = "The function the mapping should call";
        example = ''"cmp.mapping.scroll_docs(-4)"'';
      };
      modes = mkOption {
        default = null;
        type = nullOr (listOf (enum [ "i" "c" "s"]));
        example = ''[ "i" "s" ]'';
      };
    };
  });

in mkOption {
  type = nullOr (attrsOf (either str optionsFormat));
  default = null;
  example = ''
    {
      "<CR>" = "cmp.mapping.confirm({ select = true })";
      "<Tab>" = {
        modes = [ "i" "s" ];
        action = '${""}'
          function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expandable() then
              luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif check_backspace() then
              fallback()
            else
              fallback()
            end
          end
        '${""}';
      };
    }
  '';
}
