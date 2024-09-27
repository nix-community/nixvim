{ lib, helpers }:
with lib;
{
  enabled =
    helpers.defaultNullOpts.mkNullableWithRaw (with lib.types; either bool (listOf (maybeRaw str)))
      [
        "bibtex"
        "context"
        "context.tex"
        "html"
        "latex"
        "markdown"
        "org"
        "restructuredtext"
        "rsweave"
      ]
      ''
        Controls whether the extension is enabled.
        Allows disabling LanguageTool on specific workspaces or for specific code language modes
        (i.e., file types).

        Either supply a boolean value stating whether LTEX is enabled for all supported markup languages
        or disabled for all of them, or supply a list of code language identifiers for which LTEX should
        be enabled (note that extensions can define additional code language identifiers).

        All supported markup languages are listed in the default value of this setting.
        In addition, LTEX can check comments in many popular programming languages like C++ or Java, if
        you add the corresponding code language identifiers to this setting.
        If you add an unsupported code language mode, LTEX will check corresponding files as plain text
        without any parsing.

        The activation events are unaffected by this setting.
        This means that the extension will be activated whenever a file with a supported code language
        mode is opened.
        For unsupported code language modes, you may need to activate the extension explicitly by
        executing the LTeX: Activate Extension command.

        Examples:
        - true
        - false
        - ["latex" "markdown"]
      '';

  language = helpers.defaultNullOpts.mkStr "en-US" ''
    The language (e.g., "en-US") LanguageTool should check against.
    Use a specific variant like "en-US" or "de-DE" instead of the generic language code like "en" or
    "de" to obtain spelling corrections (in addition to grammar corrections).

    When using the language code "auto", LTEX will try to detect the language of the document.
    This is not recommended, as only generic languages like "en" or "de" will be detected and thus
    no spelling errors will be reported.

    Possible values:
    - "auto": Automatic language detection (not recommended)
    - "ar": Arabic
    - "ast-ES": Asturian
    - "be-BY": Belarusian
    - "br-FR": Breton
    - "ca-ES": Catalan
    - "ca-ES-valencia": Catalan (Valencian)
    - "da-DK": Danish
    - "de": German
    - "de-AT": German (Austria)
    - "de-CH": German (Swiss)
    - "de-DE": German (Germany)
    - "de-DE-x-simple-language": Simple German
    - "el-GR": Greek
    - "en": English
    - "en-AU": English (Australian)
    - "en-CA": English (Canadian)
    - "en-GB": English (GB)
    - "en-NZ": English (New Zealand)
    - "en-US": English (US)
    - "en-ZA": English (South African)
    - "eo": Esperanto
    - "es": Spanish
    - "es-AR": Spanish (voseo)
    - "fa": Persian
    - "fr": French
    - "ga-IE": Irish
    - "gl-ES": Galician
    - "it": Italian
    - "ja-JP": Japanese
    - "km-KH": Khmer
    - "nl": Dutch
    - "nl-BE": Dutch (Belgium)
    - "pl-PL": Polish
    - "pt": Portuguese
    - "pt-AO": Portuguese (Angola preAO)
    - "pt-BR": Portuguese (Brazil)
    - "pt-MZ": Portuguese (Moçambique preAO)
    - "pt-PT": Portuguese (Portugal)
    - "ro-RO": Romanian
    - "ru-RU": Russian
    - "sk-SK": Slovak
    - "sl-SI": Slovenian
    - "sv": Swedish
    - "ta-IN": Tamil
    - "tl-PH": Tagalog
    - "uk-UA": Ukrainian
    - "zh-CN": Chinese
  '';

  dictionary = helpers.defaultNullOpts.mkAttrsOf (with lib.types; listOf (maybeRaw str)) { } ''
    Lists of additional words that should not be counted as spelling errors.
    This setting is language-specific, so use an attrs of the format
    ```nix
      {
        "<LANGUAGE1>" = [
          "<WORD1>"
          "<WORD2>"
          ...
        ];
        "<LANGUAGE2>" = [
          "<WORD1>"
          "<WORD2>"
        ];
        ...
      };
    ```
    where <LANGUAGE> denotes the language code in `settings.language`.

    This setting is a multi-scope setting. See the documentation for details.
    This setting supports external files. See the documentation for details.
    By default, no additional spelling errors will be ignored.

    Example:
    ```nix
    {
      "en-US" = [
        "adaptivity"
        "precomputed"
        "subproblem"
      ];
      "de-DE" = [
        "B-Splines"
        ":/path/to/externalFile.txt"
      ];
    }
    ```
  '';

  disabledRules = helpers.defaultNullOpts.mkAttrsOf (with lib.types; listOf (maybeRaw str)) { } ''
    Lists of rules that should be disabled (if enabled by default by LanguageTool).
    This setting is language-specific, so use an attrs of the format
    ```nix
      {
        "<LANGUAGE1>" = [
          "<WORD1>"
          "<WORD2>"
          ...
        ];
        "<LANGUAGE2>" = [
          "<WORD1>"
          "<WORD2>"
        ];
        ...
      };
    ```
    where `<LANGUAGE>` denotes the language code in `settings.language` and `<RULE>` the ID of
    the LanguageTool rule.

    This setting is a multi-scope setting. See the documentation for details.
    This setting supports external files. See the documentation for details.
    By default, no additional rules will be disabled.

    Example:
    ```nix
    {
      "en-US" = [
        "EN_QUOTES"
        "UPPERCASE_SENTENCE_START"
        ":/path/to/externalFile.txt"
      ];
    }
    ```
  '';

  enabledRules = helpers.defaultNullOpts.mkAttrsOf (with lib.types; listOf (maybeRaw str)) { } ''
    Lists of rules that should be enabled (if disabled by default by LanguageTool).
    This setting is language-specific, so use an attrs of the format
    ```nix
      {
        "<LANGUAGE1>" = [
          "<WORD1>"
          "<WORD2>"
          ...
        ];
        "<LANGUAGE2>" = [
          "<WORD1>"
          "<WORD2>"
        ];
        ...
      };
    ```
    where `<LANGUAGE>` denotes the language code in `settings.language` and `<RULE>` the ID of
    the LanguageTool rule.

    This setting is a multi-scope setting. See the documentation for details.
    This setting supports external files. See the documentation for details.
    By default, no additional rules will be enabled.

    Example:
    ```nix
      {
        "en-GB" = [
          "PASSIVE_VOICE"
          "OXFORD_SPELLING_NOUNS"
          ":/path/to/externalFile.txt"
        ];
      }
    ```
  '';

  hiddenFalsePositives =
    helpers.defaultNullOpts.mkAttrsOf (with lib.types; listOf (maybeRaw str)) { }
      ''
        Lists of false-positive diagnostics to hide (by hiding all diagnostics of a specific rule
        within a specific sentence).
        This setting is language-specific, so use an attrs of the format
        ```nix
          {
            "<LANGUAGE1>" = [
              "<JSON1>"
              "<JSON2>"
              ...
            ];
            "<LANGUAGE2>" = [
              "<JSON1>"
              "<JSON2>"
            ];
            ...
          };
        ```
        where `<LANGUAGE>` denotes the language code in `settings.language` and `<JSON>` is a JSON
        string containing information about the rule and sentence.

        Although it is possible to manually edit this setting, the intended way is the
        `Hide false positive` quick fix.

        The JSON string currently has the form `{"rule": "<RULE>", "sentence": "<SENTENCE>"}`, where
        `<RULE>` is the ID of the LanguageTool rule and `<SENTENCE>` is a Java-compatible regular
        expression.
        All occurrences of the given rule are hidden in sentences (as determined by the LanguageTool
        tokenizer) that match the regular expression.
        See the documentation for details.

        This setting is a multi-scope setting. See the documentation for details.
        This setting supports external files. See the documentation for details.
        If this list is very large, performance may suffer.

        Example:
        ```nix
          {
            "en-US" = [ ":/path/to/externalFile.txt" ];
          }
        ```
      '';

  fields = helpers.defaultNullOpts.mkAttrsOf types.bool { } ''
    List of BibTEX fields whose values are to be checked in BibTEX files.

    This setting is an attrs with the field names as keys (not restricted to classical BibTEX
    fields) and booleans as values, where `true` means that the field value should be checked and
    `false` means that the field value should be ignored.

    Some common fields are already ignored, even if you set this setting to an empty attrs.

    Example:
    ```nix
      {
        maintitle = false;
        seealso = true;
      }
    ```
  '';

  latex = {
    commands = helpers.defaultNullOpts.mkAttrsOf types.str { } ''
      List of LATEX commands to be handled by the LATEX parser, listed together with empty arguments
      (e.g., `"ref{}"`, `"\documentclass[]{}"`).

      This setting is an attrs with the commands as keys and corresponding actions as values.

      If you edit the `settings.json` file directly, don’t forget to escape the initial backslash by
      replacing it with two backslashes.

      Many common commands are already handled by default, even if you set this setting to an empty
      attrs.

      Example:
      ```nix
        {
          "\\label{}" = "ignore";
          "\\documentclass[]{}" = "ignore";
          "\\cite{}" = "dummy";
          "\\cite[]{}" = "dummy";
        }
      ```
    '';

    environments = helpers.defaultNullOpts.mkAttrsOf types.str { } ''
      List of names of LATEX environments to be handled by the LATEX parser.

      This setting is an attrs with the environment names as keys and corresponding actions as
      values.

      Some environments are already handled by default, even if you set this setting to an empty
      attrs.

      Example:
      ```nix
        {
          lstlisting = "ignore";
          verbatim = "ignore";
        }
      ```
    '';
  };

  markdown = {
    nodes = helpers.defaultNullOpts.mkAttrsOf types.str { } ''
      List of Markdown node types to be handled by the Markdown parser.

      This setting is an attrs with the node types as keys and corresponding actions as values.

      The Markdown parser constructs an AST (abstract syntax tree) for the Markdown document, in
      which all leaves have node type Text.
      The possible node types are listed in the documentation of flexmark-java.

      Some common node types are already handled by default, even if you set this setting to an
      empty attrs.

      Example:
      ```nix
        {
          CodeBlock = "ignore";
          FencedCodeBlock = "ignore";
          AutoLink = "dummy";
          Code = "dummy";
        }
      ```
    '';
  };

  configurationTarget =
    helpers.defaultNullOpts.mkAttrsOf types.str
      {
        dictionary = "workspaceFolderExternalFile";
        disabledRules = "workspaceFolderExternalFile";
        hiddenFalsePositives = "workspaceFolderExternalFile";
      }
      ''
        Controls which `settings.json` or external setting file (see documentation) to update when
        using one of the quick fixes.
      '';

  additionalRules = {
    enablePickyRules = helpers.defaultNullOpts.mkBool false ''
      Enable LanguageTool rules that are marked as picky and that are disabled by default, e.g.,
      rules about passive voice, sentence length, etc., at the cost of more false positives.
    '';

    motherTongue = helpers.defaultNullOpts.mkStr "" ''
      Optional mother tongue of the user (e.g., "de-DE").

      If set, additional rules will be checked to detect false friends.
      Picky rules may need to be enabled in order to see an effect
      (see `settings.additionalRules.enablePickyRules`).
      False friend detection improves if a language model is supplied (see
      `settings.additionalRules.languageModel`).

      Possible values:
      - "": No mother tongue
      - "ar": Arabic
      - "ast-ES": Asturian
      - "be-BY": Belarusian
      - "br-FR": Breton
      - "ca-ES": Catalan
      - "ca-ES-valencia": Catalan (Valencian)
      - "da-DK": Danish
      - "de": German
      - "de-AT": German (Austria)
      - "de-CH": German (Swiss)
      - "de-DE": German (Germany)
      - "de-DE-x-simple-language": Simple German
      - "el-GR": Greek
      - "en": English
      - "en-AU": English (Australian)
      - "en-CA": English (Canadian)
      - "en-GB": English (GB)
      - "en-NZ": English (New Zealand)
      - "en-US": English (US)
      - "en-ZA": English (South African)
      - "eo": Esperanto
      - "es": Spanish
      - "es-AR": Spanish (voseo)
      - "fa": Persian
      - "fr": French
      - "ga-IE": Irish
      - "gl-ES": Galician
      - "it": Italian
      - "ja-JP": Japanese
      - "km-KH": Khmer
      - "nl": Dutch
      - "nl-BE": Dutch (Belgium)
      - "pl-PL": Polish
      - "pt": Portuguese
      - "pt-AO": Portuguese (Angola preAO)
      - "pt-BR": Portuguese (Brazil)
      - "pt-MZ": Portuguese (Moçambique preAO)
      - "pt-PT": Portuguese (Portugal)
      - "ro-RO": Romanian
      - "ru-RU": Russian
      - "sk-SK": Slovak
      - "sl-SI": Slovenian
      - "sv": Swedish
      - "ta-IN": Tamil
      - "tl-PH": Tagalog
      - "uk-UA": Ukrainian
      - "zh-CN": Chinese
    '';

    languageModel = helpers.defaultNullOpts.mkStr "" ''
      Optional path to a directory with rules of a language model with n-gram occurrence counts.
      Set this setting to the parent directory that contains subdirectories for languages (e.g.,
      en).
    '';

    neuralNetworkModel = helpers.defaultNullOpts.mkStr "" ''
      Optional path to a directory with rules of a pretrained neural network model.
    '';

    word2VecModel = helpers.defaultNullOpts.mkStr "" ''
      Optional path to a directory with rules of a word2vec language model.
    '';
  };

  languageToolHttpServerUri = helpers.defaultNullOpts.mkStr "" ''
    If set to a non-empty string, LTEX will not use the bundled, built-in version of LanguageTool.
    Instead, LTEX will connect to an external LanguageTool HTTP server.
    Set this setting to the root URI of the server, and do not append v2/check or similar.

    Note that in this mode, the settings `settings.additionalRules.languageModel`,
    `settings.additionalRules.neuralNetworkModel`, and `settings.additionalRules.word2VecModel` will
    not take any effect.

    Example: `"http://localhost:8081/"`
  '';

  languageToolOrg = {
    username = helpers.defaultNullOpts.mkStr "" ''
      Username/email as used to log in at `languagetool.org` for Premium API access.
      Only relevant if `settings.languageToolHttpServerUri` is set.
    '';

    apiKey = helpers.defaultNullOpts.mkStr "" ''
      API key for Premium API access.
      Only relevant if `settings.languageToolHttpServerUri` is set.
    '';
  };

  ltex-ls = {
    path = helpers.defaultNullOpts.mkStr "" ''
      If set to an empty string, LTEX automatically downloads `ltex-ls` from GitHub, stores it in
      the folder of the extension, and uses it for the checking process.
      You can point this setting to an ltex-ls release you downloaded by yourself.

      Use the path to the root directory of ltex-ls (it contains `bin` and `lib` subdirectories).

      Changes require restarting LTEX to take effect.
    '';

    logLevel =
      helpers.defaultNullOpts.mkEnum
        [
          "severe"
          "warning"
          "info"
          "config"
          "fine"
          "finer"
          "finest"
        ]
        "fine"
        ''
          Logging level (verbosity) of the `ltex-ls` server log.

          The levels in descending order are "severe", "warning", "info", "config", "fine", "finer", and
          "finest".
          All messages that have the specified log level or a higher level are logged.

          `ltex-ls` does not use all log levels.

          Possible values:
          - "severe": Minimum verbosity. Only log severe errors.
          - "warning": Very low verbosity. Only log severe errors and warnings.
          - "info": Low verbosity. Additionally, log startup and shutdown messages.
          - "config": Medium verbosity. Additionally, log configuration messages.
          - "fine": Medium to high verbosity (default). Additionally, log when LanguageTool is called or LanguageTool has to be reinitialized due to changed settings.
          - "finer": High verbosity. Log additional debugging information such as full texts to be checked.
          - "finest": Maximum verbosity. Log all available debugging information.
        '';
  };

  java = {
    path = helpers.defaultNullOpts.mkStr "" ''
      If set to an empty string, LTEX uses a Java distribution that is bundled with `ltex-ls`.
      You can point this setting to an existing Java installation on your computer to use that
      installation instead.

      Use the same path as you would use for the `JAVA_HOME` environment variable (it usually
      contains bin and lib subdirectories, amongst others).

      Changes require restarting LTEX to take effect.
    '';

    initialHeapSize = helpers.defaultNullOpts.mkUnsignedInt 64 ''
      Initial size of the Java heap memory in megabytes (corresponds to Java’s -Xms option, must be
      a positive integer).

      Decreasing this might decrease RAM usage of the Java process.

      Changes require restarting LTEX to take effect.
    '';

    maximumHeapSize = helpers.defaultNullOpts.mkUnsignedInt 512 ''
      Maximum size of the Java heap memory in megabytes (corresponds to Java’s -Xmx option, must be
      a positive integer).

      Decreasing this might decrease RAM usage of the Java process.
      If you set this too small, the Java process may exceed the heap size, in which case an
      `OutOfMemoryError` is thrown.

      Changes require restarting LTEX to take effect.
    '';
  };

  sentenceCacheSize = helpers.defaultNullOpts.mkUnsignedInt 2000 ''
    Size of the LanguageTool ResultCache in sentences (must be a positive integer).

    If only a small portion of the text changed (e.g., a single key press in the editor),
    LanguageTool uses the cache to avoid rechecking the complete text.
    LanguageTool internally splits the text into sentences, and sentences that have already been
    checked are skipped.

    Decreasing this might decrease RAM usage of the Java process.
    If you set this too small, checking time may increase significantly.

    Changes require restarting LTEX to take effect.
  '';

  completionEnabled = helpers.defaultNullOpts.mkBool false ''
    Controls whether completion is enabled (also known as auto-completion, quick suggestions, and
    IntelliSense).

    If this setting is enabled, then a list of words is displayed that complete the currently typed
    word (whenever the editor sends a completion request).

    In VS Code, completion is enabled by default while typing (via `editor.quickSuggestions`).
    Therefore, this setting is disabled by default, as constantly displaying completion lists might
    annoy the user.
    It is recommended to enable this setting.
  '';

  diagnosticSeverity =
    helpers.defaultNullOpts.mkNullableWithRaw (with lib.types; either str (attrsOf (maybeRaw str)))
      "information"
      ''
        Severity of the diagnostics corresponding to the grammar and spelling errors.

        Controls how and where the diagnostics appear.
        The possible severities are "error", "warning", "information", and "hint".

        This setting can either be a string with the severity to use for all diagnostics, or an attrs
        with rule-dependent severities.
        If an attrs is used, each key is the ID of a LanguageTool rule and each value is one of the
        possible severities.
        In this case, the severity of other rules, which don’t match any of the keys, has to be
        specified with the special key "default".

        Examples:
        - `"information"`
        - `{PASSIVE_VOICE = "hint"; default = "information";}`
      '';

  checkFrequency =
    helpers.defaultNullOpts.mkEnumFirstDefault
      [
        "edit"
        "save"
        "manual"
      ]
      ''
        Controls when documents should be checked.

        Possible values:
        - "edit": Documents are checked when they are opened or edited (on every keystroke), or when
          the settings change.
        - "save": Documents are checked when they are opened or saved, or when the settings change.
        - "manual": Documents are not checked automatically, except when the settings change.
          Use commands such as LTeX: Check Current Document to manually trigger checks.
      '';

  clearDiagnosticsWhenClosingFile = helpers.defaultNullOpts.mkBool true ''
    If set to true, diagnostics of a file are cleared when the file is closed.
  '';

  statusBarItem = helpers.defaultNullOpts.mkBool false ''
    If set to true, an item about the status of LTEX is shown permanently in the status bar.
  '';

  trace = {
    server =
      helpers.defaultNullOpts.mkEnumFirstDefault
        [
          "off"
          "messages"
          "verbose"
        ]
        ''
          Debug setting to log the communication between language client and server.

          When reporting issues, set this to "verbose".
          Append the relevant part to the GitHub issue.

          Changes require restarting LTEX to take effect.

          Possible values:
          - "off": Don’t log any of the communication between language client and server.
          - "messages": Log the type of requests and responses between language client and server.
          - "verbose": Log the type and contents of requests and responses between language client and
            server.
        '';
  };
}
