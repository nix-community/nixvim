{ lib, pkgs, ... }:
let
  platform = pkgs.stdenv.hostPlatform;

  # TODO: `cadical`, one of `lean4`'s dependencies is broken on x86_64-darwin
  # https://github.com/NixOS/nixpkgs/pull/371275
  doRun = !(platform.isDarwin && platform.isx86_64);
in
lib.optionalAttrs doRun {
  empty = {
    plugins.lean.enable = true;
  };

  # Enable the `leanls` LSP directly from `plugins.lsp`. This implies explicitly disabling the lsp
  # in the `lean` plugin configuration.
  lspDisabled = {
    plugins = {
      lsp = {
        enable = true;

        servers.leanls.enable = true;
      };

      lean = {
        enable = true;
        settings.lsp.enable = false;
      };
    };
  };

  default = {
    plugins = {
      lsp.enable = true;

      lean = {
        enable = true;
        settings = {
          lsp = { };
          ft = {
            default = "lean";
            nomodifiable = null;
          };
          abbreviations = {
            enable = true;
            extra = { };
            leader = "\\";
          };
          mappings = false;
          infoview = {
            autoopen = true;
            autopause = false;
            width = 50;
            height = 20;
            horizontal_position = "bottom";
            separate_tab = false;
            indicators = "auto";
            show_processing = true;
            show_no_info_message = false;
            use_widgets = true;
            mappings = {
              K = "click";
              "<CR>" = "click";
              gd = "go_to_def";
              gD = "go_to_decl";
              gy = "go_to_type";
              I = "mouse_enter";
              i = "mouse_leave";
              "<Esc>" = "clear_all";
              C = "clear_all";
              "<LocalLeader><Tab>" = "goto_last_window";
            };
          };
          progress_bars = {
            enable = true;
            priority = 10;
          };
          stderr = {
            enable = true;
            height = 5;
            on_lines.__raw = "function(lines) vim.notify(lines) end";
          };
        };
      };
    };
  };
}
