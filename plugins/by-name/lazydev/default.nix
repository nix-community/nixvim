{ config, lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim)
    defaultNullOpts
    literalLua
    mkNullOrOption'
    nestedLiteralLua
    ;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "lazydev";
  packPathName = "lazydev.nvim";
  package = "lazydev-nvim";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  description = ''
    ### lazydev.nvim as a blink.cmp source

    ```nix
    {
      plugins = {
        lazydev.enable = true;

        blink-cmp.settings = {
          sources.providers = {
            lazydev = {
              name = "LazyDev";
              module = "lazydev.integrations.blink";
              # make lazydev completions top priority (see `:h blink.cmp`)
              score_offset = 100;
            };
          };
        };
      };
    }
    ```
  '';

  settingsOptions =
    let
      libraryType = types.submodule {
        freeformType = with types; attrsOf anything;
        options = {
          files = mkNullOrOption' {
            type = with types; listOf str;
            example = [ "xmake.lua" ];
            description = "A list of files that triggers the library to be loaded when required.";
          };
          mods = mkNullOrOption' {
            type = with types; listOf str;
            example = [ "wezterm" ];
            description = "A list of modules that triggers the library to be loaded when required.";
          };
          path = lib.mkOption {
            type = types.str;
            example = "~/projects/my-awesome-lib";
            description = "The path to the library.";
          };
          words = mkNullOrOption' {
            type = with types; listOf str;
            example = [
              "wezterm"
              "LazyVim"
            ];
            description = "A list of words that triggers the library to be loaded.";
          };
        };
      };
    in
    {
      enabled =
        defaultNullOpts.mkBool
          (literalLua ''
            function(root_dir)
              return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
            end
          '')
          ''
            Whether lazydev.nvim is enabled.
          '';

      integrations = {
        cmp = defaultNullOpts.mkBool true ''
          Whether lazydev.nvim should integrate with nvim-cmp.

          Adds a completion source for:
            - `require "modname"`
            - `---@module "modname"`
        '';

        coq = defaultNullOpts.mkBool false ''
          Whether lazydev.nvim should integrate with coq.nvim.

          Adds a completion source for:
            - `require "modname"`
            - `---@module "modname"`
        '';

        lspconfig = defaultNullOpts.mkBool true ''
          Whether lazydev.nvim should integrate with nvim-lspconfig.

          Fixes lspconfig's workspace management for LuaLS.
          Only create a new workspace if the buffer is not part
          of an existing workspace or one of its libraries.
        '';
      };

      library = defaultNullOpts.mkListOf (with types; either str libraryType) [ ] ''
        A list of libraries for lazydev.nvim.
      '';

      runtime = defaultNullOpts.mkStr (literalLua "vim.env.VIMRUNTIME") ''
        The runtime path of the current Neovim instance.
      '';
    };

  settingsExample = {
    enabled = nestedLiteralLua ''
      function(root_dir)
        return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
      end
    '';
    library = [
      "~/projects/my-awesome-lib"
      "lazy.nvim"
      "LazyVim"
      {
        path = "LazyVim";
        words = [ "LazyVim" ];
      }
    ];
    runtime = nestedLiteralLua "vim.env.VIMRUNTIME";
  };

  extraConfig = cfg: {
    warnings = lib.nixvim.mkWarnings "plugins.lazydev" [
      {
        when = (cfg.settings.integrations.cmp == true) && !config.plugins.cmp.enable;
        message = "You have enabled nvim-cmp integration but plugins.cmp is not enabled.";
      }
      {
        when = (cfg.settings.integrations.lspconfig == true) && !config.plugins.lsp.enable;
        message = "You have enabled lspconfig integration but plugins.lsp is not enabled.";
      }
      {
        when = (cfg.settings.integrations.coq == true) && !config.plugins.coq-nvim.enable;
        message = "You have enabled coq integration but plugins.coq-nvim is not enabled.";
      }
    ];
  };
}
