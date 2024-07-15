{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
let
  inherit (helpers) mkNullOrLuaFn' nixvimTypes mkLazyLoadOption;

  name = "lz-n";
  originalName = "lz.n";
  cfg = config.plugins.${name};
in
with lib;
helpers.neovim-plugin.mkNeovimPlugin config {
  inherit name originalName;
  maintainers = with helpers.maintainers; [ psfloyd ];
  defaultPackage = pkgs.vimPlugins.lz-n;

  settingsDescription = ''
    The configuration options for **${originalName}** using `vim.g.lz_n`.

    `{ load = "fun"; }` -> `vim.g.lz_n = { load = fun, }`
  '';

  settingsOptions = {
    load = mkNullOrLuaFn' {
      description = ''
        Function used by `lz.n` to load plugins.
      '';
      default = null;
      pluginDefault = "vim.cmd.packadd";
    };
  };

  settingsExample = {
    load = "vim.cmd.packadd";
  };

  callSetup = false; # Does not use setup
  allowLazyLoad = false;

  extraOptions = with nixvimTypes; {
    plugins = mkOption {
      description = "List of plugins processed by lz.n";
      default = [ ];
      type = listOf (mkLazyLoadOption { }).type;
    };
  };

  extraConfig = cfg: {
    globals.lz_n = cfg.settings;
    extraConfigLua =
      let
        processKeymap =
          keymaps:
          if keymaps == null then
            null
          else
            map (
              keymap:
              {
                __unkeyed_1 = keymap.key;
                __unkeyed_2 = keymap.action;
                inherit (keymap) mode;
              }
              // keymap.options
            ) keymaps;
        pluginToLua = plugin: {
          "__unkeyed" = plugin.name;
          inherit (plugin)
            beforeAll
            before
            after
            event
            cmd
            ft
            colorscheme
            priority
            load
            ;
          enabled = plugin.enabledInSpec;
          keys = processKeymap plugin.keys;
        };
        pluginListToLua = map pluginToLua;
        plugins = pluginListToLua cfg.plugins;
        pluginSpecs = if length plugins == 1 then head plugins else plugins;
      in
      mkIf (cfg.plugins != [ ]) ''
        require('lz.n').load(
            ${helpers.toLuaObject pluginSpecs}
        )
      '';
  };
}
