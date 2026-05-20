{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "sioyek-highlights";
  package = "nvim-sioyek-highlights";
  description = "Integrates Sioyek-like highlighting for docs and notes.";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    db_path = "/srv/notes/sioyek.db";
    format_function = lib.nixvim.nestedLiteralLua ''
      function(text)
        return vim.tbl_map(function(line)
          return "> " .. line
        end, vim.split(text, "\n", { plain = true }))
      end
    '';
  };
}
