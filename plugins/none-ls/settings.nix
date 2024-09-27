lib:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
  applyListOfLua = x: map (v: if builtins.isString v then lib.nixvim.mkRaw v else v) x;
in
{
  border = defaultNullOpts.mkNullable' {
    type =
      with types;
      oneOf [
        attrs
        str
        rawLua
      ];
    pluginDefault = null;
    description = ''
      Defines the border to use for the `:NullLsInfo` UI window.
      Uses `NullLsInfoBorder` highlight group (see [Highlight Groups]).
      Accepts same border values as `nvim_open_win()`.
      See `:help nvim_open_win()` for more info.

      [Highlight Groups]: https://github.com/nvimtools/none-ls.nvim/blob/main/doc/CONFIG.md#highlight-groups
    '';
  };

  cmd = defaultNullOpts.mkListOf types.str [ "nvim" ] ''
    Defines the command used to start the null-ls server.
    If you do not have an `nvim` binary available on your `$PATH`,
    you should change this to an absolute path to the binary.
  '';

  debounce = defaultNullOpts.mkUnsignedInt 250 ''
    The `debounce` setting controls the amount of time between the last change to a
    buffer and the next `textDocument/didChange` notification. These notifications
    cause null-ls to generate diagnostics, so this setting indirectly controls the
    rate of diagnostic generation (affected by `update_in_insert`, described below).

    Lowering `debounce` will result in quicker diagnostic refreshes at the cost of running
    diagnostic sources more frequently, which can affect performance.
    The default value should be enough to provide near-instantaneous feedback from most sources
    without unnecessary resource usage.
  '';

  debug = defaultNullOpts.mkBool false ''
    Displays all possible log messages and writes them to the null-ls log, which you
    can view with the command `:NullLsLog`. This option can slow down Neovim, so
    it's strongly recommended to disable it for normal use.

    `debug = true` is the same as setting `log_level` to `"trace"`.
  '';

  default_timeout = defaultNullOpts.mkUnsignedInt 5000 ''
    Sets the amount of time (in milliseconds) after which built-in sources will time out.
    Note that built-in sources can define their own timeout period and that users can override the
    timeout period on a per-source basis, too
    (see [BUILTIN_CONFIG.md](https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md)).

    Specifying a timeout with a value less than zero will prevent commands from timing out.
  '';

  diagnostic_config = defaultNullOpts.mkNullable' {
    type =
      with types;
      oneOf [
        attrs
        str
        rawLua
      ];
    pluginDefault = { };
    description = ''
      Specifies diagnostic display options for null-ls sources, as described in
      `:help vim.diagnostic.config()`.
      (null-ls uses separate namespaces for each source,
      so server-wide configuration will not work as expected.)

      You can also configure `diagnostic_config` per built-in by using the `with` method, described
      in [BUILTIN_CONFIG](https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md).
    '';
  };

  diagnostics_format = defaultNullOpts.mkStr "#{m}" ''
    Sets the default format used for diagnostics. The plugin will replace the following special
    components with the relevant diagnostic information:

    - `#{m}`: message
    - `#{s}`: source name (defaults to `null-ls` if not specified)
    - `#{c}`: code (if available)

    For example, setting `diagnostics_format` to the following:

    ```lua
      diagnostics_format = "[#{c}] #{m} (#{s})"
    ```

    Formats diagnostics as follows:

    ```txt
      [2148] Tips depend on target shell and yours is unknown. Add a shebang or a 'shell' directive. (shellcheck)
    ```

      You can also configure `diagnostics_format` per built-in by using the `with`
      method, described in [BUILTIN_CONFIG](https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md).
  '';

  fallback_severity = defaultNullOpts.mkUnsignedInt { __raw = "vim.diagnostic.severity.ERROR"; } ''
    Defines the severity used when a diagnostic source does not explicitly define a severity.
    See `:help diagnostic-severity` for available values.
  '';

  log_level =
    defaultNullOpts.mkEnum
      [
        "off"
        "error"
        "warn"
        "info"
        "debug"
        "trace"
      ]
      "warn"
      ''
        Enables or disables logging to file.

        Plugin logs messages on several logging levels to following destinations:
        - file, can be inspected by `:NullLsLog`.
        - neovim's notification area.
      '';

  notify_format = defaultNullOpts.mkStr "[null-ls] %s" ''
    Sets the default format for `vim.notify()` messages.
    Can be used to customize 3rd party notification plugins like
    [nvim-notify](https://github.com/rcarriga/nvim-notify).
  '';

  on_attach = defaultNullOpts.mkLuaFn null ''
    Defines an `on_attach` callback to run whenever null-ls attaches to a buffer.
    If you have a common `on_attach` you're using for LSP servers, you can reuse that here,
    use a custom callback for null-ls, or leave this undefined.
  '';

  on_init = defaultNullOpts.mkLuaFn null ''
    Defines an `on_init` callback to run when null-ls initializes.
    From here, you can make changes to the client (the first argument)
    or `initialize_result` (the second argument, which as of now is not used).
  '';

  on_exit = defaultNullOpts.mkLuaFn null ''
    Defines an `on_exit` callback to run when the null-ls client exits.
  '';

  root_dir = defaultNullOpts.mkLuaFn' {
    pluginDefault = "require('null-ls.utils').root_pattern('.null-ls-root', 'Makefile', '.git')";
    description = ''
      Determines the root of the null-ls server. On startup, null-ls will call
      `root_dir` with the full path to the first file that null-ls attaches to.

      If `root_dir` returns `nil`, the root will resolve to the current working directory.
    '';
    example = ''
      function(fname)
        return fname:match("my-project") and "my-project-root"
      end
    '';
  };

  root_dir_async = defaultNullOpts.mkLuaFn' {
    pluginDefault = null;
    description = ''
      Like `root_dir` but also accepts a callback parameter allowing it to be
      asynchronous. Overwrites `root_dir` when present.

      For a utility that asynchronously finds a matching file, see `utils.root_pattern_async`.
    '';
    example = ''
      function(fname, cb)
        cb(fname:match("my-project") and "my-project-root")
      end
    '';
  };

  should_attach = defaultNullOpts.mkLuaFn' {
    pluginDefault = null;
    description = ''
      A user-defined function that controls whether to enable null-ls for a given
      buffer. Receives `bufnr` as its first argument.

      To cut down potentially expensive calls, null-ls will call `should_attach` after
      its own internal checks pass, so it's not guaranteed to run on each new buffer.
    '';
    example = ''
      function(bufnr)
        return not vim.api.nvim_buf_get_name(bufnr):match("^git://")
      end
    '';
  };

  # Not using mkListOf because I want `strLua` instead of `rawLua`
  sources = defaultNullOpts.mkNullable' {
    # TODO: support custom & third-party sources.
    # Need a "source" submodule type:
    # https://github.com/nvimtools/none-ls.nvim/blob/main/doc/MAIN.md#sources
    type = with types; listOf strLua;
    apply = x: if x == null then null else applyListOfLua x;
    pluginDefault = null;
    description = ''
      The list of sources to enable, should be strings of lua code. Don't use this directly.

      You should use `plugins.none-ls.sources.*.enable` instead.

      **Upstream's description:**

      Defines a list of sources for null-ls to register.
      Users can add built-in sources (see [BUILTINS]) or custom sources (see [MAIN]).

      If you've installed an integration that provides its own sources and aren't
      interested in built-in sources, you don't have to define any sources here. The
      integration will register them independently.

      [BUILTINS]: https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
      [MAIN]: https://github.com/nvimtools/none-ls.nvim/blob/main/doc/MAIN.md
    '';
    # Hide this option until we decide how to handle non-builtin sources:
    visible = false;
  };

  temp_dir = defaultNullOpts.mkStr null ''
    Defines the directory used to create temporary files for sources that rely on
    them (a workaround used for command-based sources that do not support `stdio`).

    To maximize compatibility, null-ls defaults to creating temp files in the same
    directory as the parent file. If this is causing issues, you can set it to
    `/tmp` (or another appropriate directory) here. Otherwise, there is no need to
    change this setting.

    **Note**: some null-ls built-in sources expect temp files to exist within a
    project for context and so will not work if this option changes.

    You can also configure `temp_dir` per built-in by using the `with` method,
    described in [BUILTIN_CONFIG](https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md).
  '';

  update_in_insert = defaultNullOpts.mkBool false ''
    Controls whether diagnostic sources run in insert mode. If set to `false`,
    diagnostic sources will run upon exiting insert mode, which greatly improves
    performance but can create a slight delay before diagnostics show up. Set this
    to `true` if you don't experience performance issues with your sources.

    Note that by default, Neovim will not display updated diagnostics in insert
    mode. Together with the option above, you need to pass `update_in_insert = true`
    to `vim.diagnostic.config` for diagnostics to work as expected. See
    `:help vim.diagnostic.config` for more info.
  '';
}
