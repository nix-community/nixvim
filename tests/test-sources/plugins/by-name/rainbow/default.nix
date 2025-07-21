{
  empty = {
    plugins.rainbow.enable = true;
  };

  defaults = {
    plugins.rainbow = {
      enable = true;
      settings = {
        conf = {
          guifgs = [
            "royalblue3"
            "darkorange3"
            "seagreen3"
            "firebrick"
          ];
          ctermfgs = [
            "lightblue"
            "lightyellow"
            "lightcyan"
            "lightmagenta"
          ];
          guis = [ "" ];
          cterms = [ "" ];
          operators = "_,_";
          contains_prefix = "TOP";
          parentheses_options = "";
          parentheses = [
            "start=/(/ end=/)/ fold"
            "start=/\\[/ end=/\\]/ fold"
            "start=/{/ end=/}/ fold"
          ];
          separately = {
            markdown = {
              parentheses_options = "containedin=markdownCode contained";
            };
            lisp = {
              guifgs = [
                "royalblue3"
                "darkorange3"
                "seagreen3"
                "firebrick"
                "darkorchid3"
              ];
            };
            haskell = {
              parentheses = [
                "start=/(/ end=/)/ fold"
                "start=/\\[/ end=/\\]/ fold"
                "start=/\v\{\ze[^-]/ end=/}/ fold"
              ];
            };
            tex = {
              parentheses_options = "containedin=texDocZone";
              parentheses = [
                "start=/(/ end=/)/"
                "start=/\\[/ end=/\\]/"
              ];
            };
            vim = {
              parentheses_options = "containedin=vimFuncBody,vimExecute";
              parentheses = [
                "start=/(/ end=/)/"
                "start=/\\[/ end=/\\]/"
                "start=/{/ end=/}/ fold"
              ];
            };
            perl = {
              syn_name_prefix = "perlBlockFoldRainbow";
            };
            stylus = {
              parentheses = [ "start=/{/ end=/}/ fold contains=@colorableGroup" ];
            };
            css = 0;
            sh = 0;
            vimwiki = 0;
          };
        };
      };
    };
  };

  example = {
    plugins.rainbow = {
      enable = true;
      settings = {
        active = 1;
        conf = {
          guifgs = [
            "#7d8618"
            "darkorange3"
            "seagreen3"
            "firebrick"
          ];
          parentheses = [
            "start=/(/ end=/)/ fold"
            "start=/\\[/ end=/\\]/ fold"
          ];
          separately = {
            "*" = { };
            haskell = {
              parentheses = [
                "start=/\\[/ end=/\\]/ fold"
                "start=/\v\{\ze[^-]/ end=/}/ fold"
              ];
            };
          };
        };
      };
    };
  };
}
