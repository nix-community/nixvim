{
  self,
  pkgs,
}:
let
  inherit (self.inputs.home-manager.lib)
    homeManagerConfiguration
    ;

  config = {
    home = {
      username = "nixvim";
      homeDirectory = "/invalid/dir";
      stateVersion = "25.05";
    };

    programs.nixvim = {
      enable = true;

      performance.byteCompileLua.enable = true;

      extraFiles = {
        "extra-files/test1.lua".text = "vim.opt.tabstop = 2";
        "extra-files/test2.lua".source = builtins.toFile "file_source.lua" "vim.opt.tabstop = 2";
        "extra-files/test3.lua".source = pkgs.writeText "test3.lua" "vim.opt.tabstop = 2";
        "extra-files/test.vim".text = "set tabstop=2";
        "extra-files/test.json".text = builtins.toJSON { a = 1; };
      };

      files = {
        "files/test.lua".opts.tabstop = 2;
        "files/test.vim".opts.tabstop = 2;
      };
    };
  };

  homeFilesByteCompilingEnabled =
    (homeManagerConfiguration {
      inherit pkgs;

      modules = [
        self.homeManagerModules.nixvim
        config
        { programs.nixvim.performance.byteCompileLua.configs = true; }
      ];
    }).config.home-files;

  homeFilesByteCompilingDisabled =
    (homeManagerConfiguration {
      inherit pkgs;

      modules = [
        self.homeManagerModules.nixvim
        config
        { programs.nixvim.performance.byteCompileLua.configs = false; }
      ];
    }).config.home-files;
in
pkgs.runCommand "home-manager-extra-files-byte-compiling" { } ''
  is_byte_compiled() {
      # LuaJIT bytecode header is: ESC L J version
      # https://github.com/LuaJIT/LuaJIT/blob/v2.1/src/lj_bcdump.h
      [[ $(head -c3 "$1") = $'\x1bLJ' ]]
  }
  test_byte_compiled() {
      if ! is_byte_compiled "$home_files/.config/nvim/$1"; then
          echo "File $1 is expected to be byte compiled, but it's not"
          exit 1
      fi
  }
  test_not_byte_compiled() {
      if is_byte_compiled "$home_files/.config/nvim/$1"; then
          echo "File $1 is not expected to be byte compiled, but it is"
          exit 1
      fi
  }

  # Test directory with extraFiles byte compiling enabled
  home_files="${homeFilesByteCompilingEnabled}"

  echo "Testing home-files with extraFiles byte compiling enabled"

  # extraFiles
  test_byte_compiled extra-files/test1.lua
  test_byte_compiled extra-files/test2.lua
  test_byte_compiled extra-files/test3.lua
  test_not_byte_compiled extra-files/test.vim
  test_not_byte_compiled extra-files/test.json
  # files
  test_byte_compiled files/test.lua
  test_not_byte_compiled files/test.vim

  # Test directory with extraFiles byte compiling disabled
  home_files="${homeFilesByteCompilingDisabled}"

  echo "Testing home-files with extraFiles byte compiling disabled"

  # extraFiles
  test_not_byte_compiled extra-files/test1.lua
  test_not_byte_compiled extra-files/test2.lua
  test_not_byte_compiled extra-files/test3.lua
  test_not_byte_compiled extra-files/test.vim
  test_not_byte_compiled extra-files/test.json
  # files
  test_not_byte_compiled files/test.lua
  test_not_byte_compiled files/test.vim

  touch $out
''
