{ pkgs, ... }:
pkgs.lib.optionalAttrs
  # This fails on darwin
  # See https://github.com/NixOS/nix/issues/4119
  (!pkgs.stdenv.isDarwin)
  {
    plugins.lsp = {
      enable = true;

      servers = {
        ansiblels.enable = true;
        ast-grep.enable = true;
        astro.enable = true;
        basedpyright.enable = true;
        bashls.enable = true;
        beancount.enable = true;
        biome.enable = true;
        bufls.enable = true;
        ccls.enable = true;
        clangd.enable = true;
        clojure-lsp.enable = true;
        cmake.enable = true;
        csharp-ls.enable = true;
        cssls.enable = true;
        dagger.enable = true;
        dartls.enable = true;
        denols.enable = true;
        dhall-lsp-server.enable = true;
        digestif.enable = true;
        docker-compose-language-service.enable = true;
        dockerls.enable = true;
        efm.enable = true;
        elmls.enable = true;
        emmet-ls.enable = true;
        eslint.enable = true;
        elixirls.enable = true;
        fortls.enable = true;
        # pkgs.fsautocomplete only supports linux platforms
        fsautocomplete.enable = pkgs.stdenv.isLinux;
        futhark-lsp.enable = true;
        gleam.enable = true;
        gopls.enable = true;
        golangci-lint-ls.enable = true;
        graphql.enable = true;
        harper-ls.enable = true;
        helm-ls.enable = true;
        hls.enable = true;
        html.enable = true;
        htmx.enable = true;
        idris2-lsp.enable = true;
        java-language-server.enable = true;
        jdt-language-server.enable = true;
        jsonls.enable = true;
        jsonnet-ls.enable = true;
        julials.enable = true;
        kotlin-language-server.enable = true;
        leanls.enable = true;
        lemminx.enable = true;
        lexical.enable = true;
        ltex.enable = true;
        lua-ls.enable = true;
        marksman.enable = true;
        metals.enable = true;
        nextls.enable = true;
        nginx-language-server.enable = true;
        nickel-ls.enable = true;
        nil-ls.enable = true;
        nimls.enable = true;
        nixd.enable = true;
        nushell.enable = true;
        ocamllsp.enable = true;
        ols.enable =
          # ols is not supported on aarch64-linux
          pkgs.stdenv.hostPlatform.system != "aarch64-linux";
        omnisharp.enable = true;
        openscad-lsp.enable = true;
        perlpls.enable = true;
        pest-ls.enable = true;
        prismals.enable = true;
        prolog-ls.enable = true;
        purescriptls.enable = true;
        pylsp.enable = true;
        pylyzer.enable = true;
        pyright.enable = true;
        r-language-server.enable = true;
        ruby-lsp.enable = true;
        ruff.enable = true;
        ruff-lsp.enable = true;
        rust-analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
        slint-lsp.enable = true;
        solargraph.enable = true;
        # As of 2024-09-13, sourcekit-lsp is broken due to swift dependency
        # TODO: re-enable this test when fixed
        # sourcekit.enable = !pkgs.stdenv.isAarch64;
        sqls.enable = true;
        svelte.enable = true;
        tailwindcss.enable = true;
        taplo.enable = true;
        templ.enable = true;
        terraformls.enable = true;
        texlab.enable = true;
        tflint.enable = true;
        tinymist.enable = true;
        ts-ls.enable = true;
        typos-lsp.enable = true;
        typst-lsp.enable = true;
        vala-ls.enable = true;
        vhdl-ls.enable = true;
        vls.enable = true;
        vuels.enable = true;
        yamlls.enable = true;
        zls.enable = true;
      };
    };
  }
