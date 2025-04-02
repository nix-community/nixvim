{
  lib,
  config,
  options,
  ...
}:
let
  cfg = config.plugins.cmp;
  opt = options.plugins.cmp;

  cleanSrc = lib.flip builtins.removeAttrs [
    "name"
  ];

  isRaw = v: v ? __raw || v._type or null == "lua-inline";

  getSrcDefs =
    sourceName: list:
    if builtins.isList list then
      lib.pipe list [
        (builtins.filter (src: !isRaw src))
        (builtins.filter (src: src.name == sourceName))
        (builtins.map (lib.filterAttrs (_: v: v != null)))
        lib.mergeAttrsList
      ]
    else
      lib.throwIfNot (isRaw list)
        "cmp/deprecated-auto-enable: unexpected cmp sources type: ${builtins.typeOf list}"
        { };

  getNestedSrcDefs =
    sourceName: set:
    lib.pipe set [
      (builtins.mapAttrs (_: settings: getSrcDefs sourceName settings.sources))
      (lib.filterAttrs (_: v: v != { }))
      (builtins.mapAttrs (_: cleanSrc))
    ];

  # Check if the source is listed in `plugins.cmp.settings.sources` without the plugin being enabled
  # This is most likely to happen when a user was relying on the now removed `autoEnableSources` option
  # Produce a warning with detailed migration instructions.
  mkWarningDef =
    name:
    let
      pluginOpt = options.plugins.${name};
      pluginCfg = config.plugins.${name};
      pluginLoc = lib.dropEnd 1 pluginOpt.enable.loc;
      cmpLoc = lib.dropEnd 1 options.plugins.cmp.enable.loc;

      # Collect defined sources for this plugin
      defaultDef = getSrcDefs pluginCfg.cmp.name cfg.settings.sources;
      sourceDefs =
        lib.optionalAttrs (defaultDef != { }) {
          default = cleanSrc defaultDef;
        }
        // lib.filterAttrs (_: v: v != { }) {
          cmdline = getNestedSrcDefs pluginCfg.cmp.name cfg.cmdline;
          filetypes = getNestedSrcDefs pluginCfg.cmp.name cfg.filetype;
        };

      indent = "        ";

      showSrcDef =
        loc: new: def:
        let
          defLoc = lib.showOption (cmpLoc ++ loc ++ [ "sources" ]);
          join = if lib.hasInfix "\n" suggestion then "\n" + indent else " ";
          suggestion = "${lib.showOption (pluginLoc ++ [ "cmp" ] ++ new)} = ${
            if def == { } then "true" else lib.generators.toPretty { inherit indent; } def
          };";
        in
        [
          "remove ${builtins.toJSON pluginCfg.cmp.name} from: ${defLoc}"
          "instead define:${join}${suggestion}"
        ];

      lines = lib.flatten (
        lib.singleton "manually enable `${pluginOpt.enable}`"
        ++ lib.optional (sourceDefs ? default) (showSrcDef [ "settings" ] [ "default" ] sourceDefs.default)
        ++ lib.mapAttrsToList (name: showSrcDef [ "cmdline" name ] [ "cmdline" name ]) (
          sourceDefs.cmdline or { }
        )
        ++ lib.mapAttrsToList (name: showSrcDef [ "filetype" name ] [ "filetypes" name ]) (
          sourceDefs.filetype or { }
        )
      );

      lineCount = builtins.length lines;
    in
    lib.mkIf
      (
        cfg.enable
        && !pluginCfg.enable
        && pluginOpt.enable.highestPrio == 1500
        && pluginCfg.cmp.enable
        && sourceDefs != { }
      )
      (
        lib.nixvim.mkWarnings (lib.showOption pluginLoc) ''
          The ${builtins.toJSON pluginCfg.cmp.name} nvim-cmp source has been defined via `${lib.showOption cmpLoc}`, howevew `${pluginOpt.enable}` is not enabled.
          You should${
            if lineCount == 1 then
              " " + builtins.head lines
            else
              ":"
              + lib.concatImapStrings (
                i: line: "\n${builtins.toString i}. ${lib.nixvim.utils.upperFirstChar line}"
              ) lines
          }
          You can suppress this warning by explicitly setting `${pluginOpt.enable} = false`.
        '' # TODO: link to PR/docs/guide/faq
      );
in
{
  imports = [
    (lib.mkRemovedOptionModule [
      "cmpSourcePlugins"
    ] "Use `lib.nixvim.modules.mkCmpPluginModule` instead.")
    (lib.mkRemovedOptionModule [ "plugins" "cmp" "autoEnableSources" ] ''
      Instead of defining `${
        lib.showOption (opt.settings.loc ++ [ "sources" ])
      }` and using `autoEnableSources` to enable the relevant plugins,
      you should now enable the plugins and they will automatically add themselves to `${
        lib.showOption (opt.settings.loc ++ [ "sources" ])
      }`.
    '') # TODO: add a link to PR/docs/faq/guide
  ];

  warnings = lib.pipe options.plugins [
    (lib.flip builtins.removeAttrs [
      # lspkind has its own `cmp` options, but isn't a nvim-cmp source
      "lspkind"
    ])
    # Actual options are probably aliases, not plugins
    (lib.filterAttrs (_: opt: !lib.isOption opt))
    (lib.filterAttrs (_: opt: opt ? cmp))
    builtins.attrNames
    (builtins.map mkWarningDef)
    lib.mkMerge
  ];
}
