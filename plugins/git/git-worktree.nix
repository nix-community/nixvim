{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.git-worktree;
in {
  options = {
    plugins.git-worktree = {
      enable = mkEnableOption "git-worktree";

      package = helpers.mkPackageOption "git-worktree" pkgs.vimPlugins.git-worktree-nvim;

      enableTelescope = mkEnableOption "telescope integration";

      changeDirectoryCommand = helpers.defaultNullOpts.mkStr "cd" ''
        The vim command used to change to the new worktree directory.
        Set this to `tcd` if you want to only change the `pwd` for the current vim Tab.
      '';

      updateOnChange = helpers.defaultNullOpts.mkBool true ''
        If set to true updates the current buffer to point to the new work tree if the file is found in the new project.
        Otherwise, the following command will be run.
      '';

      updateOnChangeCommand = helpers.defaultNullOpts.mkStr "e ." ''
        The vim command to run during the `update_on_change` event.
        Note, that this command will only be run when the current file is not found in the new worktree.
        This option defaults to `e .` which opens the root directory of the new worktree.
      '';

      clearJumpsOnChange = helpers.defaultNullOpts.mkBool true ''
        If set to true every time you switch branches, your jumplist will be cleared so that you don't
        accidentally go backward to a different branch and edit the wrong files.
      '';

      autopush = helpers.defaultNullOpts.mkBool false ''
        When creating a new worktree, it will push the branch to the upstream then perform a `git rebase`.
      '';
    };
  };

  config = let
    setupOptions = with cfg; {
      enabled = cfg.enable;
      change_directory_command = cfg.changeDirectoryCommand;
      update_on_change = cfg.updateOnChange;
      update_on_change_command = cfg.updateOnChangeCommand;
      clearjumps_on_change = cfg.clearJumpsOnChange;
      inherit autopush;
    };
  in
    mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.enableTelescope -> config.plugins.telescope.enable;
          message = ''Nixvim: The git-worktree telescope integration needs telescope to function as intended'';
        }
      ];

      extraPlugins = with pkgs.vimPlugins; [
        cfg.package
        plenary-nvim
      ];

      extraPackages = [pkgs.git];

      extraConfigLua = let
        telescopeCfg = ''require("telescope").load_extension("git_worktree")'';
      in ''
        require('git-worktree').setup(${helpers.toLuaObject setupOptions})
        ${
          if cfg.enableTelescope
          then telescopeCfg
          else ""
        }
      '';
    };
}
