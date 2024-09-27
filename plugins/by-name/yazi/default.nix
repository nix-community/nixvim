{
  lib,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "yazi";
  originalName = "yazi.nvim";
  package = "yazi-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  description = ''
    Yazi is a blazing fast file manager for the terminal.
    This plugin allows you to open yazi in a floating window in Neovim.

    Some default keybindings have additional dependencies you may need to install or enable.
    See the [upstream docs](https://github.com/mikavilpas/yazi.nvim?tab=readme-ov-file#%EF%B8%8F-keybindings) for details.
  '';

  settingsOptions = {
    log_level = defaultNullOpts.mkLogLevel' {
      pluginDefault = "off";
      description = ''
        The log level to use. Off by default, but can be used to diagnose
        issues. You can find the location of the log file by running
        `:checkhealth yazi` in Neovim.
      '';
    };

    open_for_directories = defaultNullOpts.mkBool false "";

    use_ya_for_events_reading = defaultNullOpts.mkBool false ''
      Use the `ya` command to read events.

      Allows more complex behaviors using the `ya` messaging system.
    '';

    use_yazi_client_id_flag = defaultNullOpts.mkBool false "Allows passing which instance of yazi is being controlled.";

    enable_mouse_support = defaultNullOpts.mkBool false "Enables mouse support.";

    open_file_function = defaultNullOpts.mkLuaFn' {
      pluginDefault.__raw = ''
        function(chosen_file)
          vim.cmd(string.format("edit %s", vim.fn.fnameescape(chosen_file)))
        end
      '';
      description = ''
        What Neovim should do a when a file was opened (selected) in yazi.

        Defaults to simply opening the file.
      '';
    };

    clipboard_register = defaultNullOpts.mkStr "*" ''
      Some yazi.nvim commands copy text to the clipboard. This is the register
      yazi.nvim should use for copying. Defaults to "*", the system clipboard.
    '';

    keymaps =
      defaultNullOpts.mkNullable (types.either types.attrs (types.enum [ false ]))
        {
          show_help = "<f1>";
          open_file_in_vertical_split = "<c-v>";
          open_file_in_horizontal_split = "<c-x>";
          open_file_in_tab = "<c-t>";
          grep_in_directory = "<c-s>";
          replace_in_directory = "<c-g>";
          cycle_open_buffers = "<tab>";
          copy_relative_path_to_selected_files = "<c-y>";
          send_to_quickfix_list = "<c-q>";
        }
        ''
          Customize the keymaps that are active when yazi is open and focused.

          Also:
            - use e.g. `open_file_in_tab = false` to disable a keymap
            - you can customize only some of the keymaps if you want
            - Set to `false` to disable all default keymaps.
        '';

    set_keymappings_function = defaultNullOpts.mkLuaFn null ''
      Completely override the keymappings for yazi. This function will be
      called in the context of the yazi terminal buffer.
    '';

    hooks = {
      yazi_opened = defaultNullOpts.mkLuaFn' {
        pluginDefault.__raw = ''
          function(preselected_path, yazi_buffer_id, config)
          end
        '';
        description = ''
          If you want to execute a custom action when yazi has been opened,
          you can define it here.
        '';
      };

      yazi_closed_successfully = defaultNullOpts.mkLuaFn' {
        pluginDefault.__raw = ''
          function(chosen_file, config, state)
          end
        '';
        description = "When yazi was successfully closed";
      };

      yazi_opened_multiple_files = defaultNullOpts.mkLuaFn' {
        pluginDefault.__raw = ''
          function(chosen_files)
            vim.cmd("args" .. table.concat(chosen_files, " "))
          end
        '';
        description = ''
          When yazi opened multiple files. The default is to send them to the
          quickfix list, but if you want to change that, you can define it here
        '';
      };
    };

    highlight_groups = defaultNullOpts.mkAttributeSet { hovered_buffer = null; } ''
      Add highlight groups to different yazi events.

      NOTE: this only works if `use_ya_for_events_reading` is enabled, etc.
    '';

    floating_window_scaling_factor =
      defaultNullOpts.mkNum 0.9
        "The floating window scaling factor. 1 means 100%, 0.9 means 90%, etc.";

    yazi_floating_window_winblend = defaultNullOpts.mkNullableWithRaw' {
      type = types.ints.between 0 100;
      pluginDefault = 0;
      description = "`0` for fully opaque and `100` for fully transparent. See :h winblend";
    };

    yazi_floating_window_border = defaultNullOpts.mkBorder "rounded" "yazi" ''
      The type of border to use for the floating window.

      Supports all available border types from `vim.api.keyset.win_config.border`.
    '';
  };

  settingsExample = {
    log_level = "debug";
    open_for_directories = true;
    enable_mouse_support = true;
    floating_window_scaling_factor = 0.5;
    yazi_floating_window_border = "single";
    yazi_floating_window_winblend = 50;
  };
}
