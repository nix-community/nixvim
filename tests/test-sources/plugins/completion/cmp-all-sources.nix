{
  pkgs,
  cmp-sources,
  ...
}: {
  all-sources = {
    plugins = {
      copilot-lua = {
        enable = true;

        panel.enabled = false;
        suggestion.enabled = false;
      };

      cmp = {
        enable = true;
        settings.sources = with pkgs.lib; let
          disabledSources =
            optional
            (pkgs.stdenv.hostPlatform.system == "aarch64-linux")
            "cmp_tabnine";

          filterFunc = sourceName: !(elem sourceName disabledSources);

          sourceNames =
            filter
            filterFunc
            (attrNames cmp-sources);
        in
          map
          (
            sourceName: {name = sourceName;}
          )
          sourceNames;
      };
    };
  };
}
