lib:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
{
  smear_between_buffers = defaultNullOpts.mkBool true ''
    Smear cursor when switching buffers or windows.
  '';

  smear_between_neighbor_lines = defaultNullOpts.mkBool true ''
    Smear cursor when moving within line or to neighbor lines.
  '';

  smear_to_cmd = defaultNullOpts.mkBool true ''
    Smear cursor when entering or leaving command line mode.
  '';

  scroll_buffer_space = defaultNullOpts.mkBool true ''
    Draw the smear in buffer space instead of screen space when scrolling.
  '';

  legacy_computing_symbols_support = defaultNullOpts.mkBool false ''
    Set to `true` if your font supports legacy computing symbols (block unicode symbols).
    Smears will blend better on all backgrounds.
  '';

  vertical_bar_cursor = defaultNullOpts.mkBool false ''
    Set to `true` if your cursor is a vertical bar in normal mode.

    Use with `matrix_pixel_threshold = 0.3`
  '';

  hide_target_hack = defaultNullOpts.mkBool true ''
    Attempt to hide the real cursor by drawing a character below it.
  '';

  max_kept_windows = defaultNullOpts.mkUnsignedInt 50 ''
    Number of windows that stay open for rendering.
  '';

  windows_zindex = defaultNullOpts.mkUnsignedInt 300 ''
    Adjust to have the smear appear above or below other floating windows.
  '';

  filetypes_disabled = defaultNullOpts.mkListOf types.str [ ] ''
    List of filetypes where the plugin is disabled.
  '';

  time_interval = defaultNullOpts.mkUnsignedInt 17 ''
    Sets animation framerate (in milliseconds).
  '';

  delay_animation_start = defaultNullOpts.mkUnsignedInt 5 ''
    After changing target position, wait before triggering animation.

    Useful if the target changes and rapidly comes back to its original position.
    E.g. when hitting a keybinding that triggers `CmdlineEnter`.
    Increase if the cursor makes weird jumps when hitting keys.

    The value should be expressed in milliseconds.
  '';

  stiffness = defaultNullOpts.mkProportion 0.6 ''
    How fast the smear's head moves towards the target.

    `0`: no movement, `1`: instantaneous
  '';

  trailing_stiffness = defaultNullOpts.mkProportion 0.3 ''
    How fast the smear's tail moves towards the target.

    `0`: no movement, `1`: instantaneous
  '';

  trailing_exponent = defaultNullOpts.mkNum 2 ''
    Controls if middle points are closer to the head or the tail.

    `< 1`: closer to the tail, `> 1`: closer to the head
  '';

  slowdown_exponent = defaultNullOpts.mkNum 0 ''
    How much the smear slows down when getting close to the target.

    `< 0`: less slowdown, `> 0`: more slowdown. Keep small, e.g. `[-0.2, 0.2]`
  '';

  distance_stop_animating = defaultNullOpts.mkNum 0.1 ''
    Stop animating when the smear's tail is within this distance (in characters) from the target.
  '';

  max_slope_horizontal = defaultNullOpts.mkNum 0.5 ''
    When to switch between rasterization methods.
  '';

  min_slope_vertical = defaultNullOpts.mkNum 2 ''
    When to switch between rasterization methods.
  '';

  color_levels = defaultNullOpts.mkUnsignedInt 16 ''
    Minimum `1`, don't set manually if using `cterm_cursor_colors`.
  '';

  gamma = defaultNullOpts.mkFloat 2.2 ''
    For color blending.
  '';

  max_shade_no_matrix = defaultNullOpts.mkProportion 0.75 ''
    `0`: more overhangs, `1`: more matrices
  '';

  matrix_pixel_threshold = defaultNullOpts.mkProportion 0.7 ''
    `0`: all pixels, `1`: no pixel
  '';

  matrix_pixel_min_factor = defaultNullOpts.mkProportion 0.5 ''
    `0`: all pixels, `1`: no pixel
  '';

  volume_reduction_exponent = defaultNullOpts.mkProportion 0.3 ''
    `0`: no reduction, `1`: full reduction
  '';

  minimum_volume_factor = defaultNullOpts.mkProportion 0.7 ''
    `0`: no limit, `1`: no reduction
  '';

  max_length = defaultNullOpts.mkUnsignedInt 25 ''
    Maximum smear length.
  '';

  logging_level = defaultNullOpts.mkUnsignedInt (lib.nixvim.literalLua "vim.log.levels.INFO") ''
    Log level (for debugging purposes).

    Also set `trailing_stiffness` to `0` for debugging.
  '';
}
####################################################################################################
# Color configuration
####################################################################################################
// (
  let
    colorType = with types; either str ints.unsigned;
    mkColor = defaultNullOpts.mkNullable colorType;
  in
  {
    cursor_color = mkColor null ''
      Smear cursor color.

      Defaults to Cursor GUI color if not set.
      Set to `"none"` to match the text color at the target cursor position.
    '';

    normal_bg = mkColor null ''
      Background color.

      Defaults to Normal GUI background color if not set.
    '';

    transparent_bg_fallback_color = mkColor "303030" ''
      Set when the background is transparent and when not using legacy computing symbols.
    '';

    cterm_cursor_colors =
      defaultNullOpts.mkListOf colorType
        [
          240
          241
          242
          243
          244
          245
          246
          247
          248
          249
          250
          251
          252
          253
          254
          255
        ]
        ''
          Cterm color gradient, from bg color (excluded) to cursor color (included).
        '';

    cterm_bg = mkColor 235 ''
      Cterm background color.

      Must set when not using legacy computing symbols.
    '';
  }
)
