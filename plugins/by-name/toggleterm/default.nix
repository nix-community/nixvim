{
  lib,
  ...
}:
let
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "toggleterm";
  package = "toggleterm-nvim";
  description = "A neovim lua plugin to help easily manage multiple terminal windows.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    size = lib.nixvim.defaultNullOpts.mkStrLuaFnOr types.number 12 ''
      Size of the terminal.
      `size` can be a number or a function.

      Example:
      ```nix
        size = 20
      ```
      OR

      ```nix
      size = \'\'
        function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end
      \'\';
      ```
    '';

    open_mapping = lib.nixvim.mkNullOrLua ''
      Setting the `open_mapping` key to use for toggling the terminal(s) will set up mappings for
      normal mode.
    '';

    on_create = lib.nixvim.mkNullOrLuaFn ''
      Function to run when the terminal is first created.

      `fun(t: Terminal)`
    '';

    on_open = lib.nixvim.mkNullOrLuaFn ''
      Function to run when the terminal opens.

      `fun(t: Terminal)`
    '';

    on_close = lib.nixvim.mkNullOrLuaFn ''
      Function to run when the terminal closes.

      `fun(t: Terminal)`
    '';

    on_stdout = lib.nixvim.mkNullOrLuaFn ''
      Callback for processing output on stdout.

      `fun(t: Terminal, job: number, data: string[], name: string)`
    '';

    on_stderr = lib.nixvim.mkNullOrLuaFn ''
      Callback for processing output on stderr.

      `fun(t: Terminal, job: number, data: string[], name: string)`
    '';

    on_exit = lib.nixvim.mkNullOrLuaFn ''
      Function to run when terminal process exits.

      `fun(t: Terminal, job: number, exit_code: number, name: string)`
    '';

    float_opts = {
      width = lib.nixvim.defaultNullOpts.mkStrLuaFnOr types.ints.unsigned null ''
        Width of the floating terminal. Like `size`, `width` can be a number or
        function which is passed the current terminal.
      '';

      height = lib.nixvim.defaultNullOpts.mkStrLuaFnOr types.ints.unsigned null ''
        Height of the floating terminal. Like `size`, `height` can be a number
        or function which is passed the current terminal.
      '';

      row = lib.nixvim.defaultNullOpts.mkStrLuaFnOr types.ints.unsigned null ''
        Start row of the floating terminal. Defaults to the center of the
        screen. Like `size`, `row` can be a number or function which is passed
        the current terminal.
      '';

      col = lib.nixvim.defaultNullOpts.mkStrLuaFnOr types.ints.unsigned null ''
        Start column of the floating terminal. Defaults to the center of the
        screen. Like `size`, `col` can be a number or function which is passed
        the current terminal.
      '';
    };

    winbar = {
      name_formatter =
        lib.nixvim.defaultNullOpts.mkLuaFn
          ''
            function(term)
              return term.name
            end
          ''
          ''
            `func(term: Terminal):string`

            Example:
            ```lua
              function(term)
                return fmt("%d:%s", term.id, term:_display_name())
              end
            ```
          '';
    };
  };

  settingsExample = {
    open_mapping = "[[<c-\\>]]";
    direction = "float";
    float_opts = {
      border = "curved";
      width = 130;
      height = 30;
    };
  };
}
