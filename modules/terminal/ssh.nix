{...}: {
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
}
