{
  config,
  pkgs,
  pkgs-stable,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs-stable.vscode;
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = true;
      extensions = with pkgs-stable.vscode-extensions; [
        arcticicestudio.nord-visual-studio-code
        bbenoist.nix
        bmalehorn.vscode-fish
        charliermarsh.ruff
        pkief.material-icon-theme
        esbenp.prettier-vscode
        kamadorueda.alejandra
        mhutchie.git-graph
        ms-python.python
        ms-python.vscode-pylance
        ms-vscode-remote.remote-ssh
        redhat.vscode-yaml
        tamasfe.even-better-toml
      ];
      userSettings = {
        "[json]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
        "[python]" = {"editor.defaultFormatter" = "charliermarsh.ruff";};
        "[yaml]" = {"editor.defaultFormatter" = "redhat.vscode-yaml";};
        "editor.copyWithSyntaxHighlighting" = false;
        "editor.fontFamily" = "'Cousine Nerd Font', 'Hack Nerd Font', 'monospace', monospace, 'Droid Sans Fallback'";
        "editor.minimap.enabled" = false;
        "editor.renderWhitespace" = "boundary";
        "editor.rulers" = [80 120];
        "files.insertFinalNewline" = true;
        "files.trimTrailingWhitespace" = true;
        "python.analysis.typeCheckingMode" = "basic";
        "python.languageServer" = "Pylance";
        "terminal.integrated.fontFamily" = "Cousine Nerd Font Mono";
        "window.titleBarStyle" = "custom";
        "window.zoomLevel" = 1;
        "workbench.colorTheme" = "Nord";
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.sideBar.location" = "right";
        "extensions.ignoreRecommendations" = true;
      };
    };
  };
}
