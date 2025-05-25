{ lib, ... }:
let
  inherit (lib.nixvim) nestedLiteralLua;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-starter";
  moduleName = "mini.starter";
  packPathName = "mini.starter";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    autoopen = true;
    content_hooks = [
      (nestedLiteralLua "require(\"mini.starter\").gen_hook.adding_bullet()")
      (nestedLiteralLua "require(\"mini.starter\").gen_hook.indexing('all', { 'Builtin actions' })")
      (nestedLiteralLua "require(\"mini.starter\").gen_hook.aligning('center', 'center')")
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
      (nestedLiteralLua "require(\"mini.starter\").sections.builtin_actions()")
      (nestedLiteralLua "require(\"mini.starter\").sections.recent_files(10, false)")
      (nestedLiteralLua "require(\"mini.starter\").sections.recent_files(10, true)")
      (nestedLiteralLua "require(\"mini.starter\").sections.sessions(5, true)")
    ];
  };
}
