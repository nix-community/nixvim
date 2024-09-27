{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.wilder;

  mkKeyOption =
    default: desc:
    helpers.defaultNullOpts.mkNullable
      (
        with types;
        either str (submodule {
          options = {
            key = mkOption {
              type = str;
              description = desc;
            };

            fallback = mkOption {
              type = either str (enum [ false ]);
              description = ''
                For a no-op, set <fallback> to "".

                The fallback mappings can be disabled by setting `fallback` to 0.

                Disabling the fallback mapping allows a `|<Cmd>|` mapping to be used which improves
                rendering performance slightly as the mappings to be called outside the sandbox
                (see `|:map-expression|`).
              '';
            };
          };
        })
      )
      default
      ''
        ${desc}

        NOTE:
        A string or an attrs (with keys `key` and `fallback`) representing the mapping to bind to
        `|wilder#next()|`.
        If a string is provided, it is automatically converted to `{key = <KEY>; fallback = <KEY>;}`.

        - `mapping` is the `|cmap|` used to bind to `|wilder#next()|`.
        - `fallback` is the mapping used if `|wilder#in_context()|` is false.
      '';
in
{
  imports = [
    (mkRenamedOptionModule
      [
        "plugins"
        "wilder-nvim"
      ]
      [
        "plugins"
        "wilder"
      ]
    )
  ];

  options.plugins.wilder = helpers.neovim-plugin.extraOptionsOptions // {
    enable = mkEnableOption "wilder-nvim";

    package = lib.mkPackageOption pkgs "wilder-nvim" {
      default = [
        "vimPlugins"
        "wilder-nvim"
      ];
    };

    ### Setup options ###
    enableCmdlineEnter = helpers.defaultNullOpts.mkBool true ''
      If true calls `wilder#enable_cmdline_enter()`.
      Creates a new `|CmdlineEnter|` autocmd to which will start wilder when the cmdline is
      entered.
    '';

    modes =
      helpers.defaultNullOpts.mkListOf
        (types.enum [
          "/"
          "?"
          ":"
        ])
        [
          "/"
          "?"
        ]
        "List of modes that wilder will be active in.";

    wildcharm =
      helpers.defaultNullOpts.mkNullable (with types; either str (enum [ false ])) "&wildchar"
        ''
          Key to set the 'wildcharm' option to.
          Can be set to v:false to skip the setting.
        '';

    nextKey = mkKeyOption "<Tab>" ''
      A key to map to `wilder#next()` providing next suggestion.
    '';

    prevKey = mkKeyOption "<S-Tab>" ''
      A key to map to `wilder#prev()` providing previous suggestion.
    '';

    acceptKey = mkKeyOption "<Down>" ''
      Mapping to bind to `wilder#accept_completion()`.
    '';

    rejectKey = mkKeyOption "<Up>" ''
      Mapping to bind to `wilder#reject_completion()`.
    '';

    acceptCompletionAutoSelect = helpers.defaultNullOpts.mkBool true ''
      The `auto_select` option passed to `wilder#accept_completion()`, if mapped.
    '';

    ### Other options ###
    useCmdlinechanged = helpers.mkNullOrOption types.bool ''
      If true, wilder will refresh queries when the `|CmdlineChanged|` autocommand is triggered.
      Otherwise it will use a `|timer|` to check whether the cmdline has changed.
      Using a timer will be more resource intensive.

      Default: `exists('##CmdlineChanged')`
    '';

    interval = helpers.defaultNullOpts.mkUnsignedInt 100 ''
      Interval of the `|timer|` used to check whether the cmdline has changed, in milliseconds.
      Only applicable if `useCmdlinechanged` is false.
    '';

    beforeCursor = helpers.defaultNullOpts.mkBool false ''
      If true, wilder will look only at the part of the cmdline before the cursor, and when
      selecting a completion, the entire cmdline will be replaced.
      Only applicable if `useCmdlinechanged` is false.
    '';

    usePythonRemotePlugin = helpers.mkNullOrOption types.bool ''
      If true, uses the Python remote plugin.
      This option can be set to false to disable the Python remote plugin.

      This option has to be set before setting the `pipeline` option and before wilder is first
      run.

      Default: `has('python3') && (has('nvim') || exists('*yarp#py3'))`
    '';

    numWorkers = helpers.defaultNullOpts.mkUnsignedInt 2 ''
      Number of workers for the Python 3 `|remote-plugin|`.
      Has to be set at startup, before wilder is first run.
      Setting the option after the first run has no effect.
    '';

    pipeline = helpers.mkNullOrOption (with lib.types; listOf strLua) ''
      Sets the pipeline to use to get completions.
      See `|wilder-pipeline|`.

      Example:
      ```lua
        [
          \'\'
            wilder.branch(
              wilder.cmdline_pipeline({
                language = 'python',
                fuzzy = 1,
              }),
              wilder.python_search_pipeline({
                pattern = wilder.python_fuzzy_pattern(),
                sorter = wilder.python_difflib_sorter(),
                engine = 're',
              })
            )
          \'\'
        ]
      ```
    '';

    renderer = helpers.defaultNullOpts.mkLuaFn "nil" ''
      Sets the renderer to used to display the completions.
      See `|wilder-renderer|`.

      Example:
      ```lua
        \'\'
          wilder.wildmenu_renderer({
            -- highlighter applies highlighting to the candidates
            highlighter = wilder.basic_highlighter(),
          })
        \'\'
      ```
    '';

    preHook = helpers.defaultNullOpts.mkLuaFn "nil" ''
      A function which takes a `ctx`.
      This function is called when wilder starts, or when wilder becomes unhidden.
      See `|wilder-hidden|`.

      `ctx` contains no keys.
    '';

    postHook = helpers.defaultNullOpts.mkLuaFn "nil" ''
      A function which takes a `ctx`.
      This function is called when wilder stops, or when wilder becomes hidden.
      See `|wilder-hidden|`.

      `ctx` contains no keys.
    '';
  };

  config =
    let
      setupOptions =
        with cfg;
        let
          processKeyOpt =
            key:
            helpers.ifNonNull' key (
              if isString key then
                key
              else
                [
                  key.key
                  key.fallback
                ]
            );
        in
        {
          enable_cmdline_enter = enableCmdlineEnter;
          inherit modes;
          inherit wildcharm;
          next_key = processKeyOpt nextKey;
          previous_key = processKeyOpt prevKey;
          accept_key = processKeyOpt acceptKey;
          reject_key = processKeyOpt rejectKey;
          accept_completion_auto_select = acceptCompletionAutoSelect;
        };

      options =
        with cfg;
        {
          use_cmdlinechanged = useCmdlinechanged;
          inherit interval;
          before_cursor = beforeCursor;
          use_python_remote_plugin = usePythonRemotePlugin;
          num_workers = numWorkers;
          pipeline = helpers.ifNonNull' pipeline (map helpers.mkRaw pipeline);
          inherit renderer;
          pre_hook = preHook;
          post_hook = postHook;
        }
        // cfg.extraOptions;
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      extraConfigLua = ''
        wilder = require("wilder")
        wilder.setup(${helpers.toLuaObject setupOptions})

        local __wilderOptions = ${helpers.toLuaObject options}
        for key, value in pairs(__wilderOptions) do
          wilder.set_option(key, value)
        end
      '';
    };
}
