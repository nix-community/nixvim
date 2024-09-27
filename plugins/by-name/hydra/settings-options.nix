# Those are the configuration options for both the plugin's `setup` function (defaults for all
# hydras) and each Hydra.
# So this attrs of options is used:
# - as the `plugins.hydra.settings` option definition
# - for `plugins.hydra.hydras.[].config`
#
# -> https://github.com/nvimtools/hydra.nvim?tab=readme-ov-file#config
{ helpers, lib, ... }:
with lib;
{
  debug = helpers.defaultNullOpts.mkBool false ''
    Whether to enable debug mode.
  '';

  exit = helpers.defaultNullOpts.mkBool false ''
    Set the default exit value for each head in the hydra.
  '';

  foreign_keys =
    helpers.defaultNullOpts.mkEnum
      [
        "warn"
        "run"
      ]
      null
      ''
        Decides what to do when a key which doesn't belong to any head is pressed
        - `null`: hydra exits and foreign key behaves normally, as if the hydra wasn't active
        - `"warn"`: hydra stays active, issues a warning and doesn't run the foreign key
        - `"run"`: hydra stays active, runs the foreign key
      '';

  color = helpers.defaultNullOpts.mkStr "red" ''
    See `:h hydra-colors`.
    `"red" | "amaranth" | "teal" | "pink"`
  '';

  buffer = helpers.defaultNullOpts.mkNullable (
    with types; either (enum [ true ]) ints.unsigned
  ) null "Define a hydra for the given buffer, pass `true` for current buf.";

  invoke_on_body = helpers.defaultNullOpts.mkBool false ''
    When true, summon the hydra after pressing only the `body` keys.
    Normally a head is required.
  '';

  desc = helpers.defaultNullOpts.mkStr null ''
    Description used for the body keymap when `invoke_on_body` is true.
    When nil, "[Hydra] .. name" is used.
  '';

  on_enter = helpers.mkNullOrLuaFn ''
    Called when the hydra is activated.
  '';

  on_exit = helpers.mkNullOrLuaFn ''
    Called before the hydra is deactivated.
  '';

  on_key = helpers.mkNullOrLuaFn ''
    Called after every hydra head.
  '';

  timeout = helpers.defaultNullOpts.mkNullable (with types; either bool ints.unsigned) false ''
    Timeout after which the hydra is automatically disabled.
    Calling any head will refresh the timeout
    - `true`: timeout set to value of `timeoutlen` (`:h timeoutlen`)
    - `5000`: set to desired number of milliseconds

    By default hydras wait forever (`false`).
  '';

  hint =
    let
      hintConfigType = types.submodule {
        freeformType = with types; attrsOf anything;
        options = {
          type =
            helpers.mkNullOrOption
              (types.enum [
                "window"
                "cmdline"
                "statusline"
                "statuslinemanual"
              ])
              ''
                - "window": show hint in a floating window
                - "cmdline": show hint in the echo area
                - "statusline": show auto-generated hint in the status line
                - "statuslinemanual": Do not show a hint, but return a custom status line hint from
                  `require("hydra.statusline").get_hint()`

                Defaults to "window" if `hint` is passed to the hydra otherwise defaults to "cmdline".
              '';

          position = helpers.defaultNullOpts.mkEnum [
            "top-left"
            "top"
            "top-right"
            "middle-left"
            "middle"
            "middle-right"
            "bottom-left"
            "bottom"
            "bottom-right"
          ] "bottom" "Set the position of the hint window.";

          offset = helpers.defaultNullOpts.mkInt 0 ''
            Offset of the floating window from the nearest editor border.
          '';

          float_opts = helpers.mkNullOrOption (with types; attrsOf anything) ''
            Options passed to `nvim_open_win()`. See `:h nvim_open_win()`.
            Lets you set `border`, `header`, `footer`, etc.

            Note: `row`, `col`, `height`, `width`, `relative`, and `anchor` should not be overridden.
          '';

          show_name = helpers.defaultNullOpts.mkBool true ''
            Show the hydras name (or "HYDRA:" if not given a name), at the beginning of an
            auto-generated hint.
          '';

          hide_on_load = helpers.defaultNullOpts.mkBool false ''
            If set to true, this will prevent the hydra's hint window from displaying immediately.

            Note: you can still show the window manually by calling `Hydra.hint:show()` and manually
            close it with `Hydra.hint:close()`.
          '';

          funcs = mkOption {
            type = with lib.types; attrsOf strLuaFn;
            description = ''
              Table from function names to function.
              Functions should return a string.
              These functions can be used in hints with `%{func_name}` more in `:h hydra-hint`.
            '';
            default = { };
            example = {
              number = ''
                function()
                  if vim.o.number then
                    return '[x]'
                  else
                    return '[ ]'
                  end
                end
              '';
              relativenumber = ''
                function()
                  if vim.o.relativenumber then
                    return '[x]'
                  else
                    return '[ ]'
                  end
                end
              '';
            };
            apply = mapAttrs (_: helpers.mkRaw);
          };
        };
      };
    in
    helpers.defaultNullOpts.mkNullable (with types; either (enum [ false ]) hintConfigType)
      {
        show_name = true;
        position = "bottom";
        offset = 0;
      }
      ''
        Configure the hint.
        Set to `false` to disable.
      '';
}
