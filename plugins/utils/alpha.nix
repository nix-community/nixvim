{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.alpha;

  helpers = import ../helpers.nix {inherit lib;};

  sectionType = types.enum ["group" "padding" "text"];

  mkAlphaSectionOption = type:
    types.submodule {
      options = {
        type = mkOption {
          inherit type;
          description = "Type of section";
        };

        val = mkOption {
          type = with types;
            oneOf [
              (either str int)
              (listOf (
                either
                str
                (submodule {
                  options = {
                    shortcut = helpers.mkNullOrOption str "Shortcut for keymap";
                    desc = helpers.mkNullOrOption str "Description to display for keymap";
                    command = helpers.mkNullOrOption str "Command to run for keymap";
                  };
                })
              ))
            ];
          default = null;
          description = "Value for section";
        };

        opts = mkOption {
          type = types.submodule {
            options = {
              spacing = mkOption {
                type = types.int;
                default = 0;
                description = "Spacing between grouped components";
              };

              hl = mkOption {
                type = types.str;
                default = "Keyword";
                description = "HighlightGroup to apply";
              };

              position = mkOption {
                type = types.str;
                default = "center";
                description = "How to align section";
              };

              margin = mkOption {
                type = types.int;
                default = 0;
                description = "Margin for section";
              };
            };
          };
          default = {};
          description = "Additional options for the section";
        };
      };
    };
in {
  options = {
    plugins.alpha = {
      enable = mkEnableOption "alpha";

      package = helpers.mkPackageOption "alpha" pkgs.vimPlugins.alpha-nvim;

      iconsEnabled = mkOption {
        type = types.bool;
        description = "Toggle icon support. Installs nvim-web-devicons.";
        default = true;
      };

      layout = with helpers;
        mkOption {
          default = [
            {
              type = "padding";
              val = 2;
            }
            {
              type = "text";
              val = [
                "  ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗  "
                "  ████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║  "
                "  ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║  "
                "  ██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║  "
                "  ██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║  "
                "  ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝  "
              ];
              opts = {
                position = "center";
                hl = "Type";
              };
            }
            {
              type = "padding";
              val = 2;
            }
            {
              type = "group";
              val = [
                {
                  shortcut = "e";
                  desc = "  New file";
                  command = "<CMD>ene <CR>";
                }
                {
                  shortcut = "SPC q";
                  desc = "  Quit Neovim";
                  command = ":qa<CR>";
                }
              ];
            }
            {
              type = "padding";
              val = 2;
            }
            {
              type = "text";
              val = "Inspiring quote here.";
              opts = {
                position = "center";
                hl = "Keyword";
              };
            }
          ];
          description = "List of sections to layout for the dashboard";
          type = types.listOf (mkAlphaSectionOption sectionType);
        };
    };
  };

  config = with helpers; let
    processButton = button: let
      stringifyButton = button: ''button("${button.shortcut}", "${button.desc}", "${button.command}")'';
    in
      mkRaw (stringifyButton button);

    processButtons = attrset:
      if attrset.type == "group"
      then attrset // {val = builtins.map processButton attrset.val;}
      else attrset;

    options = {
      inherit (cfg) theme iconsEnabled;
      layout = builtins.map processButtons cfg.layout;
    };
  in
    mkIf cfg.enable {
      extraPlugins =
        [
          cfg.package
        ]
        ++ (optional cfg.iconsEnabled pkgs.vimPlugins.nvim-web-devicons);
      extraConfigLua = ''
        local leader = "SPC"
        --- @param sc string
        --- @param txt string
        --- @param keybind string? optional
        --- @param keybind_opts table? optional
        local function button(sc, txt, keybind, keybind_opts)
            local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

            local opts = {
                position = "center",
                shortcut = sc,
                cursor = 3,
                width = 50,
                align_shortcut = "right",
                hl_shortcut = "Keyword",
            }
            if keybind then
                keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
                opts.keymap = { "n", sc_, keybind, keybind_opts }
            end

            local function on_press()
                local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. "<Ignore>", true, false, true)
                vim.api.nvim_feedkeys(key, "t", false)
            end

            return {
                type = "button",
                val = txt,
                on_press = on_press,
                opts = opts,
            }
        end

        local config = {
          layout = ${toLuaObject options.layout},
          opts = {
            margin = 5,
          },
        }
        require('alpha').setup(config)
      '';
    };
}
