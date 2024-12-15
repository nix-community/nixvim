{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.plugins.multicursors;

  keyOptionType =
    with types;
    attrsOf (submodule {
      options = {
        method = mkOption {
          type = either str (enum [ false ]);
          description = ''
            Assigning `"nil"` exits from multi cursor mode.
            Assigning `false` removes the binding
          '';
          example = ''
            function()
              require('multicursors.utils').call_on_selections(
                function(selection)
                  vim.api.nvim_win_set_cursor(0, { selection.row + 1, selection.col + 1 })
                  local line_count = selection.end_row - selection.row + 1
                  vim.cmd('normal ' .. line_count .. 'gcc')
                end
              )
            end
          '';
        };

        opts = mkOption {
          type = attrsOf str;
          default = { };
          description = "You can pass `:map-arguments` here.";
          example = {
            desc = "comment selections";
          };
        };
      };
    });
in
{
  options = {
    plugins.multicursors = lib.nixvim.neovim-plugin.extraOptionsOptions // {
      enable = mkEnableOption "multicursors.nvim";

      package = lib.mkPackageOption pkgs "multicursors.nvim" {
        default = [
          "vimPlugins"
          "multicursors-nvim"
        ];
      };

      debugMode = helpers.defaultNullOpts.mkBool false "Enable debug mode.";

      createCommands = helpers.defaultNullOpts.mkBool true "Create Multicursor user commands.";

      updatetime = helpers.defaultNullOpts.mkUnsignedInt 50 ''
        Selections get updated if this many milliseconds nothing is typed in the insert mode see
        `:help updatetime`.
      '';

      nowait = helpers.defaultNullOpts.mkBool true "see `:help :map-nowait`.";

      normalKeys = helpers.mkNullOrOption keyOptionType ''
        Normal mode key mappings.

        Default: see the [README.md](https://github.com/smoka7/multicursors.nvim)

        Example:
        ```nix
          {
            # to change default lhs of key mapping, change the key
            "," = {
              # assigning `null` to method exits from multi cursor mode
              # assigning `false` to method removes the binding
              method = "require 'multicursors.normal_mode'.clear_others";

              # you can pass :map-arguments here
              opts = { desc = "Clear others"; };
            };
            "<C-/>" = {
                method = \'\'
                  function()
                    require('multicursors.utils').call_on_selections(
                      function(selection)
                        vim.api.nvim_win_set_cursor(0, { selection.row + 1, selection.col + 1 })
                        local line_count = selection.end_row - selection.row + 1
                        vim.cmd('normal ' .. line_count .. 'gcc')
                      end
                    )
                  end
                \'\';
                opts = { desc = "comment selections"; };
            };
          }
        ```
      '';

      insertKeys = helpers.mkNullOrOption keyOptionType ''
        Insert mode key mappings.

        Default: see the [README.md](https://github.com/smoka7/multicursors.nvim)
      '';

      extendKeys = helpers.mkNullOrOption keyOptionType ''
        Insert mode key mappings.

        Default: see the [README.md](https://github.com/smoka7/multicursors.nvim)
      '';

      hintConfig = {
        type =
          helpers.mkNullOrOption
            (types.enum [
              "window"
              "cmdline"
              "statusline"
            ])
            ''
              - "window": show hint in a floating window;
              - "cmdline": show hint in a echo area;
              - "statusline":  show auto-generated hint in the statusline.
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
        ] "bottom" "Set the position of the hint.";

        offset = helpers.mkNullOrOption types.int ''
          The offset from the nearest editor border.
          (valid when `type` if `"window"`).
        '';

        border = helpers.defaultNullOpts.mkBorder "none" "the hint window" "";

        showName = helpers.mkNullOrOption types.bool ''
          Show hydras name or `HYDRA:` label at the beginning of an auto-generated hint.
        '';

        funcs = helpers.mkNullOrOption (with types; attrsOf str) ''
          Attrs where keys are function names and values are functions themselves.
          Each function should return string.
          This functions can be required from hint with `%{func_name}` syntaxis.
        '';
      };

      generateHints =
        genAttrs
          [
            "normal"
            "insert"
            "extend"
          ]
          (
            mode:
            helpers.defaultNullOpts.mkNullable (with types; either bool str) false ''
              Hints for ${mode} mode.

              Accepted values:
              - `true`: generate hints
              - `false`: don't generate hints
              - str: provide your own hints
            ''
          );
    };
  };

  config =
    let
      setupOptions =
        with cfg;
        let
          mkMaps =
            value:
            helpers.ifNonNull' value (
              mapAttrs (
                key: mapping: with mapping; {
                  method =
                    # `false`
                    if isBool method then method else helpers.mkRaw method;
                  inherit opts;
                }
              ) value
            );
        in
        {
          DEBUG_MODE = debugMode;
          create_commands = createCommands;
          inherit updatetime nowait;
          normal_keys = mkMaps normalKeys;
          insert_keys = mkMaps insertKeys;
          extend_keys = mkMaps extendKeys;
          hint_config = with hintConfig; {
            inherit
              type
              position
              offset
              border
              ;
            show_name = showName;
            funcs = helpers.ifNonNull' funcs (mapAttrs (name: helpers.mkRaw) funcs);
          };
          generate_hints =
            genAttrs
              [
                "normal"
                "insert"
                "extend"
              ]
              (
                mode:
                let
                  value = generateHints.${mode};
                in
                helpers.ifNonNull' value (
                  if isBool value then
                    value
                  else
                    helpers.mkRaw ''
                      [[
                      ${value}
                      ]]
                    ''
                )
              );
        }
        // extraOptions;
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      extraConfigLua = ''
        require("multicursors").setup(${lib.nixvim.toLuaObject setupOptions})
      '';
    };
}
