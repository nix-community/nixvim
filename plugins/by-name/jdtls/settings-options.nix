lib:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts mkNullOrOption mkNullOrOption';
in
{
  cmd = mkNullOrOption' {
    type = with types; listOf str;
    example = [
      "java"
      "-data"
      "/path/to/your/workspace"
      "-configuration"
      "/path/to/your/configuration"
      "-foo"
      "bar"
    ];
    description = ''
      The command that starts the language server.
    '';
  };

  root_dir =
    defaultNullOpts.mkStr { __raw = "require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'})"; }
      ''
        Function to identify the root directory from which to run the language server.
      '';

  settings = mkNullOrOption (with types; attrsOf anything) ''
    Here you can configure `eclipse.jdt.ls` specific settings.

    See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    for a list of options.
  '';

  init_options = mkNullOrOption types.attrs ''
    Language server `initializationOptions`.

    You need to extend the `bundles` with paths to jar files if you want to use additional
    `eclipse.jdt.ls` plugins.

    See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation

    If you don't plan on using the debugger or other `eclipse.jdt.ls` plugins, ignore this option
  '';
}
