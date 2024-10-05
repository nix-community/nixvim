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
        ast_grep.enable = true;
        astro.enable = true;
        basedpyright.enable = true;
        bashls.enable = true;
        beancount.enable = true;
        biome.enable = true;
        bufls.enable = true;
        ccls.enable = true;
        clangd.enable = true;
        clojure_lsp.enable = true;
        cmake.enable = true;
        csharp_ls.enable = true;
        cssls.enable = true;
        dagger.enable = true;
        dartls.enable = true;
        denols.enable = true;
        dhall_lsp_server.enable = true;
        digestif.enable = true;
        docker_compose_language_service.enable = true;
        dockerls.enable = true;
        efm.enable = true;
        elmls.enable = true;
        emmet_ls.enable = true;
        eslint.enable = true;
        elixirls.enable = true;
        fortls.enable = true;
        # pkgs.fsautocomplete only supports linux platforms
        fsautocomplete.enable = pkgs.stdenv.isLinux;
        futhark_lsp.enable = true;
        gleam.enable = true;
        gopls.enable = true;
        golangci_lint_ls.enable = true;
        graphql.enable = true;
        harper_ls.enable = true;
        helm_ls.enable = true;
        hls.enable = true;
        html.enable = true;
        htmx.enable = true;
        idris2_lsp.enable = true;
        java_language_server.enable = true;
        jdtls.enable = true;
        jsonls.enable = true;
        jsonnet_ls.enable = true;
        julials.enable = true;
        kotlin_language_server.enable = true;
        leanls.enable = true;
        lemminx.enable = true;
        lexical.enable = true;
        ltex.enable = true;
        lua_ls.enable = true;
        marksman.enable = true;
        metals.enable = true;
        nextls.enable = true;
        nginx_language_server.enable = true;
        nickel_ls.enable = true;
        nil_ls.enable = true;
        nimls.enable = true;
        nixd.enable = true;
        nushell.enable = true;
        ocamllsp.enable = true;
        ols.enable =
          # ols is not supported on aarch64-linux
          pkgs.stdenv.hostPlatform.system != "aarch64-linux";
        omnisharp.enable = true;
        openscad_lsp.enable = true;
        perlpls.enable = true;
        pest_ls.enable = true;
        prismals.enable = true;
        prolog_ls.enable = true;
        purescriptls.enable = true;
        pylsp.enable = true;
        pylyzer.enable = true;
        pyright.enable = true;
        r_language_server.enable = true;
        ruby_lsp.enable = true;
        ruff.enable = true;
        ruff_lsp.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
        slint_lsp.enable = true;
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
        ts_ls.enable = true;
        typos_lsp.enable = true;
        typst_lsp.enable = true;
        vala_ls.enable = true;
        vhdl_ls.enable = true;
        vls.enable = true;
        vuels.enable = true;
        yamlls.enable = true;
        zls.enable = true;
      };
    };
  }
