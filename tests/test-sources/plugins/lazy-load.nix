{
  lazy-load-plugin =
    { config, ... }:
    {
      plugins = {
        lz-n = {
          enable = true;
          plugins = [
            {
              __unkeyed-1 = "neotest";
              after.__raw = ''
                function()
                  ${config.plugins.neotest.luaConfig.content}
                end
              '';
              keys = [
                {
                  __unkeyed-1 = "<leader>nt";
                  __unkeyed-3 = "<CMD>Neotest summary<CR>";
                  desc = "Summary toggle";
                }
              ];

            }
          ];
        };

        neotest = {
          enable = true;
          lazyLoad.enable = true;
        };
      };
    };
}
