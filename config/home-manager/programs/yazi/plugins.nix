# programs/yazi/plugins.nix
{
  pkgs,
  ...
}:
let
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "03cdd4b5b15341b3c0d0f4c850d633fadd05a45f";
    hash = "sha256-5dMAJ6W/L66XuH4CCwRRFpKSLy0ZDFIABAYleFX0AsQ=";
  };
in
{
  plugins = {
    zoom = {
      source = "${yazi-plugins}/zoom.yazi";
      defaultEnable = false;
      keymap = [
        {
          on = "+";
          run = "plugin zoom 1";
          desc = "Zoom in hovered file";
        }
        {
          on = "-";
          run = "plugin zoom -1";
          desc = "Zoom out hovered file";
        }
      ];
    };
    mediainfo = {
      source = pkgs.yaziPlugins.mediainfo;
      defaultEnable = false;
      settings = {
        # BUG: overwritting instead of appending
        # opener = {
        #   play = [
        #     {
        #       run = ''mediainfo "$1"; echo "Press enter to exit"; read _'';
        #       block = true;
        #       desc = "Show media info";
        #       for = "unix";
        #     }
        #   ];
        # };
        plugin = {
          prepend_preloaders = [
            {
              mime = "{audio,video}/*";
              run = "mediainfo";
            }
          ];
          prepend_previewers = [
            {
              mime = "{audio,video}/*";
              run = "mediainfo";
            }
          ];
        };
      };
    };
    dupes = {
      source = pkgs.yaziPlugins.dupes;
      defaultEnable = false;
      initLua = ''
        require("dupes"):setup({
        	save_op = false,
        	profiles = {
        		interactive = {
        			args = { "-r" },
        		},
        		apply = {
        			args = { "-r", "-N", "-d" },
        			save_op = true,
        		},
        	},
        })
      '';
      keymap = [
        {
          on = [
            "<A-J>"
            "i"
          ];
          run = "plugin dupes interactive";
          desc = "Run dupes interactive";
        }
        {
          on = [
            "<A-J>"
            "o"
          ];
          run = "plugin dupes override";
          desc = "Run dupes override";
        }
        {
          on = [
            "<A-J>"
            "d"
          ];
          run = "plugin dupes dry";
          desc = "Run dupes dry";
        }
        {
          on = [
            "<A-J>"
            "a"
          ];
          run = "plugin dupes apply";
          desc = "Run dupes apply";
        }
        # [[mgr.prepend_keymap]]
        # on = ["<A-J>", "c"]
        # run = "plugin dupes custom"
        # desc = "Run dupes custom"
      ];
    };
    jump-to-char = {
      source = "${yazi-plugins}/jump-to-char.yazi";
      defaultEnable = false;
      keymap = [
        {
          on = "f";
          run = "plugin jump-to-char";
          desc = "Jump to char";
        }
      ];
    };
    relative-motions = {
      source = pkgs.fetchFromGitHub {
        owner = "dedukun";
        repo = "relative-motions.yazi";
        rev = "a603d9ea924dfc0610bcf9d3129e7cba605d4501";
        hash = "sha256-9i6x/VxGOA3bB3FPieB7mQ1zGaMK5wnMhYqsq4CvaM4=";
      };
      initLua = ''
        require("relative-motions"):setup({ show_numbers = "none", show_motion = true })
      '';
      defaultEnable = false;
      keymap = [
        {
          on = [ "1" ];
          run = "plugin relative-motions --args=1";
          desc = "Move in relative steps";
        }
        {
          on = [ "2" ];
          run = "plugin relative-motions --args=2";
          desc = "Move in relative steps";
        }
        {
          on = [ "3" ];
          run = "plugin relative-motions --args=3";
          desc = "Move in relative steps";
        }
        {
          on = [ "4" ];
          run = "plugin relative-motions --args=4";
          desc = "Move in relative steps";
        }
        {
          on = [ "5" ];
          run = "plugin relative-motions --args=5";
          desc = "Move in relative steps";
        }
        {
          on = [ "6" ];
          run = "plugin relative-motions --args=6";
          desc = "Move in relative steps";
        }
        {
          on = [ "7" ];
          run = "plugin relative-motions --args=7";
          desc = "Move in relative steps";
        }
        {
          on = [ "8" ];
          run = "plugin relative-motions --args=8";
          desc = "Move in relative steps";
        }
        {
          on = [ "9" ];
          run = "plugin relative-motions --args=9";
          desc = "Move in relative steps";
        }
      ];
    };
    projects = {
      source = pkgs.fetchFromGitHub {
        owner = "MasouShizuka";
        repo = "projects.yazi";
        rev = "eed0657a833f56ea69f3531c89ecc7bad761d611";
        hash = "sha256-5J0eqffUzI0GodpqwzmaQJtfh75kEbbIwbR8pFH/ZmU=";
      };
      initLua = ''
        require("projects"):setup({
        	save = {
        		method = "yazi", -- yazi | lua
        		yazi_load_event = "@projects-load", -- event name when loading projects in `yazi` method
        		lua_save_path = "", -- path of saved file in `lua` method, comment out or assign explicitly
        		-- default value:
        		-- unix: "~/.local/state/yazi/projects.json"
        	},
        	last = {
        		update_after_save = true,
        		update_after_load = true,
        		load_after_start = false,
        	},
        	merge = {
        		event = "projects-merge",
        		quit_after_merge = false,
        	},
        	event = {
        		save = {
        			enable = true,
        			name = "project-saved",
        		},
        		load = {
        			enable = true,
        			name = "project-loaded",
        		},
        		delete = {
        			enable = true,
        			name = "project-deleted",
        		},
        		delete_all = {
        			enable = true,
        			name = "project-deleted-all",
        		},
        		merge = {
        			enable = true,
        			name = "project-merged",
        		},
        	},
        	notify = {
        		enable = true,
        		title = "Projects",
        		timeout = 3,
        		level = "info",
        	},
        })
      '';
      defaultEnable = false;
      keymap = [
        {
          on = [
            "R"
            "s"
          ];
          run = "plugin projects save";
          desc = "Save current project";
        }
        {
          on = [
            "R"
            "l"
          ];
          run = "plugin projects load";
          desc = "Load project";
        }
        {
          on = [
            "R"
            "L"
          ];
          run = "plugin projects load_last";
          desc = "Load last project";
        }
        {
          on = [
            "R"
            "d"
          ];
          run = "plugin projects delete";
          desc = "Delete project";
        }
        {
          on = [
            "R"
            "D"
          ];
          run = "plugin projects delete_all";
          desc = "Delete all projects";
        }
        {
          on = [
            "R"
            "p"
          ];
          run = "plugin projects 'load tmux'";
          desc = "Load the 'tmux' project";
        }
      ];
    };
    restore = {
      source = pkgs.fetchFromGitHub {
        owner = "boydaihungst";
        repo = "restore.yazi";
        rev = "6395e52b3af3a8832f0249970a168c41fb92b31b";
        hash = "sha256-HfXhYe3XPKkd/ivpQB85EsZyvLiflJE0tRNGVid2A9A=";
      };
      defaultEnable = false;
      keymap = [
        {
          on = "u";
          run = "plugin restore";
          desc = "Restore last deleted files/folders";
        }
      ];
    };
    yamb = {
      source = pkgs.fetchFromGitHub {
        owner = "h-hg";
        repo = "yamb.yazi";
        rev = "5f2e22e784dd5fc830cd85885a6d1d6690b52298";
        hash = "sha256-3Cp3+v0laSVsDdTyG26EOh2xt18ER8P9Nla9vtRuj9k=";
      };
      initLua = ''
        require("yamb"):setup({
        	jump_notify = true,
        	cli = "fzf",
        	keys = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
        	path = (os.getenv("HOME") .. "/.config/yazi/bookmark"),
        })
      '';
      defaultEnable = false;
      keymap = [
        {
          on = [
            "<A-b>"
            "s"
          ];
          run = "plugin yamb save";
          desc = "Add bookmark";
        }
        {
          on = [
            "<A-b>"
            "G"
          ];
          run = "plugin yamb jump_by_key";
          desc = "Jump bookmark by key";
        }
        {
          on = [
            "<A-b>"
            "g"
          ];
          run = "plugin yamb jump_by_fzf";
          desc = "Jump bookmark by fzf";
        }
        {
          on = [
            "<A-b>"
            "D"
          ];
          run = "plugin yamb delete_by_key";
          desc = "Delete bookmark by key";
        }
        {
          on = [
            "<A-b>"
            "d"
          ];
          run = "plugin yamb delete_by_fzf";
          desc = "Delete bookmark by fzf";
        }
        {
          on = [
            "<A-b>"
            "A"
          ];
          run = "plugin yamb delete_all";
          desc = "Delete all bookmarks";
        }
        {
          on = [
            "<A-b>"
            "R"
          ];
          run = "plugin yamb rename_by_key";
          desc = "Rename bookmark by key";
        }
        {
          on = [
            "<A-b>"
            "r"
          ];
          run = "plugin yamb rename_by_fzf";
          desc = "Rename bookmark by fzf";
        }
      ];
    };
  };
}
