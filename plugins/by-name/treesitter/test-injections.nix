{ lib, pkgs, ... }:
let
  inherit (lib)
    mkDefault
    mkIf
    mkMerge
    mkOverride
    mkRaw
    ;
in
{
  # ============================================================================
  # SECTION 1: Direct string assignments
  # ============================================================================
  section1 = {
    # Basic __raw
    __raw = ''
      vim.opt.number = true
      print("hello")
    '';

    # Basic extraConfigLua
    extraConfigLua = ''
      require('telescope').setup()
    '';

    extraConfigLuaPre = "vim.g.loaded_netrw = 1";
    extraConfigLuaPost = "print('done')";

    # Vim config
    extraConfigVim = ''
      set number
      nnoremap <leader>f :Telescope<CR>
    '';
  };

  # ============================================================================
  # SECTION 2: Single-level function application
  # ============================================================================
  section2 = {
    # mkRaw function
    __raw = mkRaw ''
      local telescope = require('telescope')
      telescope.setup({})
    '';

    # Other function with extraConfigLua
    extraConfigLua = lib.mkRaw ''
      vim.diagnostic.config({ virtual_text = false })
    '';
  };

  # ============================================================================
  # SECTION 3: Nested function wrappers
  # ============================================================================
  section3 = {
    # mkOverride nested
    extraConfigLua = mkIf true (
      mkOverride 100 ''
        require('lualine').setup()
      ''
    );

    # Triple nested
    luaConfig.content = mkIf true (
      mkOverride 123 (mkDefault ''
        vim.opt.termguicolors = true
      '')
    );
  };

  # ============================================================================
  # SECTION 4: Lists and mkMerge
  # ============================================================================
  section4 = {
    # mkMerge with list
    extraConfigLua = mkMerge [
      ''
        vim.opt.number = true
      ''
      ''
        vim.opt.relativenumber = true
      ''
    ];

    # mkMerge with conditional items
    __raw = mkMerge [
      (mkIf true ''
        print('conditional lua')
      '')
      ''
        print('always runs')
      ''
    ];
  };

  # ============================================================================
  # SECTION 5: luaConfig attribute patterns
  # ============================================================================
  section5 = {
    # Direct luaConfig attrset
    luaConfig = {
      pre = ''
        local M = {}
      '';
      content = ''
        M.setup = function() end
      '';
      post = ''
        return M
      '';
    };
  };

  # Nested identifier pattern (top-level to test dot notation)
  luaConfig.pre = ''
    vim.g.mapleader = ' '
  '';

  luaConfig.content = ''
    require('config').setup()
  '';

  # luaConfig with triple nesting (dot notation)
  luaConfig.post = mkIf true (
    mkOverride 123 (mkDefault ''
      vim.opt.termguicolors = true
    '')
  );

  # ============================================================================
  # SECTION 6: Pre/Post variants with wrappers
  # ============================================================================
  section6 = {
    # extraConfigLuaPre with wrapped function
    extraConfigLuaPre = mkIf true ''
      vim.g.mapleader = ' '
    '';

    # extraConfigLuaPost with nested wrappers
    extraConfigLuaPost = mkIf true (
      mkOverride 100 ''
        print('cleanup')
      ''
    );
  };

  # ============================================================================
  # SECTION 7: Vim patterns (wrapped, nested, lists)
  # ============================================================================
  section7 = {
    # Vim with wrapped function
    extraConfigVim = mkIf true ''
      set background=dark
      colorscheme gruvbox
    '';

    # Vim with nested wrappers
    extraConfigVimPre = mkIf true (
      mkOverride 100 ''
        set nocompatible
        filetype plugin on
      ''
    );

    # Vim with lists
    extraConfigVimPost = mkMerge [
      ''
        set cursorline
      ''
      ''
        set number
      ''
    ];
  };

  section7b = {
    # Vim with mixed list + wrappers
    extraConfigVim = mkMerge [
      (mkIf true ''
        nnoremap <leader>q :q<CR>
      '')
      ''
        nnoremap <leader>w :w<CR>
      ''
    ];
  };

  # ============================================================================
  # SECTION 8: luaConfig with wrapped functions
  # ============================================================================
  section8 = {
    luaConfig = {
      pre = mkIf true ''
        vim.g.loaded_python_provider = 0
      '';

      content = mkOverride 50 ''
        require('main').setup()
      '';

      post = ''
        vim.notify('Config loaded')
      '';
    };
  };

  # ============================================================================
  # SECTION 9: Edge cases
  # ============================================================================
  section9 = {
    # Multiline with interpolation
    extraConfigLua = ''
      local path = "${pkgs.vimPlugins.telescope-nvim}"
      print(path)
    '';

    # Nested attrset
    plugins = {
      telescope = {
        __raw = ''
          require('telescope').setup({
            defaults = {
              file_ignore_patterns = { "node_modules" }
            }
          })
        '';
      };
    };
  };
}
