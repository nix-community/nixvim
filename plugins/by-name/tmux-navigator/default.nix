{
  lib,
  helpers,
  ...
}:
with lib;
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "tmux-navigator";
  packPathName = "vim-tmux-navigator";
  package = "vim-tmux-navigator";
  globalPrefix = "tmux_navigator_";

  maintainers = [ maintainers.MattSturgeon ];

  description = ''
    When combined with a set of tmux key bindings, the plugin will allow you to navigate seamlessly between vim splits and tmux panes using a consistent set of hotkeys.

    > [!WARNING]
    > To work correctly, you must configure tmux separately.

    ## Usage

    This plugin provides the following mappings which allow you to move between vim splits and tmux panes seamlessly.

    - `<ctrl-h>` => Left
    - `<ctrl-j>` => Down
    - `<ctrl-k>` => Up
    - `<ctrl-l>` => Right
    - `<ctrl-\>` => Previous split

    To use alternative key mappings, see [`plugins.tmux-navigator.settings.no_mappings`][no_mappings].

    ## Configure tmux

    > [!NOTE]
    > There are two main ways to configure tmux.

    #### Option 1: using a plugin

    You can install the `vim-tmux-navigator` plugin.

    If you're using TPM, add this to your tmux config:

    ```shell
      set -g @plugin 'christoomey/vim-tmux-navigator'
    ```

    If you're using nixos or home-manager to manager tmux, you can use the `programs.tmux.plugins` option for this:

    ```nix
      plugins.tmux.plugins = [
        pkgs.tmuxPlugins.vim-tmux-navigator
      ];
    ```

    #### Option 2: manually specify keybindings

    Alternatively, you can specify the keybinding in your tmux config.

    If you're using nixos or home-manager to manager tmux, you can use the `programs.tmux.extraConfig` option for this.

    Example config from the [upstream docs]:

    ```shell
      # Smart pane switching with awareness of vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
        | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"

      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'

      # Forwarding <C-\\> needs different syntax, depending on tmux version
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
        "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
        "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l
    ```

    See the [upstream docs] for more info.

    [no_mappings]: ./settings.html#pluginstmux-navigatorsettingsno_mappings
    [upstream docs]: https://github.com/christoomey/vim-tmux-navigator#installation
  '';

  settingsOptions = {
    save_on_switch =
      helpers.mkNullOrOption
        (types.enum [
          1
          2
        ])
        ''
          You can configure the plugin to write the current buffer, or all buffers, when navigating from vim to tmux.

          null: don't save on switch (default value)
          1: `:update` (write the current buffer, but only if changed)
          2: `:wall` (write all buffers)
        '';

    disable_when_zoomed = helpers.defaultNullOpts.mkFlagInt 0 ''
      By default, if you zoom the tmux pane running vim and then attempt to navigate "past" the edge of the vim session, tmux will unzoom the pane.
      This is the default tmux behavior, but may be confusing if you've become accustomed to navigation "wrapping" around the sides due to this plugin.

      This option disables the unzooming behavior, keeping all navigation within vim until the tmux pane is explicitly unzoomed.
    '';

    preserve_zoom = helpers.defaultNullOpts.mkFlagInt 0 ''
      As noted in `disable_when_zoomed`, navigating from a vim pane to another tmux pane normally causes the window to be unzoomed.
      Some users may prefer the behavior of tmux's `-Z` option to `select-pane`, which keeps the window zoomed if it was zoomed.

      This option enables that behavior.

      Naturally, if `disable_when_zoomed` is enabled, this option will have no effect.
    '';

    no_wrap = helpers.defaultNullOpts.mkFlagInt 0 ''
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

    no_mappings = helpers.defaultNullOpts.mkFlagInt 0 ''
      By default `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`, & `<C-\\>`
      are mapped to navigating left, down, up, right, & previous, respectively.

      This option disables those default mappings being created.

      You can use `plugins.tmux-navigator.keymaps` to define your own custom mappings.
      You will also need to **update your tmux bindings** separately,
      if you want them to match.
    '';
  };

  extraOptions = {
    keymaps = mkOption {
      description = ''
        Keymaps for the `:TmuxNavigate*` commands.

        Note: by default, tmux-navigator adds its own keymaps.
        If you wish to disable that behaviour, use `settings.no_mappings`.

        You will also need to **update your tmux bindings** separately,
        if you want them to match.
      '';
      example = [
        {
          key = "<C-w>h";
          action = "left";
        }
        {
          key = "<C-w>j";
          action = "down";
        }
        {
          key = "<C-w>k";
          action = "up";
        }
        {
          key = "<C-w>l";
          action = "right";
        }
        {
          key = "<C-w>\\";
          action = "previous";
        }
      ];
      default = [ ];
      type = types.listOf (
        helpers.keymaps.mkMapOptionSubmodule {
          action = {
            description = "The direction in which to navigate.";
            type = types.enum [
              "left"
              "down"
              "up"
              "right"
              "previous"
            ];
            example = "left";
          };
          lua = true;
        }
      );
      apply = map helpers.keymaps.removeDeprecatedMapAttrs;
    };
  };

  extraConfig = cfg: {
    keymaps = map (
      mapping: mapping // { action = "<cmd>TmuxNavigate${helpers.upperFirstChar mapping.action}<cr>"; }
    ) cfg.keymaps;
  };
}
