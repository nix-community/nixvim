{ config, pkgs, lib, ... }:
with lib;
let 
  cfg = config.programs.nixvim.plugins.which-key;
  helpers = import ../helpers.nix { inherit lib; };
  spelling = types.submodule {
    options = {
      enabled = mkOption {
        type = types.nullOr types.bool;
        description = "enabling this will show WhichKey when pressing z= to select spelling suggestions";
        default = null;
      };
      suggestions = mkOption {
        type = types.nullOr types.int;
        description = "how many suggestions should be shown in the list?";
        default = null;
      };
    };
  };
  presets = mkOption {
    type = types.submodule {
      options = {
        operators = mkOption {
          type = types.nullOr types.bool;
          description = "adds help for operators like d, y, ... and registers them for motion / text object
          completion";
          default = null;
        };
        motions = mkOption {
          type = types.nullOr types.bool;
          description = "adds help for motions";
          default = null;
        };
        textObjects = mkOption {
          type = types.nullOr types.bool;
          description = "help for text objects triggered after entering an operator";
          default = null;
        };
        windows = mkOption {
          type = types.nullOr types.bool;
          description = "default bindings on <c-w>";
          default = null;
        };
        nav = mkOption {
          type = types.nullOr types.bool;
          description = "misc bindings to work with windows";
          default = null;
        };
        z = mkOption {
          type = types.nullOr types.bool;
          description = "bindings for folds, spelling and others prefixed with z";
          default = null;
        };
        g = mkOption {
          type = types.nullOr types.bool;
          description = "bindings for things prefixed with g";
          default = null;
        };
      };
    };
  };
  size = mkOption {
    type = types.submodule {
      options = {
        min = mkOption {
          type = types.nullOr types.int;
          default = null;
        };
        max = mkOption {
          type = types.nullOr types.int;
          default = null;
        };
      };
    };
  };
