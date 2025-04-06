{
  lib,
  pkgs,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "tinygit";
  packPathName = "nvim-tinygit";
  package = "nvim-tinygit";

  maintainers = [ lib.maintainers.GaetanLepage ];

  extraOptions = {
    gitPackage = lib.mkPackageOption pkgs "git" {
      nullable = true;
    };
  };

  extraConfig = cfg: {
    extraPackages = [
      cfg.gitPackage
    ];
    dependencies.curl.enable = lib.mkDefault true;
  };

  settingsExample = {
    stage.moveToNextHunkOnStagingToggle = true;
    commit = {
      keepAbortedMsgSecs.__raw = "60 * 10";
      spellcheck = true;
      subject = {
        autoFormat.__raw = ''
          function(subject)
            -- remove trailing dot https://commitlint.js.org/reference/rules.html#body-full-stop
            subject = subject:gsub("%.$", "")

            -- sentence case of title after the type
            subject = subject
              :gsub("^(%w+: )(.)", function(c1, c2) return c1 .. c2:lower() end) -- no scope
              :gsub("^(%w+%b(): )(.)", function(c1, c2) return c1 .. c2:lower() end) -- with scope
            return subject
          end
        '';
        enforceType = true;
      };
    };
    statusline = {
      blame = {
        hideAuthorNames = [
          "John Doe"
          "johndoe"
        ];
        ignoreAuthors = [ "🤖 automated" ];
        maxMsgLen = 55;
      };
    };
  };
}
