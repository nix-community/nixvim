{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.null-ls;
  helpers = import ../helpers.nix {inherit lib;};
in {
  imports = [
    ./servers.nix
  ];

  options.plugins.null-ls =
    helpers.extraOptionsOptions
    // {
      enable = mkEnableOption "null-ls";

      package = mkOption {
        type = types.package;
        default = pkgs.vimPlugins.null-ls-nvim;
        description = "Plugin to use for null-ls";
      };

      border = helpers.defaultNullOpts.mkBorder "null" "`:NullLsInfo` UI window." ''
        Uses `NullLsInfoBorder` highlight group (see [Highlight Groups](#highlight-groups)).
      '';

      cmd = helpers.defaultNullOpts.mkNullable (types.listOf types.str) ''["nvim"]'' ''
        Defines the command used to start the null-ls server. If you do not have an
        `nvim` binary available on your `$PATH`, you should change this to an absolute
        path to the binary.
      '';

      debounce = helpers.defaultNullOpts.mkInt 250 ''
        The `debounce` setting controls the amount of time between the last change to a buffer and the
        next `textDocument/didChange` notification.
        These notifications cause null-ls to generate diagnostics, so this setting indirectly controls
        the rate of diagnostic generation (affected by `update_in_insert`, described below).

        Lowering `debounce` will result in quicker diagnostic refreshes at the cost of running
        diagnostic sources more frequently, which can affect performance.
        The default value should be enough to provide near-instantaneous feedback from most sources
        without unnecessary resource usage.
      '';

      debug = helpers.defaultNullOpts.mkBool false ''
        Displays all possible log messages and writes them to the null-ls log, which you
        can view with the command `:NullLsLog`. This option can slow down Neovim, so
        it's strongly recommended to disable it for normal use.

        `debug = true` is the same as setting `logLevel` to `"trace"`.
      '';

      defaultTimeout = helpers.defaultNullOpts.mkInt 5000 ''
        Sets the amount of time (in milliseconds) after which built-in sources will time out.
        Note that built-in sources can define their own timeout period and that users can override the
        timeout period on a per-source basis, too (see [BUILTIN_CONFIG.md](BUILTIN_CONFIG.md)).

        Specifying a timeout with a value less than zero will prevent commands from timing out.
      '';

      diagnosticConfig = helpers.defaultNullOpts.mkNullable types.attrs "null" ''
        Specifies diagnostic display options for null-ls sources, as described in
        `:help vim.diagnostic.config()`.
        (null-ls uses separate namespaces for each source, so server-wide configuration will not work
        as expected.)

        You can also configure `diagnostic_config` per built-in by using the `with` method, described
        in BUILTIN_CONFIG.md.
      '';

      diagnosticsFormat = helpers.defaultNullOpts.mkStr "#{m}" ''
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
        method, described in [BUILTIN_CONFIG](BUILTIN_CONFIG.md).
      '';

      fallbackSeverity =
        helpers.defaultNullOpts.mkNullable
        (with types; either int (enum ["error" "warn" "info" "hint"]))
        "error"
        ''
          Defines the severity used when a diagnostic source does not explicitly define a severity.
          See `:help diagnostic-severity` for available values.
        '';

      logLevel =
        helpers.defaultNullOpts.mkEnum ["off" "error" "warn" "info" "debug" "trace"] "warn"
        ''
          Enables or disables logging to file.

          Plugin logs messages on several logging levels to following destinations:

          - file, can be inspected by `:NullLsLog`.
          - neovim's notification area.
        '';

      notifyFormat = helpers.defaultNullOpts.mkStr "[null-ls] %s" ''
        Sets the default format for `vim.notify()` messages.
        Can be used to customize 3rd party notification plugins like
        [nvim-notify](https://github.com/rcarriga/nvim-notify).
      '';

      onAttach = helpers.defaultNullOpts.mkStr "null" ''
        Defines an `on_attach` callback to run whenever null-ls attaches to a buffer.
        If you have a common `on_attach` you're using for LSP servers, you can reuse that here, use a
        custom callback for null-ls, or leave this undefined.
      '';

      onInit = helpers.defaultNullOpts.mkStr "null" ''
        Defines an `on_init` callback to run when null-ls initializes. From here, you
        can make changes to the client (the first argument) or `initialize_result` (the
        second argument, which as of now is not used).
      '';

      onExit = helpers.defaultNullOpts.mkStr "null" ''
        Defines an `on_exit` callback to run when the null-ls client exits.
      '';

      rootDir = helpers.defaultNullOpts.mkStr "null" ''
        Determines the root of the null-ls server. On startup, null-ls will call
        `root_dir` with the full path to the first file that null-ls attaches to.

        ```lua
        local root_dir = function(fname)
            return fname:match("my-project") and "my-project-root"
        end
        ```

        If `root_dir` returns `nil`, the root will resolve to the current working
        directory.
      '';

      shouldAttach = helpers.defaultNullOpts.mkStr "null" ''
        A user-defined function that controls whether to enable null-ls for a given
        buffer. Receives `bufnr` as its first argument.

        To cut down potentially expensive calls, null-ls will call `should_attach` after
        its own internal checks pass, so it's not guaranteed to run on each new buffer.

        ```lua
        require("null-ls.nvim").setup({
            should_attach = function(bufnr)
                return not vim.api.nvim_buf_get_name(bufnr):match("^git://")
            end,
        })
        ```
      '';

      tempDir = helpers.defaultNullOpts.mkStr "null" ''
        Defines the directory used to create temporary files for sources that rely on them (a
        workaround used for command-based sources that do not support `stdio`).

        To maximize compatibility, null-ls defaults to creating temp files in the same directory as
        the parent file.
        If this is causing issues, you can set it to `/tmp` (or another appropriate directory) here.
        Otherwise, there is no need to change this setting.

        **Note**: some null-ls built-in sources expect temp files to exist within a project for
        context and so will not work if this option changes.

        You can also configure `temp_dir` per built-in by using the `with` method, described in
        BUILTIN_CONFIG.md.
      '';

      updateInInsert = helpers.defaultNullOpts.mkBool false ''
        Controls whether diagnostic sources run in insert mode.
        If set to `false`, diagnostic sources will run upon exiting insert mode, which greatly
        improves performance but can create a slight delay before diagnostics show up.
        Set this to `true` if you don't experience performance issues with your sources.

        Note that by default, Neovim will not display updated diagnostics in insert mode.
        Together with the option above, you need to pass `update_in_insert = true` to
        `vim.diagnostic.config` for diagnostics to work as expected.
        See `:help vim.diagnostic.config` for more info.
      '';

      sourcesItems =
        helpers.mkNullOrOption
        (with types; listOf (attrsOf str))
        "The list of sources to enable, should be strings of lua code. Don't use this directly";
    };

  config = let
    options =
      {
        inherit
          (cfg)
          border
          cmd
          debounce
          debug
          ;
        default_timeout = cfg.defaultTimeout;
        diagnostic_config = cfg.diagnosticConfig;
        diagnostics_format = cfg.diagnosticsFormat;
        fallback_severity =
          if isString cfg.fallbackSeverity
          then helpers.mkRaw "vim.diagnostic.severity.${strings.toUpper cfg.fallbackSeverity}"
          else cfg.fallbackSeverity;
        log_level = cfg.logLevel;
        notify_format = cfg.notifyFormat;
        on_attach =
          helpers.ifNonNull' cfg.onAttach
          (helpers.mkRaw cfg.onAttach);
        on_init =
          helpers.ifNonNull' cfg.onInit
          (helpers.mkRaw cfg.onInit);
        on_exit =
          helpers.ifNonNull' cfg.onExit
          (helpers.mkRaw cfg.onExit);
        root_dir =
          helpers.ifNonNull' cfg.rootDir
          (helpers.mkRaw cfg.rootDir);
        should_attach =
          helpers.ifNonNull' cfg.shouldAttach
          (helpers.mkRaw cfg.shouldAttach);
        temp_dir = cfg.tempDir;
        update_in_insert = cfg.updateInInsert;

        sources = cfg.sourcesItems;
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];

      extraConfigLua = ''
        require("null-ls").setup(${helpers.toLuaObject options})
      '';
    };
}
