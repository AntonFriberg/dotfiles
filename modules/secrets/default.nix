{
  config,
  pkgs,
  ...
}: {
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    secrets = {
      jira_personal_token = {};
      confluence_personal_token = {};
      jira_url = {};
      jira_username = {};
      jira_projects_filter = {};
      confluence_url = {};
      confluence_spaces_filter = {};
      uv_index_url = {};
    };

    templates = {
      "secrets.env" = {
        content = ''
          JIRA_PERSONAL_TOKEN="${config.sops.placeholder.jira_personal_token}"
          CONFLUENCE_TOKEN="${config.sops.placeholder.confluence_personal_token}"
          JIRA_URL="${config.sops.placeholder.jira_url}"
          JIRA_USERNAME="${config.sops.placeholder.jira_username}"
          JIRA_PROJECTS_FILTER="${config.sops.placeholder.jira_projects_filter}"
          CONFLUENCE_URL="${config.sops.placeholder.confluence_url}"
          CONFLUENCE_SPACES_FILTER="${config.sops.placeholder.confluence_spaces_filter}"
          UV_INDEX_URL="${config.sops.placeholder.uv_index_url}"
        '';
      };
    };
  };

  home.packages = with pkgs; [
    sops
    age
  ];
}
