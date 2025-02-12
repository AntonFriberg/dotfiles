{pkgs, ...}: {
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Anton Frost";
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
            email = "anton.frost@axis.com";
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
}
