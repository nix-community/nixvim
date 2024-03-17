{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  # TODO: Introduced 2024-03-19, remove on 2024-05-19
  deprecations = let
    pluginPath = ["plugins" "tmux-navigator"];
    option = s: pluginPath ++ [s];
    setting = s: pluginPath ++ ["settings" s];
    settingStr = s: concatStringsSep "." (setting s);
  in [
    (
      mkRenamedOptionModule
      (option "tmuxNavigatorSaveOnSwitch")
      (setting "save_on_switch")
    )
    (
      mkRemovedOptionModule
      (option "tmuxNavigatorDisableWhenZoomed")
      "Use `${settingStr "disable_when_zoomed"}` option."
    )
    (
      mkRemovedOptionModule
      (option "tmuxNavigatorNoWrap")
      "Use `${settingStr "no_wrap"}` option."
    )
  ];

  # All `:TmuxNavigate*` commands
  commands = [
    "left"
    "down"
    "up"
    "right"
    "previous"
  ];

  # Define a submodule so we get docs and enum type-safety for `action`
  # FIXME: Do we really want _all_ of `mapConfigOptions` here?
  #    Should we consider filtering it? Etc?
  keymapOptions = {
    options =
      (recursiveUpdate helpers.keymaps.mapConfigOptions (mapAttrs (n: v: {${n}.default = v;}) defaultOptions))
      // {
        action = mkOption {
          type = types.enum commands;
          description = "The `TmuxNavigate*` command. One of ${toString commands}.";
          example = head commands;
        };
      };
  };

  defaultOptions = {
    silent = true;
  };

  normaliseKeymap = key: cmd: let
    attrs =
      if isAttrs cmd
      then cmd
      else {action = cmd;};
    action = "<cmd>TmuxNavigate${helpers.upperFirstChar attrs.action}<cr>";
    options = defaultOptions // (filterAttrs (n: v: n != "action" && v != null) attrs);
  in {inherit key action options;};

  keymapConfig = {
    keymaps = mapAttrsToList normaliseKeymap config.plugins.tmux-navigator.keymaps;
  };
in
  helpers.vim-plugin.mkVimPlugin config {
    # FIXME document tmux-side installation instructions
    name = "tmux-navigator";
    originalName = "vim-tmux-navigator";
    defaultPackage = pkgs.vimPlugins.tmux-navigator;
    globalPrefix = "tmux_navigator_";

    maintainers = [maintainers.GaetanLepage];

    imports = deprecations ++ [keymapConfig];

    extraOptions = {
      # FIXME should this be attrsOf enum or
      # enumerated options of (either str (listOf (either str submodule)))?
      # e.g. keymaps.left = "<C-w>h";
      #      keymaps.right = ["<C-w>l" "<C-l>"];
      #      keymaps.up = ["<C-w>k" {key = "<C-k>";}];
      # I guess this would need a custom merge function?
      keymaps = mkOption {
        type = with types;
          attrsOf (oneOf [
            (enum commands)
            (submodule keymapOptions)
          ]);
        description = ''
          Keymaps for the various `:TmuxNavigator*` commands.
        '';
        example = {
          "<C-w>h" = "left";
          "<C-w>j" = "down";
          "<C-w>k" = "up";
          "<C-w>l" = "right";
          "<C-w>\\" = {
            action = "previous";
            desc = "Move to the previous pane";
          };
        };
        default = {};
      };
    };

    settingsOptions = {
      save_on_switch = helpers.mkNullOrOption (types.enum [1 2]) ''
        You can configure the plugin to write the current buffer, or all buffers, when navigating from vim to tmux.

        null: don't save on switch (default value)
        1: `:update` (write the current buffer, but only if changed)
        2: `:wall` (write all buffers)
      '';

      disable_when_zoomed = helpers.defaultNullOpts.mkBool false ''
        By default, if you zoom the tmux pane running vim and then attempt to navigate "past" the edge of the vim session, tmux will unzoom the pane.
        This is the default tmux behavior, but may be confusing if you've become accustomed to navigation "wrapping" around the sides due to this plugin.

        This option disables the unzooming behavior, keeping all navigation within vim until the tmux pane is explicitly unzoomed.
      '';

      preserve_zoom = helpers.defaultNullOpts.mkBool false ''
        As noted in `disable_when_zoomed`, navigating from a vim pane to another tmux pane normally causes the window to be unzoomed.
        Some users may prefer the behavior of tmux's `-Z` option to `select-pane`, which keeps the window zoomed if it was zoomed.

        This option enables that behavior.

        Naturally, if `disable_when_zoomed` is enabled, this option will have no effect.
      '';

      no_wrap = helpers.defaultNullOpts.mkBool false ''
        By default, if you try to move past the edge of the screen, tmux/vim will "wrap" around to the opposite side.

        This option disables "wrapping" in vim, but tmux will need to be configured separately.

        Tmux doesn't have a "no_wrap" option, so whatever key bindings you have need to conditionally wrap based on position on screen:

        ```shell
          is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
            | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"

          bind-key -n 'C-h' if-shell "$is_vim" { send-keys C-h } { if-shell -F '#{pane_at_left}'   {} { select-pane -L } }
          bind-key -n 'C-j' if-shell "$is_vim" { send-keys C-j } { if-shell -F '#{pane_at_bottom}' {} { select-pane -D } }
          bind-key -n 'C-k' if-shell "$is_vim" { send-keys C-k } { if-shell -F '#{pane_at_top}'    {} { select-pane -U } }
          bind-key -n 'C-l' if-shell "$is_vim" { send-keys C-l } { if-shell -F '#{pane_at_right}'  {} { select-pane -R } }

          bind-key -T copy-mode-vi 'C-h' if-shell -F '#{pane_at_left}'   {} { select-pane -L }
          bind-key -T copy-mode-vi 'C-j' if-shell -F '#{pane_at_bottom}' {} { select-pane -D }
          bind-key -T copy-mode-vi 'C-k' if-shell -F '#{pane_at_top}'    {} { select-pane -U }
          bind-key -T copy-mode-vi 'C-l' if-shell -F '#{pane_at_right}'  {} { select-pane -R }
        ```
      '';

      no_mappings = helpers.defaultNullOpts.mkBool false ''
        By default `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`, & `<-\\>` are mapped to navigating left, down, up, right, & previous, respectively.

        This option disables those default mappings being created.

        You can use `plugins.tmux-navigator.keymaps.*` to define your own custom mappings.

        You will also need to update your tmux bindings to match.
      '';
    };
  }
