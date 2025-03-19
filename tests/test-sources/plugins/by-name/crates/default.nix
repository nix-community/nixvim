{
  empty = {
    plugins.crates.enable = true;
    # Explicit disable to suppress warnings
    plugins.cmp.enable = false;
  };

  defaults = {
    plugins.crates = {
      enable = true;

      settings = {
        smart_insert = true;
        insert_closing_quote = true;
        autoload = true;
        autoupdate = true;
        autoupdate_throttle = 250;
        loading_indicator = true;
        search_indicator = true;
        date_format = "%Y-%m-%d";
        thousands_separator = ".";
        notification_title = "crates.nvim";
        curl_args = [
          "-sL"
          "--retry"
          "1"
        ];
        max_parallel_requests = 80;
        expand_crate_moves_cursor = true;
        enable_update_available_warning = true;
        on_attach.__raw = "function(bufnr) end";
        text = {
          searching = "   Searching";
          loading = "   Loading";
          version = "   %s";
          prerelease = "   %s";
          yanked = "   %s";
          nomatch = "   No match";
          upgrade = "   %s";
          error = "   Error fetching crate";
        };
        highlight = {
          searching = "CratesNvimSearching";
          loading = "CratesNvimLoading";
          version = "CratesNvimVersion";
          prerelease = "CratesNvimPreRelease";
          yanked = "CratesNvimYanked";
          nomatch = "CratesNvimNoMatch";
          upgrade = "CratesNvimUpgrade";
          error = "CratesNvimError";
        };
        popup = {
          autofocus = false;
          hide_on_select = false;
          copy_register = "\"";
          style = "minimal";
          border = "none";
          show_version_date = false;
          show_dependency_version = true;
          max_height = 30;
          min_width = 20;
          padding = 1;
          text = {
            title = " %s";
            pill_left = "";
            pill_right = "";
            description = "%s";
            created_label = " created        ";
            created = "%s";
            updated_label = " updated        ";
            updated = "%s";
            downloads_label = " downloads      ";
            downloads = "%s";
            homepage_label = " homepage       ";
            homepage = "%s";
            repository_label = " repository     ";
            repository = "%s";
            documentation_label = " documentation  ";
            documentation = "%s";
            crates_io_label = " crates.io      ";
            crates_io = "%s";
            lib_rs_label = " lib.rs         ";
            lib_rs = "%s";
            categories_label = " categories     ";
            keywords_label = " keywords       ";
            version = "  %s";
            prerelease = " %s";
            yanked = " %s";
            version_date = "  %s";
            feature = "  %s";
            enabled = " %s";
            transitive = " %s";
            normal_dependencies_title = " Dependencies";
            build_dependencies_title = " Build dependencies";
            dev_dependencies_title = " Dev dependencies";
            dependency = "  %s";
            optional = " %s";
            dependency_version = "  %s";
            loading = "  ";
          };
          highlight = {
            title = "CratesNvimPopupTitle";
            pill_text = "CratesNvimPopupPillText";
            pill_border = "CratesNvimPopupPillBorder";
            description = "CratesNvimPopupDescription";
            created_label = "CratesNvimPopupLabel";
            created = "CratesNvimPopupValue";
            updated_label = "CratesNvimPopupLabel";
            updated = "CratesNvimPopupValue";
            downloads_label = "CratesNvimPopupLabel";
            downloads = "CratesNvimPopupValue";
            homepage_label = "CratesNvimPopupLabel";
            homepage = "CratesNvimPopupUrl";
            repository_label = "CratesNvimPopupLabel";
            repository = "CratesNvimPopupUrl";
            documentation_label = "CratesNvimPopupLabel";
            documentation = "CratesNvimPopupUrl";
            crates_io_label = "CratesNvimPopupLabel";
            crates_io = "CratesNvimPopupUrl";
            lib_rs_label = "CratesNvimPopupLabel";
            lib_rs = "CratesNvimPopupUrl";
            categories_label = "CratesNvimPopupLabel";
            keywords_label = "CratesNvimPopupLabel";
            version = "CratesNvimPopupVersion";
            prerelease = "CratesNvimPopupPreRelease";
            yanked = "CratesNvimPopupYanked";
            version_date = "CratesNvimPopupVersionDate";
            feature = "CratesNvimPopupFeature";
            enabled = "CratesNvimPopupEnabled";
            transitive = "CratesNvimPopupTransitive";
            normal_dependencies_title = "CratesNvimPopupNormalDependenciesTitle";
            build_dependencies_title = "CratesNvimPopupBuildDependenciesTitle";
            dev_dependencies_title = "CratesNvimPopupDevDependenciesTitle";
            dependency = "CratesNvimPopupDependency";
            optional = "CratesNvimPopupOptional";
            dependency_version = "CratesNvimPopupDependencyVersion";
            loading = "CratesNvimPopupLoading";
          };
          keys = {
            hide = [
              "q"
              "<esc>"
            ];
            open_url = [ "<cr>" ];
            select = [ "<cr>" ];
            select_alt = [ "s" ];
            toggle_feature = [ "<cr>" ];
            copy_value = [ "yy" ];
            goto_item = [
              "gd"
              "K"
              "<C-LeftMouse>"
            ];
            jump_forward = [ "<c-i>" ];
            jump_back = [
              "<c-o>"
              "<C-RightMouse>"
            ];
          };
        };
        completion = {
          insert_closing_quote = true;
          text = {
            prerelease = "  pre-release ";
            yanked = "  yanked ";
          };
          cmp = {
            enabled = false;
            use_custom_kind = true;
            kind_text = {
              version = "Version";
              feature = "Feature";
            };
            kind_highlight = {
              version = "CmpItemKindVersion";
              feature = "CmpItemKindFeature";
            };
          };
          coq = {
            enabled = false;
            name = "crates.nvim";
          };
          crates = {
            enabled = false;
            min_chars = 3;
            max_results = 8;
          };
        };
        null_ls = {
          enabled = false;
          name = "crates.nvim";
        };
        neoconf = {
          enabled = false;
          namespace = "crates";
        };
        lsp = {
          enabled = false;
          name = "crates.nvim";
          on_attach.__raw = "function(client, bufnr) end";
          actions = false;
          completion = false;
          hover = false;
        };
      };
    };
    # Explicit disable to suppress warnings
    plugins.cmp.enable = false;
  };

  example = {
    plugins.crates = {
      enable = true;

      settings = {
        smart_insert = true;
        autoload = true;
        autoupdate = true;
      };
    };
    # Explicit disable to suppress warnings
    plugins.cmp.enable = false;
  };
}
