{
  empty = {
    plugins.cloak.enable = true;
  };

  defaults = {
    plugins.cloak = {
      enable = true;

      settings = {
        enabled = true;
        cloak_character = "*";
        highlight_group = "Comment";
        cloak_length = null;
        try_all_patterns = true;
        cloak_telescope = true;
        patterns = [
          {
            file_pattern = ".env*";
            cloak_pattern = "=.+";
            replace = null;
          }
        ];
      };
    };
  };

  example = {
    plugins.cloak = {
      enable = true;

      settings = {
        enabled = true;
        cloak_character = "*";
        highlight_group = "Comment";
        patterns = [
          {
            file_pattern = [
              ".env*"
              "wrangler.toml"
              ".dev.vars"
            ];
            cloak_pattern = "=.+";
          }
        ];
      };
    };
  };
}
