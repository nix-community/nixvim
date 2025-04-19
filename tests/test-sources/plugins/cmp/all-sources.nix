{ pkgs, ... }:
{
  all-sources =
    { config, ... }:
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
            with pkgs.lib;
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
              ] ++ optional (pkgs.stdenv.hostPlatform.system == "aarch64-linux") "cmp_tabnine";
            in
            pipe config.cmpSourcePlugins [
              # All known source names
              attrNames
              # Filter out disabled sources
              (filter (name: !(elem name disabledSources)))
              # Convert names to source attributes
              (map (name: {
                inherit name;
              }))
            ];
        };
      };
    };
}
