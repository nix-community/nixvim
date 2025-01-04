let
  mkExtension = import ./_mk-extension.nix;
in
mkExtension {
  name = "project";
  package = "telescope-project-nvim";

  settingsExample = {
    base_dirs = [
      "~/dev/src"
      "~/dev/src2"
      {
        __unkeyed-1 = "~/dev/src3";
        max_depth = 4;
      }
      { path = "~/dev/src4"; }
      {
        path = "~/dev/src5";
        max_depth = 2;
      }
    ];
    hidden_files = true;
    theme = "dropdown";
    order_by = "asc";
    search_by = "title";
    sync_with_nvim_tree = true;
    on_project_selected.__raw = ''
      function(prompt_bufnr)
        require("telescope._extensions.project.actions").change_working_directory(prompt_bufnr, false)
        require("harpoon.ui").nav_file(1)
      end
    '';
  };
}
