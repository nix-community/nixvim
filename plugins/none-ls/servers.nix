{
  pkgs,
  config,
  lib,
  helpers,
  ...
}:
with lib; let
  noneLsBuiltins = builtins.fromJSON (
    builtins.readFile "${pkgs.vimPlugins.none-ls-nvim.src}/doc/builtins.json"
  );

  # Can contain either:
  #  - a package
  #  - null if the source is not present in nixpkgs
  #  - false if this source does not need a package
  builtinPackages = {
    inherit
      (pkgs)
      alejandra
      asmfmt
      astyle
      beancount
      beautysh
      cbfmt
      checkstyle
      cppcheck
      deadnix
      fantomas
      fnlfmt
      gitlint
      gofumpt
      golines
      hadolint
      isort
      jq
      ktlint
      mypy
      nixfmt
      prettierd
      protolint
      pylint
      revive
      ruff
      rustfmt
      shellcheck
      shfmt
      sqlfluff
      statix
      stylelint
      stylua
      taplo
      typos
      vale
      yamlfmt
      yamllint
      ;
    inherit
      (pkgs.nodePackages)
      alex
      eslint
      eslint_d
      prettier
      ;
    inherit
      (pkgs.python3.pkgs)
      bandit
      black
      flake8
      vulture
      ;
    inherit
      (pkgs.luaPackages)
      luacheck
      ;
    inherit
      (pkgs.haskellPackages)
      fourmolu
      ;
    inherit
      (pkgs.phpPackages)
      phpcbf
      ;
    ansiblelint = pkgs.ansible-lint;
    bean_format = pkgs.beancount;
    gitsigns = pkgs.git;
    gofmt = pkgs.go;
    goimports = pkgs.gotools;
    goimports_reviser = pkgs.goimports-reviser;
    golangci_lint = pkgs.golangci-lint;
    google_java_format = pkgs.google-java-format;
    ltrs = pkgs.languagetool-rust;
    markdownlint = pkgs.nodePackages.markdownlint-cli;
    nixpkgs_fmt = pkgs.nixpkgs-fmt;
    ruff_format = pkgs.ruff;
    staticcheck = pkgs.go-tools;
    trim_newlines = pkgs.gawk;
    trim_whitespace = pkgs.gawk;
    write_good = pkgs.write-good;

    # Sources not present in nixpkgs
    pint = null;
  };

  # Check if the package is set to `false` or not
  hasBuiltinPackage = source:
    if builtins.hasAttr source builtinPackages
    then !(builtins.isBool builtinPackages.${source})
    else true;

  builtinPackage = source: builtinPackages.${source} or null;
in {
  imports = [
    ./prettier.nix
  ];

  options.plugins.none-ls.sources =
    builtins.mapAttrs (
      sourceType: sources:
        builtins.mapAttrs
        (source: _:
          {
            enable = mkEnableOption "the ${source} ${sourceType} source for none-ls";
            withArgs = helpers.mkNullOrLua ''
              Raw Lua code passed as an argument to the source's `with` method.
            '';
          }
          // lib.optionalAttrs (hasBuiltinPackage source) {
            package = let
              pkg = builtinPackage source;
            in
              mkOption ({
                  type = types.nullOr types.package;
                  description =
                    "Package to use for ${source} by none-ls. "
                    + (
                      lib.optionalString (pkg == null) ''
                        Not handled in nixvim, either install externally and set to null or set the option with a derivation.
                      ''
                    );
                }
                // optionalAttrs (pkg != null) {
                  default = pkg;
                });
          })
        sources
    )
    noneLsBuiltins;

  config = let
    cfg = config.plugins.none-ls;
    gitsignsEnabled = cfg.sources.code_actions.gitsigns.enable;

    flattenedSources = lib.flatten (
      lib.mapAttrsToList (
        sourceType: sources: (lib.mapAttrsToList (sourceName: source:
          source
          // {
            inherit sourceType sourceName;
          })
        sources)
      )
      cfg.sources
    );

    enabledSources = builtins.filter (source: source.enable) flattenedSources;
  in
    mkIf cfg.enable {
      plugins.none-ls.sourcesItems =
        builtins.map (
          source: let
            sourceItem = "${source.sourceType}.${source.sourceName}";
            withArgs =
              if source.withArgs == null
              then sourceItem
              else "${sourceItem}.with(${source.withArgs}})";
          in
            helpers.mkRaw ''
              require("null-ls").builtins.${withArgs}
            ''
        )
        enabledSources;
      plugins.gitsigns.enable = mkIf gitsignsEnabled true;
      extraPackages = builtins.filter (p: p != null) (
        builtins.map (
          source: source.package or null
        )
        enabledSources
      );
    };
}
