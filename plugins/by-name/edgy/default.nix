{
  lib,
  helpers,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin {
  name = "edgy";
  originalName = "edgy.nvim";
  package = "edgy-nvim";

  maintainers = [ maintainers.GaetanLepage ];

  extraConfig = cfg: {
    # Those options are strongly recommended by the plugin author:
    # https://github.com/folke/edgy.nvim?tab=readme-ov-file#-installation
    opts = {
      laststatus = mkDefault 3;
      splitkeep = mkDefault "screen";
    };
  };

  settingsOptions =
    let
      viewOpts = {
        ft = helpers.mkNullOrStr ''
          File type of the view.
        '';

        filter = helpers.mkNullOrLuaFn ''
          Optional function to filter buffers and windows.

          `fun(buf:buffer, win:window)`
        '';

        title = helpers.mkNullOrStr ''
          Optional title of the view.
          Defaults to the capitalized filetype.
        '';

        size = helpers.mkNullOrOption types.ints.unsigned ''
          Size of the short edge of the edgebar.
          For edgebars, this is the minimum width.
          For panels, minimum height.
        '';

        pinned = helpers.mkNullOrOption types.bool ''
          If true, the view will always be shown in the edgebar even when it has no windows.
        '';

        open = helpers.mkNullOrStr ''
          Function or command to open a pinned view.
        '';

        wo = helpers.mkNullOrOption (with types; attrsOf anything) ''
          View-specific window options.
        '';
      };

      mkViewOptsOption =
        name:
        helpers.defaultNullOpts.mkListOf (
          with types;
          either str (submodule {
            options = viewOpts;
          })
        ) [ ] "List of the ${name} edgebar configurations.";
    in
    {
      left = mkViewOptsOption "left";
      bottom = mkViewOptsOption "bottom";
      right = mkViewOptsOption "right";
      top = mkViewOptsOption "top";

      options =
        mapAttrs
          (_: defaultSize: {
            size = helpers.defaultNullOpts.mkUnsignedInt defaultSize ''
              Size of the short edge of the edgebar.
              For edgebars, this is the minimum width.
              For panels, minimum height.
            '';

            wo = helpers.mkNullOrOption (with types; attrsOf anything) ''
              View-specific window options.
            '';
          })
          {
            left = 30;
            bottom = 10;
            right = 30;
            top = 10;
          };

      animate = {
        enabled = helpers.defaultNullOpts.mkBool true ''
          Whether to enable animations.
        '';

        fps = helpers.defaultNullOpts.mkUnsignedInt 100 ''
          Frames per second.
        '';

        cps = helpers.defaultNullOpts.mkUnsignedInt 120 ''
          Cells per second.
        '';

        on_begin = helpers.defaultNullOpts.mkLuaFn ''
          function()
            vim.g.minianimate_disable = true
          end
        '' "Callback for the beginning of animations.";

        on_end = helpers.defaultNullOpts.mkLuaFn ''
          function()
            vim.g.minianimate_disable = false
          end
        '' "Callback for the ending of animations.";

        # This option accepts an attrs or a lua string.
        # Hence, we convert the string to raw lua in `apply`.
        spinner =
          let
            defaultFrames = [
              "⠋"
              "⠙"
              "⠹"
              "⠸"
              "⠼"
              "⠴"
              "⠦"
              "⠧"
              "⠇"
              "⠏"
            ];
          in
          helpers.mkNullOrOption' {
            type =
              with lib.types;
              either strLua (submodule {
                freeformType = attrsOf anything;
                options = {
                  frames = helpers.defaultNullOpts.mkListOf types.str defaultFrames ''
                    Frame characters.
                  '';

                  interval = helpers.defaultNullOpts.mkUnsignedInt 80 ''
                    Interval time between two consecutive frames.
                  '';
                };
              });
            default = null;
            example = "require('noice.util.spinners').spinners.circleFull";
            apply = v: if isString v then helpers.mkRaw v else v;
            description = "Spinner for pinned views that are loading.";
            pluginDefault = {
              frames = defaultFrames;
              interval = 80;
            };
          };
      };

      exit_when_last = helpers.defaultNullOpts.mkBool false ''
        Enable this to exit Neovim when only edgy windows are left.
      '';

      close_when_all_hidden = helpers.defaultNullOpts.mkBool true ''
        Close edgy when all windows are hidden instead of opening one of them.
        Disable to always keep at least one edgy split visible in each open section.
      '';

      wo = helpers.defaultNullOpts.mkAttrsOf types.anything {
        winbar = true;
        winfixwidth = true;
        winfixheight = false;
        winhighlight = "WinBar:EdgyWinBar,Normal:EdgyNormal";
        spell = false;
        signcolumn = "no";
      } "Global window options for edgebar windows.";

      # This option accepts an attrs or a lua string.
      # Hence, we convert the string to raw lua in `apply`.
      keys = helpers.defaultNullOpts.mkAttrsOf' {
        type = with lib.types; either strLuaFn (enum [ false ]);
        apply = x: if x == null then null else mapAttrs (_: v: if isString v then helpers.mkRaw v else v) x;
        description = ''
          Buffer-local keymaps to be added to edgebar buffers.
          Existing buffer-local keymaps will never be overridden.

          Each value is either:
          - A function declaration (as a raw lua string)
            -> `fun(win:Edgy.Window)`
          - `false` to disable this mapping.
        '';
        pluginDefault = {
          q = ''
            function(win)
              win:close()
            end
          '';
          "<c-q>" = ''
            function(win)
              win:hide()
            end
          '';
          Q = ''
            function(win)
              win.view.edgebar:close()
            end
          '';
          "]w" = ''
            function(win)
              win:next({ visible = true, focus = true })
            end
          '';
          "[w" = ''
            function(win)
              win:prev({ visible = true, focus = true })
            end
          '';
          "]W" = ''
            function(win)
              win:next({ pinned = false, focus = true })
            end
          '';
          "[W" = ''
            function(win)
              win:prev({ pinned = false, focus = true })
            end
          '';
          "<c-w>>" = ''
            function(win)
              win:resize("width", 2)
            end
          '';
          "<c-w><lt>" = ''
            function(win)
              win:resize("width", -2)
            end
          '';
          "<c-w>+" = ''
            function(win)
              win:resize("height", 2)
            end
          '';
          "<c-w>-" = ''
            function(win)
              win:resize("height", -2)
            end
          '';
          "<c-w>=" = ''
            function(win)
              win.view.edgebar:equalize()
            end
          '';
        };
      };

      icons = {
        closed = helpers.defaultNullOpts.mkStr " " ''
          Icon for closed edgebars.
        '';

        open = helpers.defaultNullOpts.mkStr " " ''
          Icon for opened edgebars.
        '';
      };
    };

  settingsExample = {
    animate.enabled = false;
    wo = {
      winbar = false;
      winfixwidth = false;
      winfixheight = false;
      winhighlight = "";
      spell = false;
      signcolumn = "no";
    };
    bottom = [
      {
        ft = "toggleterm";
        size = 30;
        filter = ''
          function(buf, win)
            return vim.api.nvim_win_get_config(win).relative == ""
          end
        '';
      }
      {
        ft = "help";
        size = 20;
        filter = ''
          function(buf)
            return vim.bo[buf].buftype == "help"
          end
        '';
      }
    ];
    left = [
      {
        title = "nvimtree";
        ft = "NvimTree";
        size = 30;
      }
      {
        ft = "Outline";
        open = "SymbolsOutline";
      }
      { ft = "dapui_scopes"; }
      { ft = "dapui_breakpoints"; }
      { ft = "dap-repl"; }
    ];
  };
}
