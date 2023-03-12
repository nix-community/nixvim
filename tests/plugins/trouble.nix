{
  # Empty configuration
  empty = {
    plugins.trouble.enable = true;
  };

  # All the upstream default options of trouble
  defaults = {
    plugins.trouble = {
      enable = true;

      position = "bottom";
      height = 10;
      width = 50;
      icons = true;
      mode = "workspace_diagnostics";
      foldOpen = "";
      foldClosed = "";
      group = true;
      padding = true;
      actionKeys = {
        close = "q";
        cancel = "<esc>";
        refresh = "r";
        jump = ["<cr>" "<tab>"];
        openSplit = ["<c-x>"];
        openVsplit = ["<c-v>"];
        openTab = ["<c-t>"];
        jumpClose = ["o"];
        toggleMode = "m";
        togglePreview = "P";
        hover = "K";
        preview = "p";
        closeFolds = ["zM" "zm"];
        openFolds = ["zR" "zr"];
        toggleFold = ["zA" "za"];
        previous = "k";
        next = "j";
      };
      indentLines = true;
      autoOpen = false;
      autoClose = false;
      autoPreview = true;
      autoFold = false;
      autoJump = ["lsp_definitions"];
      signs = {
        error = "";
        warning = "";
        hint = "";
        information = "";
        other = "﫠";
      };
      useDiagnosticSigns = false;
    };
  };
}
