{ pkgs, config, lib, ... }:
with lib;
let
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
in
{
  options = {
    package = mkOption {
      type = types.package;
      default = pkgs.neovim-unwrapped;
      description = "Neovim to use for nixvim";
    };

    extraPlugins = mkOption {
      type = with types; listOf (either package pluginWithConfigType);
      default = [ ];
      description = "List of vim plugins to install";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Extra packages to be made available to neovim";
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

    output = mkOption {
      type = types.package;
      description = "Final package built by nixvim";
      readOnly = true;
      visible = false;
    };
  };

  config =
    let
      configure = {
        customRC = config.extraConfigVim + (optionalString (config.extraConfigLua != "") ''
          lua <<EOF
          ${config.extraConfigLua}
          EOF
        '');

        packages.nixvim = {
          start = filter (f: f != null) (map
            (x:
              if x ? plugin && x.optional == true then null else (x.plugin or x))
            config.extraPlugins);
          opt = filter (f: f != null)
            (map (x: if x ? plugin && x.optional == true then x.plugin else null)
              config.extraPlugins);
        };
      };

      neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
        inherit configure;
        plugins = [ ];
      };

      extraWrapperArgs = optionalString (config.extraPackages != [ ])
        ''--prefix PATH : "${makeBinPath config.extraPackages}"'';

      wrappedNeovim = pkgs.wrapNeovimUnstable config.package (neovimConfig // {
        wrapperArgs = lib.escapeShellArgs neovimConfig.wrapperArgs + " " + extraWrapperArgs;
      });
    in
    {
      output = wrappedNeovim;
    };
}
