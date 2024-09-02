{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  directionOpt = helpers.defaultNullOpts.mkEnum [
    "vertical"
    "horizontal"
    "tab"
    "float"
  ] "horizontal" "The direction the terminal should be opened in.";

  closeOnExitOpt = helpers.defaultNullOpts.mkBool true ''
    Close the terminal window when the process exits.
  '';

  highlightsOpt = helpers.defaultNullOpts.mkAttrsOf helpers.nixvimTypes.highlight {
    NormalFloat.link = "Normal";
    FloatBorder.link = "Normal";
    StatusLine.gui = "NONE";
    StatusLineNC = {
      cterm = "italic";
      gui = "NONE";
    };
  } "Highlights which map a highlight group name to an attrs of it's values.";

  onOpenOpt = helpers.mkNullOrLuaFn ''
    Function to run when the terminal opens.

    `fun(t: Terminal)`
  '';

  onCloseOpt = helpers.mkNullOrLuaFn ''
    Function to run when the terminal closes.

    `fun(t: Terminal)`
  '';

  onStdoutOpt = helpers.mkNullOrLuaFn ''
    Callback for processing output on stdout.

    `fun(t: Terminal, job: number, data: string[], name: string)`
  '';

  onStderrOpt = helpers.mkNullOrLuaFn ''
    Callback for processing output on stderr.

    `fun(t: Terminal, job: number, data: string[], name: string)`
  '';

  onExitOpt = helpers.mkNullOrLuaFn ''
    Function to run when terminal process exits.

    `fun(t: Terminal, job: number, exit_code: number, name: string)`
  '';

  autoScrollOpt = helpers.defaultNullOpts.mkBool true ''
    Automatically scroll to the bottom on terminal output.
  '';
in
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "toggleterm";
  originalName = "toggleterm.nvim";
  defaultPackage = pkgs.vimPlugins.toggleterm-nvim;

  maintainers = [ maintainers.GaetanLepage ];

  # TODO: introduced 2024-04-07, remove on 2024-06-07
  deprecateExtraOptions = true;
  optionsRenamedToSettings = [
    "size"
    "onCreate"
    "onOpen"
    "onClose"
    "onStdout"
    "onStderr"
    "onExit"
    "hideNumbers"
    "shadeFiletypes"
    "autochdir"
    "highlights"
    "shadeTerminals"
    "shadingFactor"
    "startInInsert"
    "insertMappings"
    "terminalMappings"
    "persistSize"
    "persistMode"
    "direction"
    "closeOnExit"
    "shell"
    "autoScroll"
    [
      "floatOpts"
      "border"
    ]
    [
      "floatOpts"
      "width"
    ]
    [
      "floatOpts"
      "height"
    ]
    [
      "floatOpts"
      "winblend"
    ]
    [
      "floatOpts"
      "zindex"
    ]
    [
      "winbar"
      "enabled"
    ]
    [
      "winbar"
      "nameFormatter"
    ]
  ];
  imports = [
    (mkRemovedOptionModule
      [
        "plugins"
        "toggleterm"
        "openMapping"
      ]
      ''
        Please use `plugins.toggleterm.settings.open_mapping` instead but beware, you have to provide the value in this form: `"[[<c-\>]]"`.
      ''
    )
  ];

  settingsOptions = {
    size = helpers.defaultNullOpts.mkStrLuaFnOr types.number 12 ''
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

    open_mapping = helpers.mkNullOrLua ''
      Setting the `open_mapping` key to use for toggling the terminal(s) will set up mappings for
      normal mode.
    '';

    on_create = helpers.mkNullOrLuaFn ''
      Function to run when the terminal is first created.

      `fun(t: Terminal)`
    '';

    on_open = onOpenOpt;

    on_close = onCloseOpt;

    on_stdout = onStdoutOpt;

    on_stderr = onStderrOpt;

    on_exit = onExitOpt;

    hide_numbers = helpers.defaultNullOpts.mkBool true ''
      Hide the number column in toggleterm buffers.
    '';

    shade_filetypes = helpers.defaultNullOpts.mkListOf types.str [ ] ''
      Shade filetypes.
    '';

    autochdir = helpers.defaultNullOpts.mkBool false ''
      When neovim changes it current directory the terminal will change it's own when next it's
      opened.
    '';

    highlights = highlightsOpt;

    shade_terminals = helpers.defaultNullOpts.mkBool true ''
      NOTE: This option takes priority over highlights specified so if you specify Normal
      highlights you should set this to `false`.
    '';

    shading_factor = helpers.mkNullOrOption types.int ''
      The percentage by which to lighten terminal background.

      default: -30 (gets multiplied by -3 if background is light).
    '';

    start_in_insert = helpers.defaultNullOpts.mkBool true ''
      Whether to start toggleterm in insert mode.
    '';

    insert_mappings = helpers.defaultNullOpts.mkBool true ''
      Whether or not the open mapping applies in insert mode.
    '';

    terminal_mappings = helpers.defaultNullOpts.mkBool true ''
      Whether or not the open mapping applies in the opened terminals.
    '';

    persist_size = helpers.defaultNullOpts.mkBool true ''
      Whether the terminal size should persist.
    '';

    persist_mode = helpers.defaultNullOpts.mkBool true ''
      If set to true (default) the previous terminal mode will be remembered.
    '';

    direction = directionOpt;

    close_on_exit = closeOnExitOpt;

    shell = helpers.defaultNullOpts.mkStr { __raw = "vim.o.shell"; } ''
      Change the default shell.
    '';

    auto_scroll = autoScrollOpt;

    float_opts = {
      border = helpers.mkNullOrOption helpers.nixvimTypes.border ''
        `border` = "single" | "double" | "shadow" | "curved" | ... other options supported by
        `win open`.
        The border key is *almost* the same as 'nvim_open_win'.
        The 'curved' border is a custom border type not natively supported but implemented in this plugin.
      '';

      width = helpers.defaultNullOpts.mkStrLuaFnOr types.ints.unsigned null ''
        Width of the floating terminal. Like `size`, `width` can be a number or
        function which is passed the current terminal.
      '';

      height = helpers.defaultNullOpts.mkStrLuaFnOr types.ints.unsigned null ''
        Height of the floating terminal. Like `size`, `height` can be a number
        or function which is passed the current terminal.
      '';

      row = helpers.defaultNullOpts.mkStrLuaFnOr types.ints.unsigned null ''
        Start row of the floating terminal. Defaults to the center of the
        screen. Like `size`, `row` can be a number or function which is passed
        the current terminal.
      '';

      col = helpers.defaultNullOpts.mkStrLuaFnOr types.ints.unsigned null ''
        Start column of the floating terminal. Defaults to the center of the
        screen. Like `size`, `col` can be a number or function which is passed
        the current terminal.
      '';

      winblend = helpers.defaultNullOpts.mkUnsignedInt 0 "";

      zindex = helpers.mkNullOrOption types.ints.unsigned "";

      title_pos = helpers.defaultNullOpts.mkStr "left" "";
    };

    winbar = {
      enabled = helpers.defaultNullOpts.mkBool false ''
        Whether to enable winbar.
      '';

      name_formatter =
        helpers.defaultNullOpts.mkLuaFn
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
    open_mapping = "[[<c-\>]]";
    direction = "float";
    float_opts = {
      border = "curved";
      width = 130;
      height = 30;
    };
  };

  extraOptions = {
    customTerms =
      let
        termConfig = types.submodule {
          options = {
            cmd = helpers.mkNullOrOption types.str ''
              Command to execute when creating the terminal e.g. 'top'.
            '';
            direction = directionOpt;
            dir = helpers.mkNullOrOption types.str "Directory to start the terminal in.";
            hidden = helpers.defaultNullOpts.mkBool false ''
              Whether or not to include this terminal in the terminals list.
            '';
            close_on_exit = closeOnExitOpt;
            highlights = highlightsOpt;
            env = helpers.defaultNullOpts.mkAttrsOf types.str { } ''
              key:value attribute set with environment variables set in the terminal.
            '';
            clear_env = helpers.defaultNullOpts.mkBool false ''
              Use only environment variables defined in `env`.
            '';
            count = helpers.mkNullOrOption types.ints.unsigned ''
              The number that can be used to trigger this specific terminal.
              e.g. `:5ToggleTerm<CR>` will open the terminal with count 5.
            '';
            toggle = {
              enable = helpers.defaultNullOpts.mkBool false ''
                Whether or not to enable toggling of the terminal.
              '';
              keymap = helpers.mkNullOrOption (helpers.keymaps.mkMapOptionSubmodule {
                defaults = { };
                key = true;
                action = false;
              }) "Keymap to toggle the terminal.";
            };
            on_open = onOpenOpt;
            on_close = onCloseOpt;
            auto_scroll = autoScrollOpt;
            on_stdout = onStdoutOpt;
            on_stderr = onStderrOpt;
            on_exit = onExitOpt;
          };
        };
      in
      mkOption {
        default = { };
        description = "Custom terminal configurations.";
        example = ''
          ```nix
          customTerms = {
            lazygit_term = {
              cmd = "lazygit";
              dir = "git_dir";
              direction = "float";
              hidden = true;
              toggle = {
                enable = true;
                keymap = {
                  key = "<leader>tg";
                };
              };
            };
            htop_term = {
              cmd = "htop";
              direction = "horizontal";
              toggle = {
                enable = true;
                keymap = {
                  key = "<leader>th";
                };
              };
            };
          };
        '';
        type = types.attrsOf termConfig;
      };
  };

  extraConfig = cfg: {
    extraConfigLua =
      let
        termConfigToLua =
          name: tcfg:
          let
            termSetupOptions = filterAttrs (n: v: n != "toggle") (tcfg // { display_name = name; });
          in
          ''
            ${name} = Terminal:new(${helpers.toLuaObject termSetupOptions})
          '';
      in
      optionalString (cfg.customTerms != null && cfg.customTerms != [ ]) ''
        local Terminal = require('toggleterm.terminal').Terminal
      ''
      + concatStrings (mapAttrsToList termConfigToLua cfg.customTerms);

    keymaps =
      let
        termConfigsWithKeymap = filterAttrs (
          name: tcfg: tcfg.toggle != null && tcfg.toggle.enable && tcfg.toggle.keymap != null
        ) cfg.customTerms;
        termConfigToKeymap =
          name: tcfg: tcfg.toggle.keymap // { action.__raw = "function() ${name}:toggle() end"; };
      in
      mapAttrsToList termConfigToKeymap termConfigsWithKeymap;
  };
}