in
{
  options = {
    programs.nixvim.plugins.which-key = {
      enable = mkEnableOption "Enable which-key";
      mappings = mkOption {
        type = types.anything;
        default = null;
      };
      mappingOptions = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            mode = mkOption {
              type = types.nullOr (types.str);
              default = null;
            };
            prefix = mkOption { 
              type = types.nullOr (types.str);
              description = "the prefix is prepended to every mapping part of 'mappings'";
              default = null;
            };
            silent = mkOption {
              type = types.nullOr (types.bool);
              description = "use 'silent' when creating keymaps";
              default = null;
            };
            noremap = mkOption {
              type = types.nullOr (types.bool);
              description = "use 'noremap' when creating keymaps";
              default = null;
            };
            nowait = mkOption {
              type = types.nullOr (types.bool);
              description = "use 'nowait' when creating keymaps";
              default = null;
            };
          };
        });
        default = null;
      };
      options = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            plugins = mkOption {
              type = types.nullOr (types.submodule {
                options = {
                  marks = mkOption {
                    type = types.nullOr types.bool;
                    description = "shows a list of your marks on ' and `";
                    default = null;
                  };
                  registers = mkOption {
                    type = types.nullOr types.bool;
                    description = "shows your registers on \" in NORMAL or <C-r> in INSERT mode";
                    default = null;
                  };
                  spelling = mkOption {
                    type = types.nullOr spelling;
                    default = null;
                  };
                  presets = mkOption {
                    type = types.nullOr presets;
                    default = null;
                  };
                };
              });
              default = null;
            };
            operators = mkOption {
              type = types.nullOr (types.submodule {
                options = {
                  gc = mkOption {
                    type = types.nullOr types.str;
                  };
                };
              });
              default = null;
            };
            keyLabels = mkOption {
              type = types.anything;
              description = "override the label used to display some keys. It doesn't effect which-key in any
              other way";
              default = null;
            };
            icons = mkOption {
              type = types.nullOr (types.submodule {
                options = {
                  breadcrumb = mkOption {
                    type = types.nullOr types.str;
                    description = "symbol used in the command line area that shows your active key combo";
                    default = null;
                  };
                  separator = mkOption {
                    type = types.nullOr types.str;
                    description = "symbol used between a key and it's label";
                    default = null;
                  };
                  group = mkOption {
                    type = types.nullOr types.str;
                    description = "symbol prepended to a group";
                    default = null;
                  };
                };
              });
              default = null;
            };
            popupMappings = mkOption {
              type = types.nullOr (types.submodule {
                options = {
                  scrollDown = mkOption {
                    type = types.nullOr types.str;
                    description = "binding to scroll down inside the popup";
                    default = null;
                  };
                  scrollUp = mkOption {
                    type = types.nullOr types.str;
                    description = "binding to scroll up inside the popup";
                    default = null;
                  };
                };
              });
              default = {};
            };
            window = mkOption {
              type = types.nullOr (types.submodule {
                options = {
                  border = mkOption {
                    type = types.nullOr (types.enum [ "none" "single" "double" "shadow" ]);
                    default = null;
                  };
                  position = mkOption {
                    type = types.nullOr (types.enum [ "bottom" "top" ]);
                    default = null;
                  };
                  margin = mkOption {
                    type = types.nullOr (types.listOf types.int);
                    description = "extra window margin [top, right, bottom, left]";
                    default = null;
                  };
                  padding = mkOption {
                    type = types.nullOr (types.listOf types.int);
                    description = "extra window padding [top, right, bottom, left]";
                    default = null;
                  };
                  winblend = mkOption {
                    type = types.nullOr types.int;
                    default = null;
                  };
                };
              });
              default = null;
            };
            layout = mkOption {
              type = types.nullOr (types.submodule {
                options = {
                  height = mkOption {
                    type = types.nullOr size;
                    description = "min and max height of the columns";
                    default = null;
                  };
                  width = mkOption {
                    type = types.nullOr size;
                    description = "min and max width of the columns";
                    default = null;
                  };
                  spacing = mkOption {
                    type = types.nullOr types.int;
                    description = "spacing between columns";
                    default = null;
                  };
                  align = mkOption {
                    type = types.nullOr (types.enum [ "left" "center" "right" ]);
                    default = null;
                  };
                };
              });
              default = null;
            };
            ignoreMissing = mkOption {
              type = types.nullOr types.bool;
              description = "enable this to hide mappings for which you didn't specify a label";
              default = null;
            };
            hidden = mkOption {
              type = types.nullOr (types.listOf types.str);
              description = "hide mapping boilerplate";
              default = null;
            };
            showHelp = mkOption {
              type = types.nullOr types.bool;
              description = "show help message on the command line when the popup is visible";
              default = null;
            };
            triggers = mkOption {
              type = types.nullOr (types.listOf types.str);
              description = "automatically setup triggers ('auto') or specify a list manually";
              default = null;
            };
          };
        });
        default = {};
      };
    };
  };

  config = let 
    setupOptions = with cfg.options; {
      plugins = plugins;
      operators = operators;
      key_labels = keyLabels;
      icons = icons;
      popup_mappings = {
        scroll_down = popupMappings.scrollDown;
        scroll_up = popupMappings.scrollUp;
      };
      window = window;
      layout = layout;
      ignore_missing = ignoreMissing;
      hidden = hidden;
      show_help = showHelp;
      triggers = triggers;
    };
    in mkIf cfg.enable {
    programs.nixvim = {
      extraPackages = with pkgs.vimPlugins; [ which-key-nvim ];
      extraConfigLua = ''
        local __which_key = require('which-key')
        __which_key.register(${helpers.toLuaObject(cfg.mappings)}, ${helpers.toLuaObject(cfg.mappingOptions)})
        __which_key.setup${helpers.toLuaObject(setupOptions)}
      '';
    };
  };
}
