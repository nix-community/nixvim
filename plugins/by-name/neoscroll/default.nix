{
  lib,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "neoscroll";
  package = "neoscroll-nvim";
  description = "Smooth scrolling neovim plugin.";

  maintainers = [ maintainers.GaetanLepage ];

  settingsOptions = {
    mappings =
      lib.nixvim.defaultNullOpts.mkListOf types.str
        [
          "<C-u>"
          "<C-d>"
          "<C-b>"
          "<C-f>"
          "<C-y>"
          "<C-e>"
          "zt"
          "zz"
          "zb"
        ]
        ''
          All the keys defined in this option will be mapped to their corresponding default
          scrolling animation. To no map any key pass an empty table:
          ```nix
            mappings.__empty = null;
          ```
        '';

    hide_cursor = lib.nixvim.defaultNullOpts.mkBool true ''
      If 'termguicolors' is set, hide the cursor while scrolling.
    '';

    step_eof = lib.nixvim.defaultNullOpts.mkBool true ''
      When `move_cursor` is `true` scrolling downwards will stop when the bottom line of the
      window is the last line of the file.
    '';

    respect_scrolloff = lib.nixvim.defaultNullOpts.mkBool false ''
      The cursor stops at the scrolloff margin.
      Try combining this option with either `stop_eof` or `cursor_scrolls_alone` (or both).
    '';

    cursor_scrolls_alone = lib.nixvim.defaultNullOpts.mkBool true ''
      The cursor will keep on scrolling even if the window cannot scroll further.
    '';

    easing_function = lib.nixvim.mkNullOrStr ''
      Name of the easing function to use by default in all scrolling animamtions.
      `scroll()` that don't provide the optional `easing` argument will use this easing
      function.
      If set to `null` (the default) no easing function will be used in the scrolling animation
      (constant scrolling speed).
    '';

    pre_hook = lib.nixvim.mkNullOrLuaFn ''
      Function to run before the scrolling animation starts.
      The function will be called with the `info` parameter which can be optionally passed to
      `scroll()` (or any of the provided wrappers).
      This can be used to conditionally run different hooks for different types of scrolling
      animations.
    '';

    post_hook = lib.nixvim.mkNullOrLuaFn ''
      Equivalent to `pre_hook` but the function will run after the scrolling animation ends.
    '';

    performance_mode = lib.nixvim.defaultNullOpts.mkBool false ''
      Option to enable "Performance Mode" on all buffers.
    '';
  };

  settingsExample = {
    mappings = [
      "<C-u>"
      "<C-d>"
      "<C-b>"
      "<C-f>"
      "<C-y>"
      "<C-e>"
      "zt"
      "zz"
      "zb"
    ];
    hide_cursor = true;
    stop_eof = true;
    respect_scrolloff = false;
    cursor_scrolls_alone = true;
    easing_function = "quadratic";
  };
}
