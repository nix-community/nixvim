{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) types;

  spellfilesHashes = lib.importJSON ../generated/spellfiles.json;

  availableSpellfiles = lib.attrNames spellfilesHashes;

  # [ "foo<SEP>bar" "one<SEP>two<SEP>three" ] -> [ "foo" "one" ]
  mapExtractBeforeSep = sep: map (x: builtins.head (builtins.split sep x));

  availableLanguages = lib.pipe availableSpellfiles [
    (mapExtractBeforeSep "\\.")
    lib.unique
  ];

  cfg = config.spellfiles;
in
{
  options.spellfiles = {
    enable = lib.mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Whether to automatically fetch and install vim spellfiles (`.spl` and `.sug`).

        If enabled, Nixvim will automatically populate `spell/en.utf-8.spl`-type files by fetching
        them from [the official vim FTP server](https://ftp.nluug.nl/pub/vim/runtime/spell/).

        This module allows choosing which spellfiles to install.
      '';
    };

    languages = lib.mkOption {
      type = with types; either (enum [ "auto" ]) (listOf (enum availableLanguages));
      default = "auto";
      example = [
        "en"
        "fr"
      ];
      description = ''
        By default, spellfiles from the languages listed in `opts.spelllang` will be fetched (or
        `"en"` if `opts.spelllang` is not defined).

        Set to `[ ]` to disable this behavior.
      '';
      apply =
        value:
        let
          # If spelllang is not set, default to English
          spelllang = config.opts.spelllang or "en";

          /*
            Infers the list of language ids from `opts.spelllang`:

            Turns: "en_us,fr,de"
            into: [ "en" "fr" "de" ]
            # https://neovim.io/doc/user/spell.html#spell-load
          */
          languagesFromSpelllang = lib.pipe spelllang [
            # "en_us,fr,de" -> [ "en_us" "fr" "de" ]
            (lib.splitString ",")

            # Remove region from language id ("en_us" -> "en")
            # (map (lang: builtins.trace lang lib.head (builtins.match "^([^_]+)" lang)))
            (mapExtractBeforeSep "_")

            # Remove languages that do not have corresponding spellfiles (such as "medical")
            (builtins.filter (lang: builtins.elem lang availableLanguages))
          ];
        in
        if value == "auto" then languagesFromSpelllang else value;
    };

    includeSuggestions = lib.mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Whether to also fetch suggestion files (`.sug`) when available.

        Warning, using suggestion files can lead to higher memory usage.

        See https://neovim.io/doc/user/spell.html#spell-NOSUGFILE.
      '';
    };

    spellfiles = lib.mkOption {
      type = with types; listOf (enum availableSpellfiles);
      default = [ ];
      description = ''
        Explicitly specify spellfiles to install.

        Possible values correspond to the spellfiles available at https://ftp.nluug.nl/pub/vim/runtime/spell/.
      '';
      example = [
        "en.utf-8.spl"
        "en.utf-8.sug"
        "fr.utf-8.spl"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    extraFiles =
      let
        /*
          Infers the spellfiles names from a language identifier.

          The spellfiles associated with language `LL` are:
          - `LL.<ENCODING>.spl`: main spell file
          - `LL.<ENCODING>.sug` (optional): additional file for more precise suggestions

          `<ENCODING>` is inferred from `opts.encoding` (if set) and defaults to `utf-8`.
        */
        getFilenamesFromLanguage =
          lang:
          let
            # Default to utf-8 encoding
            encoding = config.opts.encoding or "utf-8";

            # Main spellfile (.spl)
            baseName = "${lang}.${encoding}";

            # Optional suggestion spellfile (.sug)
            sugFilename = "${baseName}.sug";
            includeSugSpellfile =
              # user has enabled fetching suggestion spellfiles
              cfg.includeSuggestions

              # a suggestion spellfile is available for this language-encoding pair
              && (lib.hasAttr sugFilename spellfilesHashes);
          in
          [
            "${baseName}.spl"
          ]
          ++ lib.optional includeSugSpellfile sugFilename;

        # [ "en.utf-8.spl" "en.utf-8.sug" "fr.utf-8.spl" ]
        spellfiles = lib.unique (
          # spellfiles from `cfg.languages`
          (lib.concatMap getFilenamesFromLanguage cfg.languages)

          # explicitly requested spellfiles
          ++ cfg.spellfiles
        );

        /*
          Maps "en.utf-8.spl" to:
          {
            name = "spell/en.utf-8.spl";

            value.source = pkgs.fetchurl {
              url = "https://ftp.nluug.nl/pub/vim/runtime/spell/en.utf-8.spl";
              hash = "sha256-/sq9yUm2o50ywImfolReqyXmPy7QozxK0VEUJjhNMHA=";
            };
          }
        */
        fetchSpellFile = filename: {
          # Destination path for this spellfile
          name = "spell/${filename}";

          value.source = pkgs.fetchurl (
            spellfilesHashes.${filename}
              or (throw "Spellfile `${filename}` is not available in https://ftp.nluug.nl/pub/vim/runtime/spell/")
          );
        };
      in
      /*
        {
          "spell/en.utf-8.spl".source = "/nix/store/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-en.utf-8.spl"
          "spell/en.utf-8.sug".source = "/nix/store/yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy-en.utf-8.sug"
          "spell/fr.utf-8.spl".source = "/nix/store/zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz-fr.utf-8.spl"
        }
      */
      lib.listToAttrs (map fetchSpellFile spellfiles);
  };
}
