{
  empty = {
    plugins.vimwiki.enable = true;
  };

  defaults = {
    plugins.vimwiki = {
      enable = true;

      settings = {
        CJK_length = 0;
        auto_chdir = 0;
        auto_header = 0;
        autowriteall = 1;
        conceallevel = 2;
        conceal_onechar_markers = 1;
        conceal_pre = 0;
        create_link = 1;
        diary_months = {
          "1" = "January";
          "2" = "February";
          "3" = "March";
          "4" = "April";
          "5" = "May";
          "6" = "June";
          "7" = "July";
          "8" = "August";
          "9" = "September";
          "10" = "October";
          "11" = "November";
          "12" = "Decembe";
        };
        dir_link = "";
        emoji_enable = 3;
        ext2syntax = {
          ".md" = "markdown";
          ".mkdn" = "markdown";
          ".mdwn" = "markdown";
          ".mdown" = "markdown";
          ".markdown" = "markdown";
          ".mw" = "media";
        };
        folding = "";
        filetypes.__empty = { };
        global_ext = 1;
        hl_cb_checked = 0;
        hl_headers = 0;
        html_header_numbering = 0;
        html_header_numbering_sym = "";
        key_mappings = {
          all_maps = 1;
          global = 1;
          headers = 1;
          text_objs = 1;
          table_format = 1;
          table_mappings = 1;
          lists = 1;
          lists_return = 1;
          links = 1;
          html = 1;
          mouse = 0;
        };
        links_header = "Generated Links";
        links_header_level = 1;
        listing_hl = 0;
        listing_hl_command = "pygmentize -f html";
        listsyms = " .oOX";
        listsym_rejected = "-";
        map_prefix = "<Leader>w";
        markdown_header_style = 1;
        menu = "Vimwiki";
        schemes_web = [
          "http"
          "https"
          "file"
          "ftp"
          "gopher"
          "telnet"
          "nntp"
          "ldap"
          "rsync"
          "imap"
          "pop"
          "irc"
          "ircs"
          "cvs"
          "svn"
          "svn+ssh"
          "git"
          "ssh"
          "fish"
          "sftp"
          "thunderlink"
          "message"
        ];
        schemes_any = [
          "mailto"
          "matrix"
          "news"
          "xmpp"
          "sip"
          "sips"
          "doi"
          "urn"
          "tel"
          "data"
        ];
        table_auto_fmt = 1;
        table_reduce_last_col = 0;
        table_mappings = 1;
        tags_header = "Generated Tags";
        tags_header_level = 1;
        url_maxsave = 15;
        use_calendar = 1;
        use_mouse = 0;
        user_htmls = "";
        valid_html_tags = "b,i,s,u,sub,sup,kbd,br,hr,div,center,strong,em";
        w32_dir_enc = "";
      };
    };
  };

  example = {
    plugins.vimwiki = {
      enable = true;

      settings = {
        global_ext = 0;
        use_calendar = 1;
        hl_headers = 1;
        hl_cb_checked = 1;
        autowriteall = 0;
        listsym_rejected = "✗";
        listsyms = "○◐●✓";
        list = [
          {
            diary_header = "Diary";
            diary_link_fmt = "%Y-%m/%d";
            auto_toc = 1;
            path = "~/docs/wiki/";
            syntax = "markdown";
            ext = ".md";
          }
          {
            path = "~/docs/notes/";
            syntax = "markdown";
            ext = ".md";
          }
        ];
        key_mappings = {
          all_maps = 1;
          global = 1;
          headers = 1;
          text_objs = 1;
          table_format = 1;
          table_mappings = 1;
          lists = 1;
          links = 1;
          html = 1;
          mouse = 0;
        };
      };
    };
  };
}
