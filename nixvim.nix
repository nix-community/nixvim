{ nixos ? false, nixOnDroid ? false, homeManager ? false }:
{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.programs.nixvim;

  pluginWithConfigType = types.submodule {
    options = {
      config = mkOption {
        type = types.lines;
        description = "vimscript for this plugin to be placed in init.vim";
        default = "";
      };

      optional = mkEnableOption "optional" // {
        description = "Don't load by default (load with :packadd)";
      };

      plugin = mkOption {
        type = types.package;
        description = "vim plugin";
      };
    };
  };

  mapOption = types.oneOf [
    types.str
    (types.submodule {
      options = {
        silent = mkOption {
          type = types.bool;
          description = "Whether this mapping should be silent. Equivalent to adding <silent> to a map.";
          default = false;
        };

        nowait = mkOption {
          type = types.bool;
          description = "Whether to wait for extra input on ambiguous mappings. Equivalent to adding <nowait> to a map.";
          default = false;
        };

        script = mkOption {
          type = types.bool;
          description = "Equivalent to adding <script> to a map.";
          default = false;
        };

        expr = mkOption {
          type = types.bool;
          description = "Means that the action is actually an expression. Equivalent to adding <expr> to a map.";
          default = false;
        };

        unique = mkOption {
          type = types.bool;
          description = "Whether to fail if the map is already defined. Equivalent to adding <unique> to a map.";
          default = false;
        };

        noremap = mkOption {
          type = types.bool;
          description = "Whether to use the 'noremap' variant of the command, ignoring any custom mappings on the defined action. It is highly advised to keep this on, which is the default.";
          default = true;
        };

        action = mkOption {
          type = types.str;
          description = "The action to execute.";
        };

        description = mkOption {
          type = types.nullOr types.str;
          description = "A textual description of this keybind, to be shown in which-key, if you have it.";
          default = null;
        };
      };
    })
  ];

  mapOptions = mode: mkOption {
    description = "Mappings for ${mode} mode";
    type = types.attrsOf mapOption;
    default = { };
  };

  helpers = import ./plugins/helpers.nix { lib = lib; };
