{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-clue";
  moduleName = "mini.clue";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    triggers = [
      {
        mode = "n";
        keys = "g";
      }
      {
        mode = "x";
        keys = "g";
      }
      {
        mode = "n";
        keys = "'";
      }
      {
        mode = "n";
        keys = "`";
      }
      {
        mode = "x";
        keys = "'";
      }
      {
        mode = "x";
        keys = "`";
      }
      {
        mode = "n";
        keys = "\"";
      }
      {
        mode = "x";
        keys = "\"";
      }
      {
        mode = "n";
        keys = "z";
      }
      {
        mode = "x";
        keys = "z";
      }
    ];
    clues = [
      (lib.nixvim.nestedLiteralLua "require(\"mini.clue\").gen_clues.builtin_completion()")
      (lib.nixvim.nestedLiteralLua "require(\"mini.clue\").gen_clues.g()")
      (lib.nixvim.nestedLiteralLua "require(\"mini.clue\").gen_clues.marks()")
      (lib.nixvim.nestedLiteralLua "require(\"mini.clue\").gen_clues.registers()")
      (lib.nixvim.nestedLiteralLua "require(\"mini.clue\").gen_clues.windows()")
      (lib.nixvim.nestedLiteralLua "require(\"mini.clue\").gen_clues.z()")
    ];
  };
}
