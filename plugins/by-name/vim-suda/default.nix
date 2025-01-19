{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkVimPlugin {
  name = "vim-suda";
  globalPrefix = "suda#";
  maintainers = [ lib.maintainers.marcel ];

  settingsOptions = {
    executable = defaultNullOpts.mkStr "sudo" ''
      Path to the sudo binary.
    '';

    noninteractive = defaultNullOpts.mkFlagInt 0 ''
      If set, suda will not prompt you for a password before saving a file.
      It is supposed to support a setup with passwordless sudo or doas.
      Use with care.
    '';

    prompt = defaultNullOpts.mkStr "Password: " ''
      A prompt string used to ask password.
    '';

    smart_edit = defaultNullOpts.mkFlagInt 0 ''
      If set, an `|autocmd|` is created that performs a heuristic check on
      every buffer and decides whether to replace it with a suda buffer.
      The check is done only once for every buffer and it is designed to be
      optimized as possible so you shouldn't feel any slowdown when opening
      buffers.
    '';
  };

  settingsExample = {
    path = "doas";
    noninteractive = 1;
    prompt = "Pass: ";
    smart_edit = 1;
  };
}
