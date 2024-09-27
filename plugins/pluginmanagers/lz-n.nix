{
  lib,
  options,
  ...
}:
with lib;
let
  inherit (lib.nixvim) defaultNullOpts;
in
nixvim.neovim-plugin.mkNeovimPlugin {
  name = "lz-n";
  originalName = "lz.n";
  maintainers = [ maintainers.psfloyd ];

  settingsDescription = ''
    Options provided to `vim.g.lz_n`.

    `{ load = "fun"; }` -> `vim.g.lz_n = { load = fun, }`
  '';

  settingsOptions = {
    load = defaultNullOpts.mkLuaFn "vim.cmd.packadd" ''
      Function used by `lz.n` to load plugins.
    '';
  };

  callSetup = false; # Does not use setup

  extraOptions =
    let
      lzPluginType = types.submodule {
        freeformType = types.attrsOf types.anything;
        options = {
          __unkeyed-1 = mkOption {
            type = types.str;
            description = ''
              The "unkeyed" attribute is the plugin's name.
              This is passed to `load` function and should normally match the repo name of the plugin.

              More specifically, this is the name of the folder in `/pack/opt/{name}` that is loaded with `load` (`packadd` by default).
              See `:h packadd`.
            '';
          };

          enabled = nixvim.defaultNullOpts.mkStrLuaFnOr types.bool true ''
            When false, or if the function returns false, then this plugin will not be included in the spec.
            This option corresponds to the `enabled` property of lz.n.
          '';

          beforeAll = nixvim.mkNullOrLuaFn ''
            Always executed before any plugins are loaded.
          '';

          before = nixvim.mkNullOrLuaFn ''
            Executed before this plugin is loaded.
          '';

          after = nixvim.mkNullOrLuaFn ''
            Executed after this plugin is loaded.
          '';

          load = nixvim.mkNullOrLuaFn ''
            Can be used to override the `vim.g.lz_n.load()` function for this plugin.
          '';

          priority = nixvim.defaultNullOpts.mkUnsignedInt (literalMD "`50` (or `1000` if `colorscheme` is set)") ''
            Only useful for start plugins (not lazy-loaded) to force loading certain plugins first. 
          '';

          event = nixvim.mkNullOrOption' {
            type = types.anything;
            description = ''
              Lazy-load on event. Events can be specified as BufEnter or with a pattern like BufEnter *.lua
            '';
            example = [
              "BufEnter *.lua"
              "DeferredUIEnter"
            ];
          };

          cmd = nixvim.mkNullOrOption' {
            type = types.anything;
            description = ''
              Lazy-load on command.
            '';
            example = [
              "Neotree"
              "Telescope"
            ];
          };

          ft = nixvim.mkNullOrOption' {
            type = types.anything;
            description = ''
              Lazy-load on filetype.
            '';
            example = [ "tex" ];
          };

          colorscheme = nixvim.mkNullOrOption' {
            type = types.anything;
            description = ''
              Lazy-load on colorscheme.
            '';
            example = "onedarker";
          };

          keys = nixvim.mkNullOrOption' {
            type = types.listOf types.anything;
            description = ''
              Lazy-load on key mapping. Mode is `n` by default.
            '';
            example = [
              "<C-a>"
              [
                "<C-x>"
                "g<C-x>"
              ]
              {
                __unkeyed-1 = "<leader>fb";
                __unkeyed-2 = "<CMD>Telescope buffers<CR>";
                desc = "Telescope buffers";
              }
              { __raw = "{ '<leader>ft', '<CMD>Neotree toggle<CR>', desc = 'NeoTree toggle' }"; }
            ];
          };
        };
      };
    in
    {
      plugins = mkOption {
        description = ''
          List of plugin specs provided to the `require('lz.n').load` function.
          Plugin specs can be ${types.rawLua.description}.
        '';
        default = [ ];
        type = types.listOf lzPluginType;
        example = [
          {
            __unkeyed-1 = "neo-tree.nvim";
            enabled = ''
              function()
              return true
              end
            '';
            keys = [
              {
                __unkeyed-1 = "<leader>ft";
                __unkeyed-2 = "<CMD>Neotree toggle<CR>";
                desc = "NeoTree toggle";
              }
            ];
            after = ''
              function()
                require("neo-tree").setup()
              end
            '';
          }
          {
            __unkeyed-1 = "telescope.nvim";
            cmd = [ "Telescope" ];
            keys = [
              {
                __unkeyed-1 = "<leader>fa";
                __unkeyed-2 = "<CMD>Telescope autocommands<CR>";
                desc = "Telescope autocommands";
              }
              {
                __unkeyed-1 = "<leader>fb";
                __unkeyed-2 = "<CMD>Telescope buffers<CR>";
                desc = "Telescope buffers";
              }
            ];
          }
          {
            __unkeyed-1 = "onedarker.nvim";
            colorscheme = [ "onedarker" ];
          }
          {
            __raw = ''
              {
                  "crates.nvim",
                  ft = "toml",
              },
            '';
          }
        ];
      };
    };

  extraConfig = cfg: {
    globals.lz_n = modules.mkAliasAndWrapDefsWithPriority id options.plugins.lz-n.settings;
    plugins.lz-n.luaConfig.content = mkIf (cfg.plugins != [ ]) ''
      require('lz.n').load( ${nixvim.toLuaObject cfg.plugins})
    '';
  };
}
