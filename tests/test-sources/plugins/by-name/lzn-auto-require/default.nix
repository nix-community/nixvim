{
  e2e =
    { lib, ... }:
    {
      plugins.lz-n.enable = true;
      plugins.lzn-auto-require.enable = true;

      plugins.smart-splits = {
        enable = true;
        lazyLoad.settings.lazy = true; # manual lazy-loading
      };

      extraConfigLuaPost = lib.mkMerge [
        (lib.mkOrder 4999 ''
          local success, _ = pcall(require, 'smart-splits')
          if success then
            print("require should not succeed")
          end
        '')
        (lib.mkOrder 5001 ''
          local success, _ = pcall(require, 'smart-splits')
          if not success then
            print("require should succeed")
          end
        '')
      ];
    };
}
