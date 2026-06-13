{
  extraLuaPackages = {
    extraLuaPackages = ps: [ ps.jsregexp ];
    # Make sure jsregexp is in LUA_PATH
    extraConfigLua = ''require("jsregexp")'';
  };

  # Test that all extraConfigs are present in output
  all-configs =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      configs = {
        extraConfigLuaPre = "string.format('extraConfigLuaPre1')";
        extraConfigLua = "string.format('extraConfigLua2')";
        extraConfigLuaPost = "string.format('extraConfigLuaPost3')";
        extraConfigVim = "let g:var = 'extraConfigVim4'";
      };
      mkConfigAssertions = name: value: [
        {
          assertion = lib.hasInfix "extraConfigLuaPre1" value;
          message = "Configuration file ${name} should contain extraConfigLuaPre.";
        }
        {
          assertion = lib.hasInfix "extraConfigLua2" value;
          message = "Configuration file ${name} should contain extraConfigLua.";
        }
        {
          assertion = lib.hasInfix "extraConfigLuaPost3" value;
          message = "Configuration file ${name} should contain extraConfigLuaPost.";
        }
        {
          assertion = lib.hasInfix "extraConfigVim4" value;
          message = "Configuration file ${name} should contain extraConfigVim.";
        }
      ];
    in
    configs
    // {
      files = {
        "test.lua" = configs;
        "test.vim" = configs;
      };

      extraPlugins = [
        {
          config = "let g:var = 'wrappedNeovim.initRc5'";

          # Test that final init.lua contains all config sections
          plugin = pkgs.runCommandLocal "init-lua-content-test" { } ''
            test_content() {
                if ! grep -qF "$1" "${config.build.initFile}"; then
                    echo "init.lua should contain $2" >&2
                    exit 1
                fi
            }

            test_content extraConfigLuaPre1 extraConfigLuaPre
            test_content extraConfigLua2 extraConfigLua
            test_content extraConfigLuaPost3 extraConfigLuaPost
            test_content extraConfigVim4 extraConfigVim4
            test_content wrappedNeovim.initRc5 wrappedNeovim.initRc

            touch $out
          '';
        }
      ];

      assertions =
        # Main init.lua
        mkConfigAssertions "init.lua" config.content
        # Extra file modules
        ++ mkConfigAssertions "test.lua" config.files."test.lua".content
        ++ mkConfigAssertions "test.vim" config.files."test.vim".content;
    };

  files-default-empty =
    { config, lib, ... }:
    {
      files = {
        # lua type
        "test.lua" = { };
        # vim type
        "test.vim" = { };
      };

      assertions = [
        {
          assertion = !lib.nixvim.hasContent config.files."test.lua".content;
          message = "Default content of test.lua file is expected to be empty.";
        }
        {
          assertion = !lib.nixvim.hasContent config.files."test.vim".content;
          message = "Default content of test.vim file is expected to be empty.";
        }
      ];
    };

  with-providers = {
    withNodeJs = true;
    withPerl = true;
    withPython3 = true;
    withRuby = true;

    extraConfigLua = ''
      if type(vim.g.node_host_prog) ~= "string" or not vim.g.node_host_prog:match("node") then
        print("Node.js host program was not configured.")
      end

      if type(vim.g.perl_host_prog) ~= "string" or not vim.g.perl_host_prog:match("perl") then
        print("Perl host program was not configured.")
      end

      if type(vim.g.python3_host_prog) ~= "string" or not vim.g.python3_host_prog:match("python3") then
        print("Python3 host program was not configured.")
      end

      if type(vim.g.ruby_host_prog) ~= "string" or not vim.g.ruby_host_prog:match("ruby") then
        print("Ruby host program was not configured.")
      end
    '';
  };

  without-providers = {
    withNodeJs = false;
    withPerl = false;
    withPython3 = false;
    withRuby = false;

    extraConfigLua = ''
      if vim.g.loaded_node_provider ~= 0 then
        print("Node.js provider discovery was not disabled.")
      end

      if vim.g.loaded_perl_provider ~= 0 then
        print("Perl provider discovery was not disabled.")
      end

      if vim.g.loaded_python3_provider ~= 0 then
        print("Python3 provider discovery was not disabled.")
      end

      if vim.g.loaded_ruby_provider ~= 0 then
        print("Ruby provider discovery was not disabled.")
      end
    '';
  };

  wrapRc-uses-viminit-for-exrc =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      wrapperArgs = config.build.nvimPackage.wrapperArgs;
      exrcTest =
        pkgs.runCommandLocal "wraprc-viminit-exrc-test"
          {
            nativeBuildInputs = [ config.build.nvimPackage ];
          }
          ''
            mkdir -p project home xdg/nvim vim

            cat > project/.nvim.lua <<'EOF'
            vim.g.nixvim_exrc_loaded = true
            EOF

            cat > project/check.lua <<'EOF'
            assert(vim.g.nixvim_exrc_loaded == true, ".nvim.lua was not sourced")
            assert(vim.g.nixvim_xdg_sysinit_loaded == nil, "XDG sysinit.vim was sourced")
            assert(vim.g.nixvim_vim_sysinit_loaded == nil, "VIM sysinit.vim was sourced")
            assert(_G.__nixvim_impure_startup_env == nil, "saved startup env was not cleared")

            if vim.env.NIXVIM_TEST_XDG_CONFIG_DIRS == "" then
              assert(vim.env.XDG_CONFIG_DIRS == nil, "XDG_CONFIG_DIRS was not restored to unset")
            else
              assert(
                vim.env.XDG_CONFIG_DIRS == vim.env.NIXVIM_TEST_XDG_CONFIG_DIRS,
                "XDG_CONFIG_DIRS was not restored"
              )
            end

            if vim.env.NIXVIM_TEST_VIM == "" then
              assert(vim.env.VIM == nil, "VIM was not restored to unset")
            else
              assert(vim.env.VIM == vim.env.NIXVIM_TEST_VIM, "VIM was not restored")
            end
            EOF

            cat > xdg/nvim/sysinit.vim <<'EOF'
            let g:nixvim_xdg_sysinit_loaded = v:true
            EOF

            cat > vim/sysinit.vim <<'EOF'
            let g:nixvim_vim_sysinit_loaded = v:true
            EOF

            cd project
            run_nvim_with_impure_startup_env() {
              env \
                XDG_CONFIG_DIRS="$1" \
                VIM="$2" \
                NIXVIM_TEST_XDG_CONFIG_DIRS="$1" \
                NIXVIM_TEST_VIM="$2" \
                HOME="$(realpath ../home)" \
                nvim --headless -S check.lua +qa
            }

            run_nvim_without_impure_startup_env() {
              env \
                -u XDG_CONFIG_DIRS \
                -u VIM \
                NIXVIM_TEST_XDG_CONFIG_DIRS= \
                NIXVIM_TEST_VIM= \
                HOME="$(realpath ../home)" \
                nvim --headless -S check.lua +qa
            }

            xdg_config_dirs="$(realpath ../xdg)"
            vim_dir="$(realpath ../vim)"
            run_nvim_with_impure_startup_env "$xdg_config_dirs" "$vim_dir"
            run_nvim_without_impure_startup_env

            touch $out
          '';
    in
    {
      wrapRc = true;

      opts = {
        exrc = true;
        secure = true;
      };

      extraConfigLuaPre = ''
        vim.secure.trust({
          action = "allow",
          path = vim.fn.getcwd() .. "/.nvim.lua",
        })
      '';

      test.extraInputs = [ exrcTest ];

      assertions = [
        {
          assertion = lib.hasInfix "--set VIMINIT" wrapperArgs;
          message = "`wrapRc` should pass the generated config through VIMINIT.";
        }
        {
          assertion = !(lib.hasInfix "--add-flags -u" wrapperArgs);
          message = "`wrapRc` should not pass the generated config through `-u`.";
        }
        {
          assertion = lib.hasInfix "--add-flag --cmd" wrapperArgs;
          message = "`wrapRc` should ignore system config dirs during startup when `impureRtp` is disabled.";
        }
        {
          assertion = lib.hasInfix "__nixvim_impure_startup_env" wrapperArgs;
          message = "`wrapRc` should restore `XDG_CONFIG_DIRS` after startup.";
        }
        {
          assertion = lib.hasInfix "__nixvim_impure_startup_env" wrapperArgs;
          message = "`wrapRc` should restore `VIM` after startup.";
        }
      ];
    };

  impureRtp-disabled-requires-wrapRc = {
    wrapRc = false;
    impureRtp = false;

    test.assertions = expect: [
      (expect "count" 1)
      (expect "anyExact" "Nixvim (output): `impureRtp = false` requires `wrapRc = true` so Nixvim can suppress system/XDG startup config.")
    ];

    test.buildNixvim = false;
  };

  extraPackagesAfter =
    { pkgs, ... }:
    {
      extraPackagesAfter = [ pkgs.hello ];

      extraConfigLua = ''
        if vim.fn.executable("hello") ~= 1 then
          print("Unable to find hello package.")
        end
      '';
    };

  extraPackages-rejects-vim-plugins =
    { pkgs, ... }:
    let
      plugin = pkgs.vimUtils.buildVimPlugin {
        pname = "nixvim-extra-packages-vim-plugin-test";
        version = "1";
        src = pkgs.emptyDirectory;
      };
    in
    {
      extraPackages = [ plugin ];
      extraPackagesAfter = [ plugin ];

      test = {
        buildNixvim = false;
        assertions = expect: [
          (expect "count" 2)
          (expect "any" "`extraPackages` is for executable packages added to Neovim's PATH")
          (expect "any" "`extraPackagesAfter` is for executable packages added to Neovim's PATH")
          (expect "all" "Use `extraPlugins` for Vim plugin packages:")
          (expect "all" "- nixvim-extra-packages-vim-plugin-test defined in `${toString __curPos.file}'")
        ];
      };
    };

  autowrapRuntimeDeps =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      plugin = pkgs.vimUtils.buildVimPlugin {
        pname = "nixvim-runtime-deps-test";
        version = "1";
        src = pkgs.emptyDirectory;
        runtimeDeps = [ pkgs.hello ];
      };
    in
    {
      extraPlugins = [ plugin ];

      assertions = [
        {
          assertion = lib.elem pkgs.hello config.build.nvimPackage.runtimeDeps;
          message = "`autowrapRuntimeDeps` should add plugin runtime dependencies by default.";
        }
      ];
    };

  autowrapRuntimeDeps-disabled =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      plugin = pkgs.vimUtils.buildVimPlugin {
        pname = "nixvim-runtime-deps-disabled-test";
        version = "1";
        src = pkgs.emptyDirectory;
        runtimeDeps = [ pkgs.hello ];
      };
    in
    {
      autowrapRuntimeDeps = false;
      extraPlugins = [ plugin ];

      assertions = [
        {
          assertion = !lib.elem pkgs.hello config.build.nvimPackage.runtimeDeps;
          message = "`autowrapRuntimeDeps = false` should not add plugin runtime dependencies.";
        }
      ];
    };
}