in
{
  options = {
    programs.nixvim = {
      enable = mkEnableOption "enable NixVim";

      package = mkOption {
        type = types.nullOr types.package;
        default = null;
        description = "The package to use for neovim.";
      };

      extraPlugins = mkOption {
        type = with types; listOf (either package pluginWithConfigType);
        default = [ ];
        description = "List of vim plugins to install.";
      };

      colorscheme = mkOption {
        type = types.nullOr types.str;
        description = "The name of the colorscheme";
        default = null;
      };

      extraConfigLua = mkOption {
        type = types.lines;
        default = "";
        description = "Extra contents for init.lua";
      };

      extraLuaPreConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Extra contents for init.lua before everything else";
      };

      extraLuaPostConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Extra contents for init.lua after everything else";
      };

      extraConfigVim = mkOption {
        type = types.lines;
        default = "";
        description = "Extra contents for init.vim";
      };

      extraPackages = mkOption {
        type = types.listOf types.package;
        default = [ ];
        example = "[ pkgs.shfmt ]";
        description = "Extra packages to be made available to neovim";
      };

      configure = mkOption {
        type = types.attrsOf types.anything;
        default = { };
        description = "Internal option";
      };

      options = mkOption {
        type = types.attrsOf types.anything;
        default = { };
        description = "The configuration options, e.g. line numbers";
      };

      globals = mkOption {
        type = types.attrsOf types.anything;
        default = { };
        description = "Global variables";
      };

      maps = mkOption {
        type = types.submodule {
          options = {
            normal = mapOptions "normal";
            insert = mapOptions "insert";
            select = mapOptions "select";
            visual = mapOptions "visual and select";
            terminal = mapOptions "terminal";
            normalVisualOp = mapOptions "normal, visual, select and operator-pending (same as plain 'map')";

            visualOnly = mapOptions "visual only";
            operator = mapOptions "operator-pending";
            insertCommand = mapOptions "insert and command-line";
            lang = mapOptions "insert, command-line and lang-arg";
            command = mapOptions "command-line";
          };
        };
        default = { };
        description = ''
          Custom keybindings for any mode.

          For plain maps (e.g. just 'map' or 'remap') use maps.normalVisualOp.
        '';

        example = ''
          maps = {
            normalVisualOp.";" = ":"; # Same as noremap ; :
            normal."<leader>m" = {
              silent = true;
              action = "<cmd>make<CR>";
            }; # Same as nnoremap <leader>m <silent> <cmd>make<CR>
          };
        '';
      };
    };
  };

  imports = [
    ./plugins
  ];

  config =
    let
      neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
        configure = cfg.configure;
        plugins = cfg.extraPlugins;
      };

      extraWrapperArgs = optionalString (cfg.extraPackages != [ ])
        ''--prefix PATH : "${makeBinPath cfg.extraPackages}"'';

      package = if (cfg.package != null) then cfg.package else pkgs.neovim;

      wrappedNeovim = pkgs.wrapNeovimUnstable package (neovimConfig // {
        wrapperArgs = lib.escapeShellArgs neovimConfig.wrapperArgs + " "
          + extraWrapperArgs;
      });

      luaGlobals = optionalString (cfg.globals != { }) ''
        -- Set up globals {{{
        local __nixvim_globals = ${helpers.toLuaObject cfg.globals}

        for k,v in pairs(__nixvim_globals) do
          vim.g[k] = v
        end
        -- }}}
      '' + optionalString (cfg.options != { }) ''
        -- Set up options {{{
        local __nixvim_options = ${helpers.toLuaObject cfg.options}

        for k,v in pairs(__nixvim_options) do
          vim.o[k] = v
        end
        -- }}}
      '' + optionalString (mappings != [ ]) ''
        -- Set up keybinds {{{
        local __nixvim_binds = ${helpers.toLuaObject mappings}

        for i, map in ipairs(__nixvim_binds) do
          vim.api.nvim_set_keymap(map.mode, map.key, map.action, map.config)
        end
        -- }}}
      '';

      configure = {
        # Make sure that globals are set before plugins are setup.
        # This is becuase you might want to define variables or global functions
        # that the plugin configuration depend upon.
        customRC = cfg.extraConfigVim + ''
          lua <<EOF
          ${cfg.extraLuaPreConfig}
          ${luaGlobals}
          ${cfg.extraConfigLua}
        '' +
        # Set colorscheme after setting globals.
        # Some colorschemes depends on variables being set before setting the colorscheme.
        (optionalString (cfg.colorscheme != "" && cfg.colorscheme != null) ''
          vim.cmd([[colorscheme ${cfg.colorscheme}]])
        '') +
        ''
        ${cfg.extraLuaPostConfig}
        EOF
        '';

        packages.nixvim = {
          start = filter (f: f != null) (map
            (x:
              if x ? plugin && x.optional == true then null else (x.plugin or x))
            cfg.extraPlugins);
          opt = filter (f: f != null)
            (map (x: if x ? plugin && x.optional == true then x.plugin else null)
              cfg.extraPlugins);
        };
      };

      mappings =
        (helpers.genMaps "" cfg.maps.normalVisualOp) ++
        (helpers.genMaps "n" cfg.maps.normal) ++
        (helpers.genMaps "i" cfg.maps.insert) ++
        (helpers.genMaps "v" cfg.maps.visual) ++
        (helpers.genMaps "x" cfg.maps.visualOnly) ++
        (helpers.genMaps "s" cfg.maps.select) ++
        (helpers.genMaps "t" cfg.maps.terminal) ++
        (helpers.genMaps "o" cfg.maps.operator) ++
        (helpers.genMaps "l" cfg.maps.lang) ++
        (helpers.genMaps "!" cfg.maps.insertCommand) ++
        (helpers.genMaps "c" cfg.maps.command);

    in
    mkIf cfg.enable (if nixos then {
      environment.systemPackages = [ wrappedNeovim ];
      programs.neovim = {
        configure = configure;
      };

      environment.etc."xdg/nvim/sysinit.vim".text = neovimConfig.neovimRcContent;
    } else
      (if homeManager then {
        programs.neovim = {
          enable = true;
          package = mkIf (cfg.package != null) cfg.package;
          extraPackages = cfg.extraPackages;
          extraConfig = configure.customRC;
          plugins = cfg.extraPlugins;
        };
      } else { }));
}
