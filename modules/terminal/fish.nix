{pkgs, ...}: {
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
        set available_components "Data Management" "Data Analysis" "Data Governance" "Support" "Visualizations" "Mopo" "IDD Core"
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
      sudo = "sudo --preserve-env=PATH env"; # Fixes nix packages under sudo
      update = "sudo apt update";
      upgrade = "sudo apt upgrade";
      hmu = "nix flake update --flake ~/.config/home-manager";
      hms = "home-manager switch --flake ~/.config/home-manager";
      hmgc = "nix-collect-garbage --delete-older-than 30d";
      hmo = "hmgc && nix store optimise";
      bandwhich = "sudo $(which bandwhich)";
      jci = "fast_jira_create_issue";
      ktemplate = "kubectl create --dry-run=client -o yaml";
      k = "kubectl";
    };
    shellInit = ''
      # Disable help message
      set -U fish_greeting
      # Nix
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
          fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      end
      # home-manager
      # fenv 'export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels''${NIX_PATH:+:$NIX_PATH}'
    '';
  };
}
