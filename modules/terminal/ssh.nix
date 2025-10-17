{...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      addKeysToAgent = "yes";
      compression = true;
      controlMaster = "auto";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "10m";
      forwardAgent = false;
      hashKnownHosts = false;
      serverAliveCountMax = 3;
      serverAliveInterval = 25;
      setEnv = {
        TERM = "xterm-256color";
      };
      userKnownHostsFile = "~/.ssh/known_hosts";
    };
    extraConfig = ''
      ForwardX11 no
    '';
    includes = [
      "config.d/*"
    ];
  };

  # SSH Agent systemd user service
  services.ssh-agent.enable = true;
}
