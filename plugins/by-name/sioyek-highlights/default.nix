{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "sioyek-highlights";
  package = "nvim-sioyek-highlights";
  description = "Integrates Sioyek-like highlighting for docs and notes.";

  maintainers = [ lib.maintainers.khaneliman ];

  dependencies = [
    # Used by upstream's jump helper script.
    "python3"
    "sioyek"
    # Provides the `sqlite3` CLI used to query Sioyek's highlight database.
    "sqlite"
  ];

  # Upstream hard-requires Telescope for the SioyekHighlights picker.
  extraConfig = {
    plugins.telescope.enable = lib.mkDefault true;
  };

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
