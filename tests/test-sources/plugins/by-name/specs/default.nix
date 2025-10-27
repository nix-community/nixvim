{
  empty = {
    plugins.specs.enable = true;
  };

  example = {
    plugins.specs = {
      enable = true;
      settings = {
        show_jumps = true;
        min_jump = 30;
        popup = {
          delay_ms = 0;
          inc_ms = 10;
          blend = 10;
          width = 10;
          winhl = "PMenu";
          fader = ''
            function(blend, cnt)
                if cnt > 100 then
                    return 80
                else return nil end
            end
          '';
          resizer = ''
            function(width, ccol, cnt)
                if width-cnt > 0 then
                    return {width+cnt, ccol}
                else return nil end
            end
          '';
        };
        ignore_filetypes.__empty = { };
        ignore_buftypes = {
          nofile = true;
        };
      };
    };
  };

  defaults = {
    plugins.specs = {
      enable = true;
      settings = {

        show_jumps = true;
        min_jump = 30;
        popup = {
          delay_ms = 10;
          inc_ms = 5;
          blend = 10;
          width = 20;
          winhl = "PMenu";
          fader = "require('specs').linear_fader";
          resizer = "require('specs').shrink_resizer";
        };
        ignore_filetypes.__empty = { };
        ignore_buftypes = {
          nofile = true;
        };
      };
    };
  };
}
