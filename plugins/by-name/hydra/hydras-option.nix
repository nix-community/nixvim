{ lib, helpers }:
with lib;
let
  hydraType = types.submodule {
    freeformType = with types; attrsOf anything;
    options = {
      name = helpers.mkNullOrStr ''
        Hydra's name.
        Only used in auto-generated hint.
      '';

      mode = helpers.defaultNullOpts.mkNullable (
        with lib.types; either helpers.keymaps.modeEnum (listOf helpers.keymaps.modeEnum)
      ) "n" "Modes where the hydra exists, same as `vim.keymap.set()` accepts.";

      body = helpers.mkNullOrStr ''
        Key required to activate the hydra, when excluded, you can use `Hydra:activate()`.
      '';

      hint = helpers.mkNullOrStr ''
        The hint for a hydra can let you know that it's active, and remind you of the
        hydra's heads.
        The string for the hint is passed directly to the hydra.

        See [the README](https://github.com/nvimtools/hydra.nvim?tab=readme-ov-file#hint)
        for more information.
      '';

      config = import ./settings-options.nix { inherit lib helpers; };

      heads =
        let
          headsOptType = types.submodule {
            freeformType = with types; attrsOf anything;
            options = {
              private = helpers.defaultNullOpts.mkBool false ''
                "When the hydra hides, this head does not stick out".
                Private heads are unreachable outside of the hydra state.
              '';

              exit = helpers.defaultNullOpts.mkBool false ''
                When true, stops the hydra after executing this head.
                NOTE:
                  - All exit heads are private
                  - If no exit head is specified, `esc` is set by default
              '';

              exit_before = helpers.defaultNullOpts.mkBool false ''
                Like `exit`, but stops the hydra BEFORE executing the command.
              '';

              ok_key = helpers.defaultNullOpts.mkBool true ''
                When set to `false`, `config.on_key` isn't run after this head.
              '';

              desc = helpers.mkNullOrStr ''
                Value shown in auto-generated hint.
                When false, this key doesn't show up in the auto-generated hint.
              '';

              expr = helpers.defaultNullOpts.mkBool false ''
                Same as the builtin `expr` map option.
                See `:h :map-expression`.
              '';

              silent = helpers.defaultNullOpts.mkBool false ''
                Same as the builtin `silent` map option.
                See `:h :map-silent`.
              '';

              nowait = helpers.defaultNullOpts.mkBool false ''
                For Pink Hydras only.
                Allows binding a key which will immediately perform its action and not wait
                `timeoutlen` for a possible continuation.
              '';

              mode = helpers.mkNullOrOption (
                with lib.types; either helpers.keymaps.modeEnum (listOf helpers.keymaps.modeEnum)
              ) "Override `mode` for this head.";
            };
          };
          headType =
            with lib.types;
            # More precisely, a tuple: [head action opts]
            listOf (
              nullOr (
                # action can be `null`
                oneOf [
                  str # for `head` and `action`
                  rawLua # for `action`
                  headsOptType # for opts
                ]
              )
            );
        in
        helpers.mkNullOrOption (types.listOf headType) ''
          Each Hydra's head has the form:
          `[head rhs opts]

          Similar to the `vim.keymap.set()` function.

          - The `head` is the "lhs" of the mapping (given as a string).
            These are the keys you press to perform the action.
          - The `rhs` is the action that gets performed.
            It can be a string, function (use `__raw`) or `null`.
            When `null`, the action is a no-op.
          - The `opts` attrs is empty by default.
        '';
    };
  };
in
mkOption {
  type = types.listOf hydraType;
  default = [ ];
  description = ''
    A list of hydra configurations.
    See [here](https://github.com/nvimtools/hydra.nvim?tab=readme-ov-file#creating-a-new-hydra).
  '';
  example = [
    {
      name = "git";
      hint.__raw = ''
        [[
           _J_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
           _K_: prev hunk   _u_: undo stage hunk   _p_: preview hunk   _B_: blame show full
           ^ ^              _S_: stage buffer      ^ ^                 _/_: show base file
           ^
           ^ ^              _<Enter>_: Neogit              _q_: exit
        ]]
      '';
      config = {
        color = "pink";
        invoke_on_body = true;
        hint = {
          position = "bottom";
        };
        on_enter = ''
          function()
            vim.bo.modifiable = false
            gitsigns.toggle_signs(true)
            gitsigns.toggle_linehl(true)
          end
        '';
        on_exit = ''
            function()
          	gitsigns.toggle_signs(false)
          	gitsigns.toggle_linehl(false)
          	gitsigns.toggle_deleted(false)
          	vim.cmd("echo") -- clear the echo area
          end
        '';
      };
      mode = [
        "n"
        "x"
      ];
      body = "<leader>g";
      heads = [
        [
          "J"
          {
            __raw = ''
              function()
                if vim.wo.diff then
                  return "]c"
                end
                vim.schedule(function()
                  gitsigns.next_hunk()
                end)
                return "<Ignore>"
              end
            '';
          }
          { expr = true; }
        ]
        [
          "K"
          {
            __raw = ''
              function()
                if vim.wo.diff then
                  return "[c"
                end
                vim.schedule(function()
                  gitsigns.prev_hunk()
                end)
                return "<Ignore>"
              end
            '';
          }
          { expr = true; }
        ]
        [
          "s"
          ":Gitsigns stage_hunk<CR>"
          { silent = true; }
        ]
        [
          "u"
          { __raw = "require('gitsigns').undo_stage_hunk"; }
        ]
        [
          "S"
          { __raw = "require('gitsigns').stage_buffer"; }
        ]
        [
          "p"
          { __raw = "require('gitsigns').preview_hunk"; }
        ]
        [
          "d"
          { __raw = "require('gitsigns').toggle_deleted"; }
          { nowait = true; }
        ]
        [
          "b"
          { __raw = "require('gitsigns').blame_line"; }
        ]
        [
          "B"
          {
            __raw = ''
              function()
                gitsigns.blame_line({ full = true })
              end,
            '';
          }
        ]
        [
          "/"
          { __raw = "require('gitsigns').show"; }
          { exit = true; }
        ]
        [
          "<Enter>"
          "<cmd>Neogit<CR>"
          { exit = true; }
        ]
        [
          "q"
          null
          {
            exit = true;
            nowait = true;
          }
        ]
      ];
    }
  ];
}
