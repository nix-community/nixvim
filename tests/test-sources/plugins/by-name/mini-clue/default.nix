{ lib }:
{
  empty = {
    plugins.mini-clue.enable = true;
  };

  defaults = {
    plugins.mini-clue = {
      enable = true;
      settings = {
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
          (lib.nixvim.mkRaw "require(\"mini.clue\").gen_clues.builtin_completion()")
          (lib.nixvim.mkRaw "require(\"mini.clue\").gen_clues.g()")
          (lib.nixvim.mkRaw "require(\"mini.clue\").gen_clues.marks()")
          (lib.nixvim.mkRaw "require(\"mini.clue\").gen_clues.registers()")
          (lib.nixvim.mkRaw "require(\"mini.clue\").gen_clues.windows()")
          (lib.nixvim.mkRaw "require(\"mini.clue\").gen_clues.z()")
        ];
      };
    };
  };
}
