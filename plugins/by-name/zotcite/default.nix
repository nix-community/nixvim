{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "zotcite";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    hl_cite_key = defaultNullOpts.mkBool true ''
      Set to `false` if you want to disable Zotcite's syntax highlighting of citation keys.
    '';

    conceallevel = defaultNullOpts.mkUnsignedInt 2 ''
      Zotcite sets the `conceallevel` of the Markdown document to `2`.
      Use this option if you want a different value.
    '';

    wait_attachment = defaultNullOpts.mkBool false ''
      While opening an attachment, Zotcite cannot catch errors because it doesn't wait for the
      application to finish.

      If zotcite fails to open a PDF attachment, you may want to temporarily set this option to
      `true`.

      Then, Neovim should freeze until the attachment is closed, and, if the PDF viewer finishes
      with non-zero status, anything output to the `stderr` will be displayed as a warning message.
    '';

    open_in_zotero = defaultNullOpts.mkBool false ''
      Set this to `true` if you want `:ZOpenAttachment` to open PDF attachments in Zotero (as
      opposed to your system's default PDF viewer).

      Note that you'll need to have Zotero configured as the default app for opening `zotero://`
      links.
      On Linux, assuming your Zotero installation included a `zotero.desktop` file, you can do the
      following:
      ```console
      xdg-mime default zotero.desktop x-scheme-handler/zotero
      ```
    '';

    filetypes = defaultNullOpts.mkListOf types.str [ "markdown" "pandoc" "rmd" "quarto" "vimwiki" ] ''
      Which filetypes to enable Zotcite on.
    '';
  };

  settingsExample = {
    hl_cite_key = false;
    wait_attachment = true;
    open_in_zotero = true;
    filetypes = [
      "markdown"
      "quarto"
    ];
  };
}
