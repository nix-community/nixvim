{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  settingsOptions = {
    fzf_bin = helpers.mkNullOrStr ''
      The path to the `fzf` binary to use.

      Example: `"skim"`
    '';
  };
  settingsExample = {
    winopts = {
      height = 0.4;
      width = 0.93;
      row = 0.99;
      col = 0.3;
    };
    files = {
      find_opts.__raw = "[[-type f -not -path '*.git/objects*' -not -path '*.env*']]";
      prompt = "Files❯ ";
      multiprocess = true;
      file_icons = true;
      color_icons = true;
    };
  };
in
  helpers.neovim-plugin.mkNeovimPlugin config {
    name = "fzf-lua";
    defaultPackage = pkgs.vimPlugins.fzf-lua;

    extraPackages = [pkgs.fzf];

    maintainers = [maintainers.GaetanLepage];

    inherit settingsOptions settingsExample;

    extraOptions = {
      fzfPackage = mkOption {
        type = with types; nullOr package;
        default = pkgs.fzf;
        description = ''
          The fzf package to use.
          Set to `null` to not install any package.
        '';
        example = pkgs.skim;
      };

      iconsEnabled = mkOption {
        type = types.bool;
        description = "Toggle icon support. Installs nvim-web-devicons.";
        default = true;
      };

      profile = helpers.defaultNullOpts.mkEnumFirstDefault [
        "default"
        "fzf-native"
        "fzf-tmux"
        "fzf-vim"
        "max-perf"
        "telescope"
        "skim"
      ] "Preconfigured profile to use";

      keymaps = mkOption {
        type = with types;
          attrsOf (
            either str (submodule {
              options = {
                action = mkOption {
                  type = types.str;
                  description = "The `fzf-lua` action to run";
                  example = "git_files";
                };
                settings = helpers.mkSettingsOption {
                  options = settingsOptions;
                  description = "`fzf-lua` settings for this command.";
                  example = settingsExample;
                };
                mode = helpers.keymaps.mkModeOption "n";
                options = helpers.keymaps.mapConfigOptions;
              };
            })
          );
        description = "Keymaps for Fzf-Lua.";
        default = {};
        example = {
          "<leader>fg" = "live_grep";
          "<C-p>" = {
            action = "git_files";
            settings = {
              previewers.cat.cmd = "${pkgs.coreutils}/bin/cat";
              winopts.height = 0.5;
            };
            options = {
              silent = true;
              desc = "Fzf-Lua Git Files";
            };
          };
        };
      };
    };

    extraConfig = cfg: {
      extraPlugins = optional cfg.iconsEnabled pkgs.vimPlugins.nvim-web-devicons;

      extraPackages = optional (cfg.fzfPackage != null) cfg.fzfPackage;

      plugins.fzf-lua.settings.__unkeyed_profile = cfg.profile;

      keymaps =
        mapAttrsToList (
          key: mapping: let
            actionStr =
              if isString mapping
              then "${mapping}()"
              else "${mapping.action}(${helpers.toLuaObject mapping.settings})";
          in {
            inherit key;
            mode = mapping.mode or "n";
            action.__raw = "function() require('fzf-lua').${actionStr} end";
            options = mapping.options or {};
          }
        )
        cfg.keymaps;
    };
  }
