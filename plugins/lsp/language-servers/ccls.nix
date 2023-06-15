{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  helpers = import ../../helpers.nix {inherit lib;};
  cfg = config.plugins.lsp.servers.ccls;
in {
  # Options: https://github.com/MaskRay/ccls/wiki/Customization#initialization-options
  options.plugins.lsp.servers.ccls.initOptions = {
    cache = {
      directory = helpers.defaultNullOpts.mkStr ".ccls-cache" ''
        If your project is `/a/b`, cache directories will be created at `/a/b/.ccls-cache/@a@b/`
        (files under the project root) `/a/b/.ccls-cache/@@a@b/` (files outside the project root,
        e.g. /usr/include/stdio.h).

        If the path name is longer than the system limit, set `cache.hierarchicalPath` to true.
        The cache files will be stored in a hierarchical manner: `/a/b/.ccls-cache/a/b/`.
        Be careful if you specify an absolute path as files indexed by different projects may
        conflict.

        This can also be an absolute path.
        Because the project path is encoded with `@`, cache directories of different projects will
        not conflict.

        When ccls is started, it will try loading cache files if they are not stale (compile command
        line matches and timestamps of main source and its `#include` (direct and transitive)
        dependencies do not change).

        If the argument is an empty string, the cache will be stored only in memory.
        Use this if you don't want to write cache files.

        Example: `"/tmp/ccls-cache"`
      '';

      format = helpers.defaultNullOpts.mkStr "binary" ''
        Specify the format of the cached index files.
        Binary is a compact binary serialization format.

        If you would like to inspect the contents of the cache you can change this to `"json"` then
        use a JSON formatter such as `jq . < /tmp/ccls/@tmp@c/a.cc.json` to display it.
      '';

      retainInMemory = helpers.defaultNullOpts.mkEnum [0 1 2] "1" ''
        Change to 0 if you want to save memory, but having multiple ccls processes operating in the
        same directory may corrupt ccls's in-memory representation of the index.

        After this number of loads, keep a copy of file index in memory (which increases memory
        usage).
        During incremental updates, the removed file index will be taken from the in-memory copy,
        instead of the on-disk file.

        Every index action is counted: the initial load, a save action.
        - 0: never retain
        - 1: retain after initial load
        - 2: retain after 2 loads (initial load+first save)
      '';
    };

    clang = {
      extraArgs = helpers.defaultNullOpts.mkNullable (with types; listOf str) "[]" ''
        Additional arguments for `compile_commands.json` entries.

        Example: `["-frounding-math"]`
      '';

      excludeArgs = helpers.defaultNullOpts.mkNullable (with types; listOf str) "[]" ''
        Excluded arguments for `compile_commands.json` entries.

        If your compiler is not Clang and it supports arguments which Clang doesn't understand, then
        you can remove those arguments when indexing.

        Example: `["-frounding-math"]`
      '';

      pathMappings = helpers.defaultNullOpts.mkNullable (with types; listOf str) "[]" ''
        A list of `src>dest` path conversions used to remap the paths of files in the project.
        This can be used to move a project to a new location without re-indexing.

        If cache files were built with project root `/tmp/remote/proj`, and you want to reuse them
        with a different project root `/tmp/host/proj` then copy the cache:

        ```
        rsync -a /tmp/ccls/@tmp@remote@proj/ /tmp/ccls/@tmp@host@proj/ # files under project root
        rsync -a /tmp/ccls/@@tmp@remote@proj/ /tmp/ccls/@@tmp@host@proj/ # files outside of project root
        ```

        Then set this option to `["/remote/>/host/"]`.

        When ccls indexes `/tmp/host/proj/a.cc`, the cache file
        `/tmp/ccls/@tmp@remote@proj/a.cc.blob` will be reused.
        When `a.cc` is saved (re-indexed), the newly generated `a.cc.blob` will not contain
        `/tmp/remote` paths any more.
      '';

      resourceDir = helpers.defaultNullOpts.mkStr "" ''
        The clang resource directory (something like `.../lib/clang/9.0.0`) is hard-coded into ccls
        at compile time.
        You should be able to find `<resourceDir>/include/stddef.h`.
        Set this option to a non-empty string to override the hard-coded value.

        Use the path provided as the Clang resource directory rather the default.
      '';
    };

    client = {
      snippetSupport = helpers.defaultNullOpts.mkBool true ''
        `client.snippetSupport` and `completion.placeholder` (default: true) decide the completion
        style.

        - `client.snippetSupport`: `false` => `foo`
        - `client.snippetSupport`: `true`
          - `completion.placeholder`: `false` => `foo($1)$0` `bar<$1>()$0`
          - `completion.placeholder`: `true` => `foo($\{1:int a}, $`{2:int b})$0` `bar<$\{1:typename T}>()$0`

        If the client announces that it does not support snippets, `client.snippetSupport` will be
        forced to `false`.
      '';
    };

    completion = {
      placeholder = helpers.defaultNullOpts.mkBool false ''
        `client.snippetSupport` and `completion.placeholder` (default: true) decide the completion
        style.

        - `client.snippetSupport`: `false` => `foo`
        - `client.snippetSupport`: `true`
          - `completion.placeholder`: `false` => `foo($1)$0` `bar<$1>()$0`
          - `completion.placeholder`: `true` => `foo($\{1:int a}, $`{2:int b})$0` `bar<$\{1:typename T}>()$0`

        If the client announces that it does not support snippets, `client.snippetSupport` will be
        forced to `false`.
      '';

      detailedLabel = helpers.defaultNullOpts.mkBool true ''
        When this option is enabled, `label` and `detailed` are re-purposed:

        - `label`: detailed function signature, e.g. `foo(int a, int b) -> bool`
        - `detailed`: the name of the parent context, e.g. in `S s; s.<complete>`, the parent
          context is `S`.
      '';

      filterAndSort = helpers.defaultNullOpts.mkBool true ''
        `ccls` filters and sorts completions to try to be nicer to clients that can't handle big
        numbers of completion candidates.
        This behaviour can be disabled by specifying `false` for the option.

        This option is useful for LSP clients that implement their own filtering and sorting logic.
      '';
    };

    compilationDatabaseDirectory = helpers.defaultNullOpts.mkStr "" ''
      If not empty, look for `compile_commands.json` in it, otherwise the file is retrieved in the
      project root.

      Useful when using out-of-tree builds with the compilation database being generated in the
      build directory.

      Example: `"out/release"`
    '';

    diagnostics = {
      onOpen = helpers.defaultNullOpts.mkInt 0 ''
        Time (in milliseconds) to wait before computing diagnostics for `textDocument/didOpen`.
        How long to wait before diagnostics are emitted when a document is opened.
      '';

      onChange = helpers.defaultNullOpts.mkInt 1000 ''
        Time (in milliseconds) to wait before computing diagnostics for `textDocument/didChange`.
        After receiving a `textDocument/didChange`, wait up to this long before reporting
        diagnostics.
        Changes during this period of time only lead to one computation.

        Diagnostics require parsing the file.
        If `1000` makes you feel slow, consider setting this to `1`.
      '';

      onSave = helpers.defaultNullOpts.mkInt 0 ''
        Time (in milliseconds) to wait before computing diagnostics for `textDocument/didSave`.
        How long to wait before diagnostics are emitted after a document is saved.
      '';
    };

    index = {
      threads = helpers.defaultNullOpts.mkInt 0 ''
        How many threads to start when indexing a project.
        `0` means use `std::thread::hardware_concurrency()` (the number of cores the system has).
        If you want to reduce peak CPU and memory usage, set it to a small integer.
      '';

      comments = helpers.defaultNullOpts.mkEnum [0 1 2] "2" ''
        `ccls` can index the contents of comments associated with functions/types/variables (macros
        are not handled).
        This value controls how comments are indexed:
        - `0`: don't index comments
        - `1`: index Doxygen comment markers
        - `2`: use `-fparse-all-comments` and recognize plain `//` `/* */` in addition to Doxygen
          comment markers
      '';

      multiVersion = helpers.defaultNullOpts.mkEnum [0 1] "0" ''
        Index a file only once (`0`), or in each translation unit that includes it (`1`).

        The default is sensible for common usage: it reduces memory footprint.
        If both `a.cc` and `b.cc` include `a.h`, there is only one indexed version of `a.h`.

        But for dependent name lookup, or references in headers that may change depending on other
        macros, etc, you may want to index a file multiple times to get every possible cross
        reference.
        In that case set the option to `1` but be aware that it may increase index file sizes
        significantly.

        Also consider using `index.multiVersionBlacklist` to exclude system headers.
      '';

      multiVersionBlacklist = helpers.defaultNullOpts.mkNullable (with types; listOf str) "[]" ''
        A list of regular expressions matching files that should not be indexed via multi-version
        if `index.multiVersion` is set to `1`.

        Commonly this is used to avoid indexing system headers multiple times as this is seldom
        useful.

        Example: `["^/usr/include"]`
      '';

      initialBlacklist = helpers.defaultNullOpts.mkNullable (with types; listOf str) "[]" ''
        A list of regular expressions matching files that should not be indexed when the `ccls`
        server starts up, but will still be indexed if a client opens them.
        If there are areas of the project that you have no interest in indexing you can use this to
        avoid it unless you visit those files.

        This can also be set to match all files, which is helpful in avoiding massive parsing
        operations when performing quick edits on large projects.

        Be aware that you will not have access to full cross-referencing information in this
        situation.

        If `index.initialWhitelist` is also specified, the whitelist takes precedence.

        Example: `["."]` (matches all files)
      '';

      onChange = helpers.defaultNullOpts.mkBool false ''
        If `false`, a file is re-indexed when saved, updating the global index incrementally.

        If set to `true`, a document is re-indexed for every (unsaved) change.
        Performance may suffer, but it is convenient for playground projects.
        Generally this is best used in conjunction with empty `cache.directory` to avoid writing
        cache files to disk.
      '';

      trackDependency = helpers.defaultNullOpts.mkEnum [0 1 2] "2" ''
        Determine whether a file should be re-indexed when any of its dependencies changes
        timestamp.

        If `a.h` has been changed, when you open `a.cc` which includes `a.h` then if
        `trackDependency` is:

        - 0: no re-indexing unless `a.cc` itself changes timestamp.
        - 2: the index of `a.cc` is considered stale and it should be re-indexed.
        - 1: before the initial load, the behavior of `2` is used, otherwise the behavior of `0` is
          used.
      '';
    };
  };

  config =
    mkIf cfg.enable
    {
      plugins.lsp.servers.pylsp.extraOptions.init_options = cfg.initOptions;
    };
}
