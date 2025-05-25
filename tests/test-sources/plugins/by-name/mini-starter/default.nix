{ lib, ... }:
{
  empty = {
    plugins.mini-starter.enable = true;
  };

  example = {
    plugins.mini-starter = {
      enable = true;
      settings = {
        autoopen = true;
        content_hooks = [
          (lib.nixvim.mkRaw "require(\"mini.starter\").gen_hook.adding_bullet()")
          (lib.nixvim.mkRaw "require(\"mini.starter\").gen_hook.indexing('all', { 'Builtin actions' })")
          (lib.nixvim.mkRaw "require(\"mini.starter\").gen_hook.aligning('center', 'center')")
        ];
        evaluate_single = true;
        header = ''
          ███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗
          ████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║
          ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║
          ██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║
          ██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║
        '';
        items = [
          (lib.nixvim.mkRaw "require(\"mini.starter\").sections.builtin_actions()")
          (lib.nixvim.mkRaw "require(\"mini.starter\").sections.recent_files(10, false)")
          (lib.nixvim.mkRaw "require(\"mini.starter\").sections.recent_files(10, true)")
          (lib.nixvim.mkRaw "require(\"mini.starter\").sections.sessions(5, true)")
        ];
      };
    };
  };
}
