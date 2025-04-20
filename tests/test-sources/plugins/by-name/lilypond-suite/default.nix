{
  empty = {
    plugins.lilypond-suite.enable = true;
  };

  defaults = {
    plugins.lilypond-suite = {
      enable = true;

      # https://github.com/martineausimon/nvim-lilypond-suite/wiki/2.-Configuration#customize-default-settings
      settings = {
        lilypond = {
          mappings = {
            player = "<F3>";
            compile = "<F5>";
            open_pdf = "<F6>";
            switch_buffers = "<A-Space>";
            insert_version = "<F4>";
            hyphenation = "<F12>";
            hyphenation_change_lang = "<F11>";
            insert_hyphen = "<leader>ih";
            add_hyphen = "<leader>ah";
            del_next_hyphen = "<leader>dh";
            del_prev_hyphen = "<leader>dH";
          };
          options = {
            pitches_language = "default";
            hyphenation_language = "en_DEFAULT";
            output = "pdf";
            backend = null;
            main_file = "main.ly";
            main_folder = "%:p:h";
            include_dir = null;
            pdf_viewer = null;
            errors = {
              diagnostics = true;
              quickfix = "external";
              filtered_lines = [
                "compilation successfully completed"
                "search path"
              ];
            };
          };
        };
        latex = {
          mappings = {
            compile = "<F5>";
            open_pdf = "<F6>";
            lilypond_syntax = "<F3>";
          };
          options = {
            lilypond_book_flags = null;
            clean_logs = false;
            main_file = "main.tex";
            main_folder = "%:p:h";
            include_dir = null;
            lilypond_syntax_au = "BufEnter";
            pdf_viewer = null;
            errors = {
              diagnostics = true;
              quickfix = "external";
              filtered_lines = [
                "Missing character"
                "LaTeX manual or LaTeX Companion"
                "for immediate help."
                "Overfull \\hbox"
                "^%s%.%.%."
                "%s+%(.*%)"
              ];
            };
          };
        };
        texinfo = {
          mappings = {
            compile = "<F5>";
            open_pdf = "<F6>";
            lilypond_syntax = "<F3>";
          };
          options = {
            lilypond_book_flags = "--pdf";
            clean_logs = false;
            main_file = "main.texi";
            main_folder = "%:p:h";
            lilypond_syntax_au = "BufEnter";
            pdf_viewer = null;
            errors = {
              diagnostics = true;
              quickfix = "external";
              filtered_lines = [
                "Missing character"
                "LaTeX manual or LaTeX Companion"
                "for immediate help."
                "Overfull \\hbox"
                "^%s%.%.%."
                "%s+%(.*%)"
              ];
            };
          };
        };
        player = {
          mappings = {
            quit = "q";
            play_pause = "p";
            loop = "<A-l>";
            backward = "h";
            small_backward = "<S-h>";
            forward = "l";
            small_forward = "<S-l>";
            decrease_speed = "j";
            increase_speed = "k";
            halve_speed = "<S-j>";
            double_speed = "<S-k>";
          };
          options = {
            row = 1;
            col = "99%";
            width = "37";
            height = "1";
            border_style = "single";
            winhighlight = "Normal:Normal,FloatBorder:Normal,FloatTitle:Normal";
            midi_synth = "fluidsynth";
            fluidsynth_flags = null;
            timidity_flags = null;
            audio_format = "mp3";
            mpv_flags = [
              "--msg-level=cplayer=no,ffmpeg=no,alsa=no"
              "--loop"
              "--config-dir=/dev/null"
              "--no-video"
            ];
          };
        };
      };
    };
  };

  example = {
    plugins.lilypond-suite = {
      enable = true;

      # https://github.com/martineausimon/nvim-lilypond-suite/wiki/2.-Configuration#customize-default-settings
      settings = {
        lilypond = {
          mappings = {
            player = "<F3>";
            compile = "<F5>";
            open_pdf = "<F6>";
            switch_buffers = "<F2>";
            insert_version = "<F4>";
          };
          options = {
            pitches_language = "default";
            output = "pdf";
            include_dir = [
              "./openlilylib"
            ];
          };
        };
      };
    };
  };
}
