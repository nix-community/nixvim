{
  lib,
  pkgs,
  ...
} @ args:
with lib;
with import ../helpers.nix {inherit lib;};
  mkPlugin args {
    name = "molten";
    description = "molten-nvim";
    package = pkgs.vimPlugins.molten-nvim;
    globalPrefix = "molten_";

    options = {
      autoOpenOutput = mkDefaultOpt {
        global = "auto_open_output";
        description = ''
          Automatically open the output window when your cursor moves over a cell.

          Default: `true`
        '';
        type = types.bool;
        example = false;
      };

      copyOutput = mkDefaultOpt {
        global = "copy_output";
        description = ''
          Copy evaluation output to clipboard automatically (requires pyperclip).

          Default: `false`
        '';
        type = types.bool;
        example = true;
      };

      enterOutputBehavior = mkDefaultOpt {
        global = "enter_output_behavior";
        description = ''
          The behavior of MoltenEnterOutput.

          Default: `"open_then_enter"`
        '';
        type = types.enum ["open_then_enter" "open_and_enter" "no_open"];
      };

      imageProvider = mkDefaultOpt {
        global = "image_provider";
        description = ''
          How images are displayed.

          Default: `"none"`
        '';
        type = types.enum ["none" "image_nvim"];
      };

      outputCropBorder = mkDefaultOpt {
        global = "output_crop_border";
        description = ''
          'crops' the bottom border of the output window when it would otherwise just sit at the
          bottom of the screen.

          Default: `true`
        '';
        type = types.bool;
      };

      outputShowMore = mkDefaultOpt {
        global = "output_show_more";
        description = ''
          When the window can't display the entire contents of the output buffer, shows the number
          of extra lines in the window footer (requires nvim 10.0+ and a window border).

          Default: `false`
        '';
        type = types.bool;
      };

      outputVirtLines = mkDefaultOpt {
        global = "output_virt_lines";
        description = ''
          Pad the main buffer with virtual lines so the output doesn't cover anything while it's
          open.

          Default: `false`
        '';
        type = types.bool;
      };

      outputWinBorder = mkDefaultOpt {
        global = "output_win_border";
        description = ''
          Some border features will not work if you don't specify your border as a table.
          See border option of `:h nvim_open_win()`.

          Default: `["" "━" "" ""]`
        '';
        type = nixvimTypes.border;
      };

      outputWinCoverGutter = mkDefaultOpt {
        global = "output_win_cover_gutter";
        description = ''
          Should the output window cover the gutter (numbers and sign col), or not.
          If you change this, you probably also want to change `outputWinStyle`.

          Default: `true`
        '';
        type = types.bool;
      };

      outputWinHideOnLeave = mkDefaultOpt {
        global = "output_win_hide_on_leave";
        description = ''
          After leaving the output window (via `:q` or switching windows), do not attempt to redraw
          the output window.

          Default: `true`
        '';
        type = types.bool;
      };

      outputWinMaxHeight = mkDefaultOpt {
        global = "output_win_max_height";
        description = ''
          Max height of the output window.

          Default: `999999`
        '';
        type = types.ints.unsigned;
      };

      outputWinMaxWidth = mkDefaultOpt {
        global = "output_win_max_width";
        description = ''
          Max width of the output window.

          Default: `999999`
        '';
        type = types.ints.unsigned;
      };

      outputWinStyle = mkDefaultOpt {
        global = "output_win_style";
        description = ''
          Value passed to the `style` option in `:h nvim_open_win()`

          Default: `false`
        '';
        type = types.enum [false "minimal"];
      };

      savePath = mkDefaultOpt {
        global = "save_path";
        description = ''
          Where to save/load data with `:MoltenSave` and `:MoltenLoad`.

          Default: `{__raw = "vim.fn.stdpath('data')..'/molten'";}`
        '';
        type = with nixvimTypes; either str rawLua;
      };

      useBorderHighlights = mkDefaultOpt {
        global = "use_border_highlights";
        description = ''
          When true, uses different highlights for output border depending on the state of the cell
          (running, done, error).
          See [highlights](https://github.com/benlubas/molten-nvim#highlights).

          Default: `false`
        '';
        type = types.bool;
      };

      virtLinesOffBy1 = mkDefaultOpt {
        global = "virt_lines_off_by_1";
        description = ''
          _Only has effect when `outputVirtLines` is true._
          Allows the output window to cover exactly one line of the regular buffer.
          (useful for running code in a markdown file where that covered line will just be ```)

          Default: `false`
        '';
        type = types.bool;
      };

      wrapOutput = mkDefaultOpt {
        global = "wrap_output";
        description = ''
          Wrap text in output windows.

          Default: `false`
        '';
        type = types.bool;
      };

      # Debug
      showMimetypeDebug = mkDefaultOpt {
        global = "show_mimetype_debug";
        description = ''
          Before any non-iostream output chunk, the mime-type for that output chunk is shown.
          Meant for debugging/plugin devlopment.

          Default: `false`
        '';
        type = types.bool;
      };
    };
  }
