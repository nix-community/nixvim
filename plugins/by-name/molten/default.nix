{
  config,
  lib,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "molten";
  package = "molten-nvim";
  globalPrefix = "molten_";
  description = "A neovim plugin for interactively running code with the jupyter kernel. Fork of magma-nvim with improvements in image rendering, performance, and more.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    auto_open_output = true;
    copy_output = false;
    enter_output_behavior = "open_then_enter";
    image_provider = "none";
    output_crop_border = true;
    output_show_more = false;
    output_virt_lines = false;
    output_win_border = [
      ""
      "━"
      ""
      ""
    ];
    output_win_cover_gutter = true;
    output_win_hide_on_leave = true;
    output_win_style = false;
    save_path.__raw = "vim.fn.stdpath('data')..'/molten'";
    use_border_highlights = false;
    virt_lines_off_by1 = false;
    wrap_output = false;
    show_mimetype_debug = false;
  };

  extraOptions = {
    python3Dependencies = lib.mkOption {
      type = with lib.types; functionTo (listOf package);
      default =
        p: with p; [
          pynvim
          jupyter-client
          cairosvg
          ipython
          nbformat
          ipykernel
        ];
      defaultText = lib.literalExpression ''
        p: with p; [
          pynvim
          jupyter-client
          cairosvg
          ipython
          nbformat
          ipykernel
        ]
      '';
      description = "Python packages to add to the `PYTHONPATH` of neovim.";
    };
  };

  extraConfig = cfg: {
    extraPython3Packages = cfg.python3Dependencies;

    warnings = lib.nixvim.mkWarnings "plugins.molten" {
      when = (cfg.settings.image_provider or null) == "wezterm" && !config.plugins.wezterm.enable;

      message = ''
        The `wezterm` plugin is not enabled, so the `molten` plugin's `image_provider` setting will have no effect.
      '';
    };
  };
}
