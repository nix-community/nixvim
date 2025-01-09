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

        lsp.enable = false;
      };
    };
  };

  default = {
    plugins = {
      lsp.enable = true;

      lean = {
        enable = true;

        lsp = { };
        ft = {
          default = "lean";
          nomodifiable = null;
        };
        abbreviations = {
          enable = true;
          extra = {
            wknight = "♘";
          };
          leader = "\\";
        };
        mappings = false;
        infoview = {
          autoopen = true;
          autopause = false;
          width = 50;
          height = 20;
          horizontalPosition = "bottom";
          separateTab = false;
          indicators = "auto";
          lean3 = {
            showFilter = true;
            mouseEvents = false;
          };
          showProcessing = true;
          showNoInfoMessage = false;
          useWidgets = true;
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
        progressBars = {
          enable = true;
          priority = 10;
        };
        stderr = {
          enable = true;
          height = 5;
          onLines = "function(lines) vim.notify(lines) end";
        };
        lsp3 = { };
      };
    };
  };
}
