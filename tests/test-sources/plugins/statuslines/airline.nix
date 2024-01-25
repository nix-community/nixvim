{
  empty = {
    plugins.airline.enable = true;
  };

  example = {
    plugins.airline = {
      enable = true;

      sectionA = "foo";
      sectionB = "foo";
      sectionC = "foo";
      sectionX = "foo";
      sectionY = "foo";
      sectionZ = "foo";
      experimental = true;
      leftSep = ">";
      rightSep = "<";
      detectModified = true;
      detectPaste = true;
      detectCrypt = true;
      detectSpell = true;
      detectSpelllang = true;
      detectIminsert = false;
      inactiveCollapse = true;
      inactiveAltSep = true;
      theme = "dark";
      themePatchFunc = null;
      powerlineFonts = false;
      symbolsAscii = false;
      modeMap = {
        __ = "-";
        c = "C";
        i = "I";
        ic = "I";
        ix = "I";
        n = "N";
        multi = "M";
        ni = "N";
        no = "N";
        R = "R";
        Rv = "R";
        s = "S";
        S = "S";
        t = "T";
        v = "V";
        V = "V";
      };
      excludeFilenames = [];
      excludeFiletypes = [];
      filetypeOverrides = {
        coc-explorer = ["CoC Explorer" ""];
        defx = ["defx" "%{b:defx.paths[0]}"];
        fugitive = ["fugitive" "%{airline#util#wrap(airline#extensions#branch#get_head(),80)}"];
        gundo = ["Gundo" ""];
        help = ["Help" "%f"];
        minibufexpl = ["MiniBufExplorer" ""];
        startify = ["startify" ""];
        vim-plug = ["Plugins" ""];
        vimfiler = ["vimfiler" "%{vimfiler#get_status_string()}"];
        vimshell = ["vimshell" "%{vimshell#get_status_string()}"];
        vaffle = ["Vaffle" "%{b:vaffle.dir}"];
      };
      excludePreview = false;
      disableStatusline = false;
      skipEmptySections = true;
      highlightingCache = false;
      focuslostInactive = false;
      statuslineOntop = false;
      stlPathStyle = "short";
      sectionCOnlyFilename = true;
      symbols = {
        branch = "";
        colnr = " ℅:";
        readonly = "";
        linenr = " :";
        maxlinenr = "☰ ";
        dirty = "⚡";
      };
    };
  };
}
