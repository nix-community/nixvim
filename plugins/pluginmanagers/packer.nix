{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.packer;
in
{
  options = {
    plugins.packer = {
      enable = mkEnableOption "packer.nvim";

      package = lib.mkPackageOption pkgs [
        "vimPlugins"
        "packer-nvim"
      ] { };

      gitPackage = lib.mkPackageOption pkgs "git" {
        nullable = true;
      };

      plugins =
        with types;
        let
          pluginType = either str (submodule {
            options = {
              name = mkOption {
                type = str;
                description = "Name of the plugin to install";
              };

              disable = helpers.mkNullOrOption bool "Mark plugin as inactive";

              as = helpers.mkNullOrOption str "Specifies an alias under which to install the plugin";

              installer = helpers.defaultNullOpts.mkLuaFn "nil" "A custom installer";

              updater = helpers.defaultNullOpts.mkLuaFn "nil" "A custom updater";

              after = helpers.mkNullOrOption (either str (listOf str)) "Plugins to load after this plugin";

              rtp = helpers.mkNullOrOption str "Specifies a subdirectory of the plugin to add to runtimepath";

              opt = helpers.mkNullOrOption bool "Marks a plugin as optional";

              branch = helpers.mkNullOrOption str "Git branch to use";

              tag = helpers.mkNullOrOption str "Git tag to use";

              commit = helpers.mkNullOrOption str "Git commit to use";

              lock = helpers.mkNullOrOption bool "Skip this plugin in updates";

              run = helpers.mkNullOrOption (oneOf [
                str
                rawLua
                (listOf (either str rawLua))
              ]) "Post-install hook";

              requires = helpers.mkNullOrOption (eitherRecursive str listOfPlugins) "Plugin dependencies";

              rocks = helpers.mkNullOrOption (either str (listOf (either str attrs))) "Luarocks dependencies";

              config = helpers.mkNullOrOption (either str rawLua) "Code to run after this plugin is loaded";

              setup = helpers.mkNullOrOption (either str rawLua) "Code to be run before this plugin is loaded";

              cmd = helpers.mkNullOrOption (either str (listOf str)) "Commands which load this plugin";

              ft = helpers.mkNullOrOption (either str (listOf str)) "Filetypes which load this plugin";

              keys = helpers.mkNullOrOption (either str (listOf str)) "Keymaps which load this plugin";

              event = helpers.mkNullOrOption (either str (listOf str)) "Autocommand events which load this plugin";

              fn = helpers.mkNullOrOption (either str (listOf str)) "Functions which load this plugin";

              cond = helpers.mkNullOrOption (oneOf [
                str
                rawLua
                (listOf (either str rawLua))
              ]) "Conditional test to load this plugin";

              module = helpers.mkNullOrOption (either str (listOf str)) "Patterns of module names which load this plugin";
            };
          });

          listOfPlugins = types.listOf pluginType;
        in
        mkOption {
          type = listOfPlugins;
          default = [ ];
          description = "List of plugins";
        };

      rockPlugins = mkOption {
        type = with types; listOf (either str attrs);
        description = "List of lua rock plugins";
        default = [ ];
        example = ''
          [
            "penlight"
            "lua-resty-http"
            "lpeg"
          ]
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    extraPlugins = [ cfg.package ];

    extraPackages = [ cfg.gitPackage ];

    extraConfigLua =
      let
        luaRockPluginToLua =
          luaRockPlugin:
          if isAttrs luaRockPlugin then
            mapAttrs' (k: v: {
              name = if k == "name" then "__unkeyed" else k;
              value = v;
            }) luaRockPlugin
          else
            luaRockPlugin;
        luaRockListToLua = map luaRockPluginToLua;

        pluginToLua =
          plugin:
          if isAttrs plugin then
            {
              "__unkeyed" = plugin.name;

              inherit (plugin)
                disable
                as
                installer
                updater
                after
                rtp
                opt
                branch
                tag
                commit
                lock
                run
                ;

              requires = helpers.ifNonNull' plugin.requires (
                if isList plugin.requires then (pluginListToLua plugin.requires) else plugin.requires
              );

              rocks = helpers.ifNonNull' plugin.rocks (
                if isList plugin.rocks then luaRockListToLua plugin.rocks else plugin.rocks
              );

              inherit (plugin)
                config
                setup
                cmd
                ft
                keys
                event
                fn
                cond
                module
                ;
            }
          else
            plugin;

        pluginListToLua = map pluginToLua;

        plugins = pluginListToLua cfg.plugins;

        packedPlugins = if length plugins == 1 then head plugins else plugins;

        luaRockPlugins = luaRockListToLua cfg.rockPlugins;
        luaRocksString = optionalString (
          cfg.rockPlugins != [ ]
        ) "use_rocks ${helpers.toLuaObject luaRockPlugins}";
      in
      mkIf (cfg.plugins != [ ]) ''
        require('packer').startup(function()
          use ${helpers.toLuaObject packedPlugins}
          ${luaRocksString}
        end)
      '';
  };
}
