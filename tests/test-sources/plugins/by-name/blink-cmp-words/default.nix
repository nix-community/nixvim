{
  empty = {
    plugins = {
      blink-cmp.enable = true;
      blink-cmp-words.enable = true;
    };
  };

  example = {
    plugins = {
      blink-cmp-words.enable = true;

      blink-cmp = {
        enable = true;

        settings = {
          sources = {
            default = [
              "lsp"
              "path"
              "lazydev"
              "dictionary"
              "thesaurus"
            ];
            providers = {
              thesaurus = {
                name = "blink-cmp-words";
                module = "blink-cmp-words.thesaurus";
                opts = {
                  score_offset = 0;
                  definition_pointers = [
                    "!"
                    "&"
                    "^"
                  ];
                  similarity_pointers = [
                    "&"
                    "^"
                  ];
                  similarity_depth = 2;
                };
              };
              dictionary = {
                name = "blink-cmp-words";
                module = "blink-cmp-words.dictionary";
                opts = {
                  dictionary_search_threshold = 3;
                  score_offset = 0;
                  definition_pointers = [
                    "!"
                    "&"
                    "^"
                  ];
                };
              };
            };
            per_filetype = {
              text = [ "dictionary" ];
              markdown = [ "thesaurus" ];
            };
          };
        };
      };
    };
  };
}
