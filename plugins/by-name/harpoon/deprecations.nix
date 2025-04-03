{ lib, ... }:
{
  imports =
    let
      basePluginPath = [
        "plugins"
        "harpoon"
      ];

      commonWarning = ''
        /!\ `plugins.harpoon` has been refactored to now use harpoon2 (https://github.com/ThePrimeagen/harpoon/tree/harpoon2).
      '';

      keymapsWarning = ''
        ${commonWarning}

        The `plugins.harpoon` module no longer allows you to define your keymaps.
        Please, manually define your keymaps using the top-level `keymaps` option.

        For example,
        ```
          plugins.harpoon.keymaps = {
            addFile = "<leader>a";
            toggleQuickMenu = "<C-e>";
            navFile = {
              "1" = "<C-j>";
              "2" = "<C-k>";
              "3" = "<C-l>";
              "4" = "<C-m>";
            };
          };
        ```

        would become:
        ```
          keymaps = [
            { mode = "n"; key = "<leader>a"; action.__raw = "function() require'harpoon':list():add() end"; }
            { mode = "n"; key = "<C-e>"; action.__raw = "function() require'harpoon'.ui:toggle_quick_menu(require'harpoon':list()) end"; }
            { mode = "n"; key = "<C-j>"; action.__raw = "function() require'harpoon':list():select(1) end"; }
            { mode = "n"; key = "<C-k>"; action.__raw = "function() require'harpoon':list():select(2) end"; }
            { mode = "n"; key = "<C-l>"; action.__raw = "function() require'harpoon':list():select(3) end"; }
            { mode = "n"; key = "<C-m>"; action.__raw = "function() require'harpoon':list():select(4) end"; }
          ];
        ```
      '';

      optionNames = [
        "saveOnToggle"
        "saveOnChange"
        "enterOnSendcmd"
        "tmuxAutocloseWindows"
        "excludedFiletypes"
        "markBranch"
        "projects"
        "menu"
      ];
    in
    (map (
      optionName:
      lib.mkRemovedOptionModule (basePluginPath ++ [ optionName ]) ''
        ${commonWarning}

        You may now use `plugins.harpoon.settings` option to forward any value to the `require("harpoon"):setup()` call.
      ''
    ) optionNames)
    ++ [
      (lib.mkRemovedOptionModule (basePluginPath ++ [ "keymaps" ]) keymapsWarning)
      (lib.mkRemovedOptionModule (basePluginPath ++ [ "keymapsSilent" ]) keymapsWarning)
    ];

}
