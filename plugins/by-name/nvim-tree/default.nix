{
  lib,
  helpers,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "nvim-tree";
  packPathName = "nvim-tree.lua";
  package = "nvim-tree-lua";
  maintainers = [ lib.maintainers.saygo-png ];
  description = "A file explorer tree for neovim written in lua.";

  inherit (import ./deprecations.nix lib) optionsRenamedToSettings deprecateExtraOptions imports;

  extraOptions = {
    openOnSetup = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Will automatically open the tree when running setup if startup buffer is a directory, is
        empty or is unnamed. nvim-tree window will be focused.
      '';
    };

    openOnSetupFile = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Will automatically open the tree when running setup if startup buffer is a file.
        File window will be focused.
        File will be found if updateFocusedFile is enabled.
      '';
    };

    ignoreBufferOnSetup = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Will ignore the buffer, when deciding to open the tree on setup.
      '';
    };

    ignoreFtOnSetup = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        List of filetypes that will prevent `open_on_setup` to open.
        You can use this option if you don't want the tree to open
        in some scenarios (eg using vim startify).
      '';
    };

    autoClose = mkOption {
      type = types.bool;
      default = false;
      description = "Automatically close";
    };
  };

  dependencies = [
    "git"
  ];

  extraConfig =
    cfg:
    let
      autoOpenEnabled = cfg.openOnSetup or cfg.openOnSetupFile;

      openNvimTreeFunction = ''
        local function open_nvim_tree(data)

          ------------------------------------------------------------------------------------------

          -- buffer is a directory
          local directory = vim.fn.isdirectory(data.file) == 1

          -- buffer is a [No Name]
          local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

          -- Will automatically open the tree when running setup if startup buffer is a directory,
          -- is empty or is unnamed. nvim-tree window will be focused.
          local open_on_setup = ${lib.nixvim.toLuaObject cfg.openOnSetup}

          if (directory or no_name) and open_on_setup then
            -- change to the directory
            if directory then
              vim.cmd.cd(data.file)
            end

            -- open the tree
            require("nvim-tree.api").tree.open()
            return
          end

          ------------------------------------------------------------------------------------------

          -- Will automatically open the tree when running setup if startup buffer is a file.
          -- File window will be focused.
          -- File will be found if updateFocusedFile is enabled.
          local open_on_setup_file = ${lib.nixvim.toLuaObject cfg.openOnSetupFile}

          -- buffer is a real file on the disk
          local real_file = vim.fn.filereadable(data.file) == 1

          if (real_file or no_name) and open_on_setup_file then

            -- skip ignored filetypes
            local filetype = vim.bo[data.buf].ft
            local ignored_filetypes = ${lib.nixvim.toLuaObject cfg.ignoreFtOnSetup}

            if not vim.tbl_contains(ignored_filetypes, filetype) then
              -- open the tree but don't focus it
              require("nvim-tree.api").tree.toggle({ focus = false })
              return
            end
          end

          ------------------------------------------------------------------------------------------

          -- Will ignore the buffer, when deciding to open the tree on setup.
          local ignore_buffer_on_setup = ${lib.nixvim.toLuaObject cfg.ignoreBufferOnSetup}
          if ignore_buffer_on_setup then
            require("nvim-tree.api").tree.open()
          end

        end
      '';
    in
    {
      # TODO: added 2024-09-20 remove after 24.11
      plugins.web-devicons = lib.mkIf (
        !(
          (
            config.plugins.mini.enable
            && config.plugins.mini.modules ? icons
            && config.plugins.mini.mockDevIcons
          )
          || (config.plugins.mini-icons.enable && config.plugins.mini-icons.mockDevIcons)
        )
      ) { enable = lib.mkOverride 1490 true; };

      autoCmd =
        (lib.optional autoOpenEnabled {
          event = "VimEnter";
          callback = helpers.mkRaw "open_nvim_tree";
        })
        ++ (lib.optional cfg.autoClose {
          event = "BufEnter";
          command = "if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif";
          nested = true;
        });

      plugins.nvim-tree.luaConfig.pre = lib.optionalString autoOpenEnabled openNvimTreeFunction;
    };
}
