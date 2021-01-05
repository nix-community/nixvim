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

  helpers = import ./plugins/helpers.nix { lib = lib; };
in
{
  options = {
    programs.nixvim = {
      enable = mkEnableOption "enable NixVim";

      package = mkOption {
        type = types.package;
        default = pkgs.neovim;
        description = "The package to use for neovim.";
      };

      extraPlugins = mkOption {
        type = with types; listOf (either package pluginWithConfigType);
        default = [];
        description = "List of vim plugins to install.";
      };

      colorscheme = mkOption {
        type = types.str;
        description = "The name of the colorscheme";
      };

      extraConfigLua = mkOption {
        type = types.lines;
        default = "";
        description = "Extra contents for init.lua";
      };

      extraConfigVim = mkOption {
        type = types.lines;
        default = "";
        description = "Extra contents for init.vim";
      };

      configure = mkOption {
        type = types.attrsOf types.anything;
        default = { };
      };

      options = mkOption {
        type = types.attrsOf types.anything;
        default = { };
        description = "The configuration options, e.g. line numbers";
      };

      globals = mkOption {
        type = types.attrsOf types.anything;
        default = {};
        description = "Global variables";
      };
    };
  };

  imports = [
    ./plugins
  ];

  config = let
    neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
      configure = cfg.configure;
      plugins = cfg.extraPlugins;

      withPython2 = false;
      withPython3 = false;
      withNodeJs = false;
      withRuby = false;
    };

    wrappedNeovim = pkgs.wrapNeovimUnstable cfg.package (neovimConfig // {
      wrapperArgs = lib.escapeShellArgs neovimConfig.wrapperArgs;
    });
  in mkIf cfg.enable {
    environment.systemPackages = [ wrappedNeovim ];
    programs.nixvim = {
      configure = {
        customRC = ''
          lua <<EOF
          ${cfg.extraConfigLua}
          EOF
        '' + cfg.extraConfigVim + (optionalString (cfg.colorscheme != "") ''

          colorscheme ${cfg.colorscheme}
        '');
        packages.nixvim = {
          start = filter (f: f != null) (map (x:
            if x ? plugin && x.optional == true then null else (x.plugin or x))
            cfg.extraPlugins);
          opt = filter (f: f!= null)
            (map (x: if x ? plugin && x.optional == true then x.plugin else null)
              cfg.extraPlugins);
        };
      };

      extraConfigLua = optionalString (cfg.globals != {}) ''
        -- Set up globals {{{
        local __nixvim_globals = ${helpers.toLuaObject cfg.globals}

        for k,v in pairs(__nixvim_globals) do
          vim.g[k] = v
        end
        -- }}}
      '' + optionalString (cfg.options != {}) ''
        -- Set up options {{{
        local __nixvim_options = ${helpers.toLuaObject cfg.options}

        for k,v in pairs(__nixvim_options) do
          -- Here we use the set command because, as of right now, neovim has
          -- no equivalent using the lua API. You have to sort through the
          -- options and know which options are local to what
          if type(v) == "boolean" then
            local no
            if v then no = "" else no = "no" end

            vim.cmd("set " .. no .. k)
          else
            vim.cmd("set " .. k .. "=" .. tostring(v))
          end
        end
        -- }}}
      '';
    };

    environment.etc."xdg/nvim/sysinit.vim".text = neovimConfig.neovimRcContent;
  };
}
