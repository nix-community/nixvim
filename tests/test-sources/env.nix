{
  env-variables = {
    env = {
      FOO = "1";
      FOO_INT = 42;
      FOO_FLOAT = 3.14;
      STRING_PATH = "/home/me/.local/share/bar";
      REAL_PATH = ./env.nix;
      BAZ_MAX_COUNT = "1000";
      MUST_BE_ESCAPED = "esc'ape\nme";
    };

    extraConfigLua = ''
      assert(
        os.getenv("FOO") == "1"
      )
      assert(
        tonumber(os.getenv("FOO_INT")) == 42
      )
      assert(
        tonumber(os.getenv("FOO_FLOAT")) == 3.14
      )

      assert(
        os.getenv("STRING_PATH") == "/home/me/.local/share/bar"
      )

      local file_path = os.getenv("REAL_PATH")
      assert(
        vim.fn.filereadable(file_path)
      )

      assert(
        os.getenv("BAZ_MAX_COUNT") == "1000"
      )

      assert(
        os.getenv("MUST_BE_ESCAPED") == "esc'ape\nme"
      )
    '';
  };
}
