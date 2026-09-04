{
  pkgs,
  lib,
  ...
}: {
  programs.github-copilot-cli = {
    enable = true;

    # General settings for Copilot CLI (written to ~/.copilot/config.json)
    settings.model = "gemini-3.8-flash";

    # Language Server Protocol (LSP) integrations for code intelligence (written to lsp-config.json)
    # Note: Language server packages must be in pkgs / PATH (e.g. nixd, pyright)
    lspServers = {
      nix = {
        command = "${pkgs.nixd}/bin/nixd";
        fileExtensions = {
          ".nix" = "nix";
        };
      };
      python = {
        command = "${pkgs.pyright}/bin/pyright-langserver";
        args = ["--stdio"];
        fileExtensions = {
          ".py" = "python";
        };
      };
    };

    # Model Context Protocol (MCP) servers (written to mcp-config.json)
    mcpServers = {
      # Axis Jira MCP integration
      "se.axis.rndtools/jira-mcp-server" = {
        tools = ["*"];
        type = "stdio";
        command = "${pkgs.uv}/bin/uvx";
        args = [
          "axis-mcp-atlassian@0.21.2.dev10"
        ];
        env = {
          UV_INDEX_URL = "\${UV_INDEX_URL}";
          JIRA_PERSONAL_TOKEN = "\${JIRA_PERSONAL_TOKEN}";
          JIRA_PROJECTS_FILTER = "\${JIRA_PROJECTS_FILTER}";
          JIRA_URL = "\${JIRA_URL}";
          JIRA_USERNAME = "\${JIRA_USERNAME}";
          CONFLUENCE_URL = "\${CONFLUENCE_URL}";
          CONFLUENCE_PERSONAL_TOKEN = "\${CONFLUENCE_TOKEN}";
          CONFLUENCE_SPACES_FILTER = "\${CONFLUENCE_SPACES_FILTER}";
          READ_ONLY_MODE = "true";
          TOOLSETS = "all";
        };
      };

      # Kubernetes / Kube-context MCP server example
      # k8s = {
      #   type = "local";
      #   command = "${pkgs.nodejs}/bin/npx";
      #   args = ["-y" "mcp-server-kubernetes"];
      # };

      # PostgreSQL / CNPG MCP server example
      # postgres = {
      #   type = "local";
      #   command = "${pkgs.nodejs}/bin/npx";
      #   args = ["-y" "@modelcontextprotocol/server-postgres" "postgresql://localhost:5432/mydb"];
      # };
    };

    # Custom Agents: specialized personas invoked via `/agent <name>` (written to ~/.copilot/agents/<name>.agent.md)
    # agents = {
    #   db-reviewer = ''
    #     You are a database reliability engineer specializing in ClickHouse on bare-metal and CloudNative-PG on Kubernetes.
    #     When reviewing or proposing database changes:
    #     - Check for table locks, migration safety, and zero-downtime rollouts.
    #     - For ClickHouse: verify partition key choices, avoid unpartitioned ALTER UPDATE/DELETE mutations, and prefer lightweight deletes.
    #     - For PostgreSQL/CNPG: verify transaction safety and concurrent index creation.
    #   '';

    #   k8s-operator = ''
    #     You are an infrastructure engineer working with on-premises Kubernetes and CloudNative-PG clusters.
    #     - Always use dry-run mode (`--dry-run=client -o yaml`) when generating kubectl commands.
    #     - Prioritize safety, resource quotas, and pod disruption budgets.
    #   '';
    # };

    # Custom Skills: reusable procedures automatically invoked when relevant (written to ~/.copilot/skills/<name>/SKILL.md)
    skills = {
      # Cut most AI tells from any writing
      unslop = pkgs.fetchurl {
        url = https://raw.githubusercontent.com/cursor/plugins/73f8be4873ea4ba2b7378243a036d3360c69e04d/pstack/skills/unslop/SKILL.md;
        hash = "sha256-J4mrgEd7fjgikuTXrMoQV3hN8ZcT//t0Yi/w+DsvNzM=";
      };
    };

    # # Global instructions applied across all repositories (written to ~/.copilot/copilot-instructions.md)
    # context = ''
    #   # Global Environment & Tech Stack Context
    #   - Platform: Linux (Ubuntu/Debian/Arch) with bare-metal machines and on-prem Kubernetes.
    #   - Core Stack: Python (3.12+, uv), Nix (flakes, formatted with alejandra), ClickHouse, CloudNative-PG, Dagster, DBT.

    #   # Safety & Best Practices
    #   - Kubernetes: Never run destructive kubectl/helm commands without confirmation; suggest dry-run where possible.
    #   - Database migrations: Always design backward-compatible, zero-downtime migrations.
    #   - ClickHouse: Respect columnar storage patterns, avoid full table mutations, and check partition key cardinality.
    #   - Data Pipelines: In Dagster and DBT, prioritize idempotency, explicit asset dependencies, and strict type schemas.
    # '';
  };
}
