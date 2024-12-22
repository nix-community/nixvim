{ lib, helpers, ... }:

lib.nixvim.plugins.mkVimPlugin {
  name = "vim-suda";
  globalPrefix = "suda#";
  maintainers = [ lib.maintainers.marcel ];

  settingsOptions = {
    executable = helpers.defaultNullOpts.mkStr "sudo" ''
      Path to the sudo binary.
    '';

    noninteractive = helpers.defaultNullOpts.mkFlagInt 0 ''
      If set, suda will not prompt you for a password before saving a file.
      It is supposed to support a setup with passwordless sudo or doas.
      Use with care.
    '';

    prompt = helpers.defaultNullOpts.mkStr "Password: " ''
      A prompt string used to ask password.
    '';

    # TODO: til https://github.com/lambdalisue/vim-suda/pull/84
    #       makes it into nixos-unstable
    # NOTE: also update in `settingsExample` and test cases
    #smart_edit = helpers.defaultNullOpts.mkFlagInt 0 ''
    #  If set, an `|autocmd|` is created that performs a heuristic check on
    #  every buffer and decides whether to replace it with a suda buffer.
    #  The check is done only once for every buffer and it is designed to be
    #  optimized as possible so you shouldn't feel any slowdown when opening
    #  buffers.
    #'';
  };

  settingsExample = {
    path = "doas";
    noninteractive = 1;
    prompt = "Pass: ";
    #smart_edit = 1;
  };
}
