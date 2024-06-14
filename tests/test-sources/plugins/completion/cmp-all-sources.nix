{ pkgs, cmp-sources, ... }:
{
  all-sources = {
    plugins = {
      copilot-lua = {
        enable = true;

        panel.enabled = false;
        suggestion.enabled = false;
      };

      cmp = {
        enable = true;
        settings.sources =
          with pkgs.lib;
          let
            disabledSources = [
              # We do not provide the required HF_API_KEY environment variable.
              "cmp_ai"
            ] ++ optional (pkgs.stdenv.hostPlatform.system == "aarch64-linux") "cmp_tabnine";

            filterFunc = sourceName: !(elem sourceName disabledSources);

            sourceNames = filter filterFunc (attrNames cmp-sources);
          in
          map (sourceName: { name = sourceName; }) sourceNames;
      };
    };
  };
}
