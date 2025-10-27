{
  empty = {
    plugins.statuscol.enable = true;
  };

  defaults = {
    plugins.statuscol = {
      enable = true;

      settings = {
        setopt = true;
        thousands = false;
        relculright = false;
        ft_ignore.__raw = "nil";
        bt_ignore.__raw = "nil";
        segments = [
          {
            text = [ "%C" ];
            click = "v:lua.ScFa";
          }
          {
            text = [ "%s" ];
            click = "v:lua.ScSa";
          }
          {
            text = [
              { __raw = "require('statuscol.builtin').lnumfunc"; }
              " "
            ];
            condition = [
              true
              { __raw = "require('statuscol.builtin').not_empty"; }
            ];
            click = "v:lua.ScLa";
          }
          {
            sign = {
              name = [ ".*" ];
            };
          }
        ];
        clickmod = "c";
        clickhandlers = {
          Lnum = "require('statuscol.builtin').lnum_click";
          FoldClose = "require('statuscol.builtin').foldclose_click";
          FoldOpen = "require('statuscol.builtin').foldopen_click";
          FoldOther = "require('statuscol.builtin').foldother_click";
          DapBreakpointRejected = "require('statuscol.builtin').toggle_breakpoint";
          DapBreakpoint = "require('statuscol.builtin').toggle_breakpoint";
          DapBreakpointCondition = "require('statuscol.builtin').toggle_breakpoint";
          DiagnosticSignError = "require('statuscol.builtin').diagnostic_click";
          DiagnosticSignHint = "require('statuscol.builtin').diagnostic_click";
          DiagnosticSignInfo = "require('statuscol.builtin').diagnostic_click";
          DiagnosticSignWarn = "require('statuscol.builtin').diagnostic_click";
          GitSignsTopdelete = "require('statuscol.builtin').gitsigns_click";
          GitSignsUntracked = "require('statuscol.builtin').gitsigns_click";
          GitSignsAdd = "require('statuscol.builtin').gitsigns_click";
          GitSignsChange = "require('statuscol.builtin').gitsigns_click";
          GitSignsChangedelete = "require('statuscol.builtin').gitsigns_click";
          GitSignsDelete = "require('statuscol.builtin').gitsigns_click";
          gitsigns_extmark_signs_ = "require('statuscol.builtin').gitsigns_click";
        };
      };
    };
  };
}
