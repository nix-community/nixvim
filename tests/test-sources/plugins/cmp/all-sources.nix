{
  all-sources =
    { lib, config, ... }:
    {
      plugins = {
        copilot-lua = {
          enable = true;

          settings = {
            panel.enabled = false;
            suggestion.enabled = false;
          };
        };

        cmp = {
          enable = true;
          settings.sources =
            let
              disabledSources = [
                # We do not provide the required HF_API_KEY environment variable.
                "cmp_ai"
                # Triggers the warning complaining about treesitter highlighting being disabled
                "otter"
                # Invokes the `nix` command at startup which is not available in the sandbox
                "nixpkgs_maintainers"
                # Needs internet access to download `sm-agent`
                "supermaven"
                # Sometimes get auth error
                "codeium"
              ];
            in
            lib.pipe config.cmpSourcePlugins [
              # All known source names
              lib.attrNames
              # Filter out disabled sources
              (lib.filter (name: !(lib.elem name disabledSources)))
              # Convert names to source attributes
              (map (name: {
                inherit name;
              }))
            ];
        };
      };
    };
}
