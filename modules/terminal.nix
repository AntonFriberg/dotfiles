{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "Anton Friberg";
    userEmail = "anton.friberg@outlook.com";
    ignores = [
      ".env"
      ".mise.toml"
      ".venv"
    ];
    includes = [
      {
        condition = "hasconfig:remote.*.url:ssh://*@*.*.axis.com:*/**";
        contents = {
          user = {
            email = "anton.friberg@axis.com";
          };
        };
      }
    ];
    aliases = {
      # List available aliases
      aliases = "!git config --get-regexp alias | sed -re 's/alias\\.(\\S*)\\s(.*)$/\\1 = \\2/g'";
      # Command shortcuts
      ci = "commit";
      co = "checkout";
      st = "status";
      # Display tree-like log, default log is not ideal
      lg = "log --graph --date=relative --pretty=tformat:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%an %ad)%Creset'";
      # Useful when you have to update your last commit
      # with staged files without editing the commit message.
      oops = "commit --amend --no-edit";
      # Ensure that force-pushing won't lose someone else's work (only your own).
      push-with-lease = "push --force-with-lease";
      # List local commits that were not pushed to remote repository
      review-local = "!git lg @{push}..";
      # Edit last commit message
      reword = "commit --amend";
      # Undo last commit but keep changed files in stage
      uncommit = "reset --soft HEAD~1";
      # Remove file(s) from Git but not from disk
      untrack = "rm --cache --";
    };
    extraConfig = {
      color = {
        ui = "auto";
      };
      diff = {
        # Use better, descriptive initials (c, i, w) instead of a/b.
        mnemonicPrefix = true;
        # Show renames/moves as such
        renames = true;
        # When using --word-diff, assume --word-diff-regex=.
        wordRegex = ".";
        # Display submodule-related information (commit listings)
        submodule = "log";
        # Use VSCode as default diff tool when running `git diff-tool`
        tool = "vscode";
      };
      log = {
        # Use abbrev SHAs whenever possible/relevant instead of full 40 chars
        abbrevCommit = true;
        # Automatically --follow when given a single path
        follow = true;
        # Disable decorate for reflog
        # (because there is no dedicated `reflog` section available)
        decorate = false;
      };
      pull = {
        # This is GREAT… when you know what you're doing and are careful
        # not to pull --no-rebase over a local line containing a true merge.
        rebase = true;
        # This option, which does away with the one gotcha of
        # auto-rebasing on pulls, is only available from 1.8.5 onwards.
        # rebase = "preserve";
        # WARNING! This option, which is the latest variation, is only
        # available from 2.18 onwards.
        # rebase = "merges";
      };
      status = {
        short = true;
      };
      format = {
        pretty = "format:%h%Cgreen%d%Creset %C(yellow)%an %C(cyan)%cr%Creset %s";
      };
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    compression = true;
    controlMaster = "auto";
    controlPersist = "10m";
    serverAliveInterval = 25;
    includes = [
      "config.d/*"
    ];
    extraConfig = ''
      SetEnv TERM=xterm-256color
      ForwardX11 no
    '';
  };

  # SSH Agent systemd user service
  services.ssh-agent.enable = true;

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
      {
        name = "foreign-env";
        src = pkgs.fishPlugins.foreign-env.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
      {
        name = "puffer";
        src = pkgs.fishPlugins.puffer.src;
      }
      {
        name = "forgit";
        src = pkgs.fishPlugins.forgit.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "bang-bang";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-bang-bang";
          rev = "816c66df34e1cb94a476fa6418d46206ef84e8d3";
          sha256 = "0dx4z0mmrwfkg8qh1yis75vwf69ng51m3icsiiw7k2cwc02mg76z";
        };
      }
    ];
    functions = {
      # Custom function for sourcing .env files
      envsource = ''
        for line in (cat $argv | grep -v '^#' | grep -v '^\s*$')
          set item (string split -m 1 '=' $line)
          set -gx $item[1] (string trim --chars=\'\" $item[2])
          echo "Exported key $item[1]"
        end
      '';
      ssht = ''
        # Set the remote server's address
        set remote_server $argv[1]

        # Export the terminal info to a temporary file
        set tmp_file (mktemp)
        infocmp > $tmp_file

        # Transfer the terminfo file to the remote server
        scp $tmp_file $remote_server:/tmp/

        # Set the name for the remote temporary file
        set remote_tmp_file "/tmp/"(basename $tmp_file)

        # Load the terminfo on the remote server
        ssh $remote_server "tic -x $remote_tmp_file"

        # Clean up temporary files
        rm $tmp_file
        ssh $remote_server "rm $remote_tmp_file"

        echo "Terminfo for $term_type transferred and installed on $remote_server"
      '';
      fast_jira_create_issue = ''
        # Creates a Jira issue quickly by selecting an epic, issue type, and components using interactive prompts.

        # Configuration: Set your project key and available components here.
        set project_key "DDM" # Project key, replace "DDM" with your actual project key.
        set available_components "Data Management" "Data Analysis" "Data Governance" "Support" "Visualizations"
        set issue_types "Story" "Task" "Bug"

        # Select an epic from the list of epics in progress using fzf for filtering and selection.
        set selected_epic (jira epic list --project $project_key --plain --no-headers --table --status "In progress" | awk 'BEGIN{FS="\t"}{print $2 " " $3 " " $4}' | fzf --prompt="Select Epic: ")
        set epic_key (echo $selected_epic | awk '{print $1}')

        if test -z "$epic_key"
            echo "No epic selected, exiting..."
            return 1
        end

        echo "Selected Epic ID: $epic_key"

        # Let the user select the issue type with fzf.
        set issue_type (printf '%s\n' $issue_types | fzf --prompt="Select Issue Type: ")

        if test -z "$issue_type"
            echo "No issue type selected, exiting..."
            return 1
        end

        echo "Selected Issue Type: $issue_type"

        # Allow the user to select one or more components for the issue.
        set selected_components (printf '%s\n' $available_components | fzf --multi --prompt="Select Components (TAB for multiple): ")

        if test -z "$selected_components"
            echo "No components selected, exiting..."
            return 1
        end

        # Format the selected components for the Jira issue creation command.
        set components_formatted (printf '--component "%s" ' $selected_components)
        echo "Selected Components: $components_formatted"

        # Construct the command to create a Jira issue with the selected epic, issue type, and components.
        set create_command "jira issue create --project $project_key --type $issue_type $components_formatted --parent $epic_key"

        # Execute the command to create the Jira issue.
        eval $create_command
      '';
    };
    shellAliases = {
      update = "sudo apt update";
      upgrade = "sudo apt upgrade";
      hmu = "nix flake update ~/.config/home-manager";
      hms = "home-manager switch --flake ~/.config/home-manager";
      hmgc = "nix-collect-garbage --delete-older-than 30d";
      bandwhich = "sudo $(which bandwhich)";
      jci = "fast_jira_create_issue";
    };
    shellInit = ''
      # Disable help message
      set -U fish_greeting
      # Nix
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
          fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      end
      # home-manager
      fenv 'export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels''${NIX_PATH:+:$NIX_PATH}'
      # Fix for python dependencies under nix
      #fenv 'export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib/:/run/opengl-driver/lib/:$LD_LIBRARY_PATH'
      # Add to PATH
      fish_add_path -m ~/.local/bin
    '';
  };

  programs.micro = {
    enable = true;
    settings = {
      colorscheme = "nord-16"; # micro --plugin install nordcolors
    };
  };
}
