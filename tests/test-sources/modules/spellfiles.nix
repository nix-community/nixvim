{
  default = {
    spellfiles.enable = true;
  };

  custom-languages = {
    spellfiles = {
      enable = true;

      includeSuggestions = true;
      languages = [
        "en"
        "fr"
        "de"
      ];
    };
  };

  custom-encoding = {
    # Neovim cannot start with an encoding different from utf-8:
    # Error while calling lua chunk: vim/_options.lua:0: E519: Option not supported
    test.runNvim = false;

    opts.encoding = "iso-8859-2";
    spellfiles = {
      enable = true;
      languages = [
        "pl"
        "ro"
        "sk"
      ];
    };
  };

  lang-from-nvim-options = {
    spellfiles.enable = true;
    opts.spelllang = "en_us,fr,medical";

    imports = [
      (
        { config, lib, ... }:
        {
          assertions =
            let
              printList = l: ''[ "${lib.concatStringsSep ''", "'' l}" ]'';
              expected = [
                "en"
                "fr"
              ];
            in
            [
              {
                assertion = config.spellfiles.languages == expected;
                message = ''
                  `config.spellfiles.languages` is wrongly inferred from `opts.spellang`.
                  It is ${printList config.spellfiles.languages} instead of ${printList expected}.
                '';
              }
            ];
        }
      )
    ];
  };

  custom-spellfiles = {
    spellfiles = {
      enable = true;

      spellfiles = [
        "en.utf-8.spl"
        "sr@latin.utf-8.spl"
        "tn.iso-8859-2.spl"
        "sw.latin1.sug"
      ];
    };
  };

  both-languages-and-spellfiles = {
    spellfiles = {
      enable = true;

      languages = [
        "es"
        "de"
        "fr"
      ];

      spellfiles = [
        "en.utf-8.spl"
        "fr.utf-8.spl"
        "en.utf-8.sug"
      ];
    };
  };
}
