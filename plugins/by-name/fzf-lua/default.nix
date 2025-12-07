{ lib, ... }:
let
  inherit (lib) types mkOption;
  settingsOptions = {
    fzf_bin = lib.nixvim.mkNullOrStr ''
      The path to the `fzf` binary to use.

      Example: `"sk"`
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
lib.nixvim.plugins.mkNeovimPlugin {
  name = "fzf-lua";
  description = "`fzf` powered fuzzy finder for Neovim written in Lua.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  inherit settingsOptions settingsExample;

  dependencies = [ "fzf" ];

  extraOptions = {
    profile = lib.nixvim.defaultNullOpts.mkEnumFirstDefault [
      "default"
      "fzf-native"
      "fzf-tmux"
      "fzf-vim"
      "max-perf"
      "telescope"
      "skim"
    ] "Preconfigured profile to use";

    keymaps = mkOption {
      type =
        with types;
        attrsOf (
          either str (submodule {
            options = {
              action = mkOption {
                type = types.str;
                description = "The `fzf-lua` action to run";
                example = "git_files";
              };
              settings = lib.nixvim.mkSettingsOption {
                options = settingsOptions;
                description = "`fzf-lua` settings for this command.";
                example = settingsExample;
              };
              mode = lib.nixvim.keymaps.mkModeOption "n";
              options = lib.nixvim.keymaps.mapConfigOptions;
            };
          })
        );
      description = "Keymaps for Fzf-Lua.";
      default = { };
      example = lib.literalExpression ''
        {
          "<leader>fg" = "live_grep";
          "<C-p>" = {
            action = "git_files";
            settings = {
              previewers.cat.cmd = lib.getExe' pkgs.coreutils "cat";
              winopts.height = 0.5;
            };
            options = {
              silent = true;
              desc = "Fzf-Lua Git Files";
            };
          };
        };
      '';
    };
  };

  extraConfig = cfg: {
    dependencies.skim.enable = lib.mkIf (cfg.profile == "skim" || cfg.settings.fzf_bin == "sk") (
      lib.mkDefault true
    );

    plugins.fzf-lua.settings.__unkeyed_profile = cfg.profile;

    keymaps = lib.mapAttrsToList (
      key: mapping:
      let
        actionStr =
          if lib.isString mapping then
            "${mapping}()"
          else
            "${mapping.action}(${lib.nixvim.toLuaObject mapping.settings})";
      in
      {
        inherit key;
        mode = mapping.mode or "n";
        action.__raw = "function() require('fzf-lua').${actionStr} end";
        options = mapping.options or { };
      }
    ) cfg.keymaps;
  };
}
