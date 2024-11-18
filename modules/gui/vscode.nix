{
  config,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.vscode;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = true;
    extensions = with pkgs.vscode-extensions; [
      arcticicestudio.nord-visual-studio-code
      bbenoist.nix
      bmalehorn.vscode-fish
      esbenp.prettier-vscode
      kamadorueda.alejandra
      mhutchie.git-graph
      ms-python.python
      ms-python.vscode-pylance
      ms-vscode-remote.remote-ssh
      redhat.vscode-yaml
      tamasfe.even-better-toml
      equinusocio.vsc-material-theme-icons
    ];
    userSettings = {
      "[json]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
      "[python]" = {"editor.defaultFormatter" = null;};
      "[yaml]" = {"editor.defaultFormatter" = "redhat.vscode-yaml";};
      "editor.copyWithSyntaxHighlighting" = false;
      "editor.fontFamily" = "'Cousine', 'Hack', 'monospace', monospace, 'Droid Sans Fallback'";
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
      "workbench.iconTheme" = "eq-material-theme-icons";
      "workbench.sideBar.location" = "right";
      "extensions.ignoreRecommendations" = true;
    };
  };
}
