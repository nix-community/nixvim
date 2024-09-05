{
  lib,
  ...
}:
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "mini";
  originalName = "mini.nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  package = "mini-nvim";

  extraOptions = {
    modules = lib.mkOption {
      type = with lib.types; attrsOf (attrsOf anything);
      default = { };
      description = ''
        Enable and configure the mini modules.

        The attr name represent mini's module names, without the `"mini."` prefix.
        The attr value is an attrset of options provided to the module's `setup` function.

        See the [plugin documentation] for available modules to configure:

        [plugin documentation]: https://github.com/echasnovski/mini.nvim?tab=readme-ov-file#modules
      '';
      example = {
        ai = {
          n_lines = 50;
          search_method = "cover_or_next";
        };
        diff = {
          view = {
            style = "sign";
          };
        };
        comment = {
          mappings = {
            comment = "<leader>/";
            comment_line = "<leader>/";
            comment_visual = "<leader>/";
            textobject = "<leader>/";
          };
        };
        surround = {
          mappings = {
            add = "gsa";
            delete = "gsd";
            find = "gsf";
            find_left = "gsF";
            highlight = "gsh";
            replace = "gsr";
            update_n_lines = "gsn";
          };
        };
        starter = {
          header = ''
            ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗
            ████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║
            ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║
            ██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║
            ██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║
          '';
          evaluate_single = true;
          items = {
            "__unkeyed-1.buildtin_actions".__raw = "require('mini.starter').sections.builtin_actions()";
            "__unkeyed-2.recent_files_current_directory".__raw = "require('mini.starter').sections.recent_files(10, false)";
            "__unkeyed-3.recent_files".__raw = "require('mini.starter').sections.recent_files(10, true)";
            "__unkeyed-4.sessions".__raw = "require('mini.starter').sections.sessions(5, true)";
          };
          content_hooks = {
            "__unkeyed-1.adding_bullet".__raw = "require('mini.starter').gen_hook.adding_bullet()";
            "__unkeyed-2.indexing".__raw = "require('mini.starter').gen_hook.indexing('all', { 'Builtin actions' })";
            "__unkeyed-3.padding".__raw = "require('mini.starter').gen_hook.aligning('center', 'center')";
          };
        };
      };
    };
  };

  # NOTE: We handle each module explicitly and not a parent settings table
  callSetup = false;
  hasSettings = false;
  extraConfig = cfg: {
    extraConfigLua = lib.foldlAttrs (lines: name: config: ''
      ${lines}
      require(${lib.nixvim.toLuaObject "mini.${name}"}).setup(${lib.nixvim.toLuaObject config})
    '') "" cfg.modules;
  };
}
