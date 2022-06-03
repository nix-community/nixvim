{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.plugins.packer;
  helpers = import ../helpers.nix { lib = lib; };
in {
  options = {
    plugins.packer = {
      enable = mkEnableOption "Enable packer.nvim";

      plugins = mkOption {
        type = types.listOf (types.oneOf [types.str (with types; let 
          mkOpt = type: desc: mkOption {
            type = nullOr type;
            default = null;
            description = desc;
          };
          function = attrsOf str;
        in types.submodule {
          options = {
            name = mkOption {
              type = str;
              description = "Name of the plugin to install";
            };

            disable = mkOpt bool "Mark plugin as inactive";
            as = mkOpt bool "Specifies an alias under which to install the plugin";
            installer = mkOpt function "A custom installer";
            updater = mkOpt function "A custom updater";
            after = mkOpt (oneOf [str (listOf any)]) "Plugins to load after this plugin";
            rtp = mkOpt str "Specifies a subdirectory of the plugin to add to runtimepath";
            opt = mkOpt str "Marks a plugin as optional";
            branch = mkOpt str "Git branch to use";
            tag = mkOpt str "Git tag to use";
            commit = mkOpt str "Git commit to use";
            lock = mkOpt bool "Skip this plugin in updates";
            run = mkOpt (oneOf [str function]) "Post-install hook";
            requires = mkOpt (oneOf [str (listOf any)]) "Plugin dependencies";
            rocks = mkOpt (oneOf [str (listOf any)]) "Luarocks dependencies";
            config = mkOpt (oneOf [str function]) "Code to run after this plugin is loaded";
            setup = mkOpt (oneOf [str function]) "Code to be run before this plugin is loaded";
            cmd = mkOpt (oneOf [str (listOf str)]) "Commands which load this plugin";
            ft = mkOpt (oneOf [str (listOf str)]) "Filetypes which load this plugin";
            keys = mkOpt (oneOf [str (listOf str)]) "Keymaps which load this plugin";
            event = mkOpt (oneOf [str (listOf str)]) "Autocommand events which load this plugin";
            fn = mkOpt (oneOf [str (listOf str)]) "Functions which load this plugin";
            cond = mkOpt (oneOf [str function (listOf (oneOf [str function]))]) "Conditional test to load this plugin";
            module = mkOpt (oneOf [str (listOf str)]) "Patterns of module names which load this plugin";
          };
        })]);
        default = [];
        description = "List of plugins";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = [ (pkgs.vimPlugins.packer-nvim.overrideAttrs (_: { pname = "packer.nvim"; })) ];
      extraPackages = [ pkgs.git ];

      extraConfigLua = let
        plugins = map (plugin: if isAttrs plugin then
          mapAttrs' (k: v: { name = if k == "name" then "@" else k; value = v; }) plugin
        else plugin) cfg.plugins;
        packedPlugins = if length plugins == 1 then head plugins else plugins;
      in mkIf (cfg.plugins != []) ''
        require('packer').startup(function()
          use ${helpers.toLuaObject packedPlugins}
        end)
      '';
    };
  };
}
