{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with helpers.vim-plugin;
with lib; rec {
  mkCmpSourcePlugin = {
    name,
    extraPlugins ? [],
    useDefaultPackage ? true,
    ...
  }:
    mkVimPlugin config {
      inherit name;
      extraPlugins = extraPlugins ++ (lists.optional useDefaultPackage pkgs.vimPlugins.${name});

      maintainers = [maintainers.GaetanLepage];
    };

  extractSourcesFromOptionValue = sources:
    if isList sources
    then sources
    else [];

  autoInstallSourcePluginsModule = cfg: let
    # cfg.setup.sources
    setupSources = extractSourcesFromOptionValue cfg.settings.sources;
    # cfg.filetype.<name>.sources
    filetypeSources =
      mapAttrsToList
      (_: filetypeConfig:
        extractSourcesFromOptionValue filetypeConfig.sources)
      cfg.filetype;
    # cfg.cmdline.<name>.sources
    cmdlineSources =
      mapAttrsToList
      (_: cmdlineConfig:
        extractSourcesFromOptionValue cmdlineConfig.sources)
      cfg.cmdline;

    # [{name = "foo";} {name = "bar"; x = 42;} ...]
    allSources = flatten (setupSources ++ filetypeSources ++ cmdlineSources);

    # Take only the names from the sources provided by the user
    # ["foo" "bar"]
    foundSources =
      lists.unique
      (
        map
        (source: source.name)
        allSources
      );

    # If the user has enabled the `foo` and `bar` sources, this attrs will look like:
    # {
    #   cmp-foo.enable = true;
    #   cmp-bar.enable = true;
    # }
    attrsEnabled =
      mapAttrs'
      (
        sourceName: pluginName: {
          name = pluginName;
          value.enable =
            mkIf
            (elem sourceName foundSources)
            true;
        }
      )
      (import ./sources.nix);

    lspCapabilities =
      mkIf
      (elem "nvim_lsp" foundSources)
      {
        lsp.capabilities = ''
          capabilities = vim.tbl_deep_extend("force", capabilities, require('cmp_nvim_lsp').default_capabilities())
        '';
      };
  in
    mkMerge [
      (mkIf cfg.autoEnableSources attrsEnabled)
      lspCapabilities
    ];
}
