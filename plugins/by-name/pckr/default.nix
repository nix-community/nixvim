{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "pckr";
  package = "pckr-nvim";
  description = "A Neovim plugin manager that allows you to install plugins from various sources. Spiritual successor to packer.nvim.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  dependencies = [ "git" ];

  imports = [
    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "pckr";
      packageName = "git";
    })
  ];

  extraOptions = {
    plugins = lib.mkOption {
      default = [ ];
      type =
        let
          pluginType = lib.types.either types.str (
            types.submodule {
              freeformType = with types; attrsOf anything;
              options = {
                path = mkOption {
                  type = types.str;
                  example = "nvim-treesitter/nvim-treesitter";
                  description = ''
                    Repo/path to the plugin.
                  '';
                };
                requires = mkOption {
                  type = types.listOf pluginType;
                  default = [ ];
                  example = [
                    "kyazdani42/nvim-web-devicons"
                  ];
                  description = ''
                    Dependencies for this plugin.
                  '';
                };
              };
            }
          );
        in
        types.listOf pluginType;
      example = [
        "9mm/vim-closer"
        "~/projects/personal/hover.nvim"
        {
          path = "tpope/vim-dispatch";
          cond = [
            { __raw = "require('pckr.loader.cmd')('Dispatch')"; }
          ];
        }
        {
          path = "nvim-treesitter/nvim-treesitter";
          run = ":TSUpdate";
        }
      ];
      description = ''
        List of plugins to install with pckr.
      '';
    };
  };

  settingsExample = {
    autoremove = true;
    pack_dir.__raw = "vim.env.VIM .. '/pckr'";
    lockfile.path.__raw = "vim.fn.stdpath('config') .. '/pckr/lockfile.lua'";
  };

  extraConfig = cfg: {
    plugins.pckr.luaConfig = {
      # Otherwise pckr can't find itself
      pre = ''
        vim.opt.rtp:prepend("${cfg.package}")
      '';

      # Add plugins after calling require('pckr').setup()
      post =
        let
          normalizePlugin =
            p:
            if builtins.isString p then
              p
            else
              builtins.removeAttrs p [
                "path"
                "requires"
              ]
              // {
                __unkeyed = p.path;
                requires = normalizePlugins p.requires;
              };

          normalizePlugins = lib.map normalizePlugin;

          plugins = normalizePlugins cfg.plugins;

          packedPlugins = if lib.length plugins == 1 then builtins.head plugins else plugins;
        in
        lib.mkIf (cfg.plugins != [ ]) ''
          require('pckr').add(${lib.nixvim.toLuaObject packedPlugins})
        '';
    };
  };
}
