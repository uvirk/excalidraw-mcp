# Excalidraw MCP App Server

MCP server that streams hand-drawn Excalidraw diagrams with smooth viewport camera control and interactive fullscreen editing.

![Demo](docs/demo.gif)

## Install

Works with any client that supports [MCP Apps](https://modelcontextprotocol.io/docs/extensions/apps) — Claude, ChatGPT, VS Code, Goose, and others. If something doesn't work, please [open an issue](https://github.com/antonpk1/excalidraw-mcp-app/issues).

### Remote (recommended)

### `https://excalidraw-mcp-app.vercel.app/mcp`

Add as a remote MCP server in your client. For example, in [claude.ai](https://claude.ai): **Settings** → **Connectors** → **Add custom connector** → paste the URL above.

### Local

**Option A: Download Extension**

1. Download `excalidraw-mcp-app.mcpb` from [Releases](https://github.com/antonpk1/excalidraw-mcp-app/releases)
2. Double-click to install in Claude Desktop

**Option B: Build from Source**

```bash
git clone https://github.com/antonpk1/excalidraw-mcp-app.git
cd excalidraw-mcp-app
npm install && npm run build
```

Add to `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "excalidraw": {
      "command": "node",
      "args": ["/path/to/excalidraw-mcp-app/dist/index.js", "--stdio"]
    }
  }
}
```

Restart Claude Desktop.

## Usage

Example prompts:
- "Draw a cute cat using excalidraw"
- "Draw an architecture diagram showing a user connecting to an API server which talks to a database"

## What are MCP Apps and how can I build one?

Text responses can only go so far. Sometimes users need to interact with data, not just read about it. [MCP Apps](https://github.com/modelcontextprotocol/ext-apps/) is an official Model Context Protocol extension that lets servers return interactive HTML interfaces (data visualizations, forms, dashboards) that render directly in the chat.

- **Getting started for humans**: [documentation](https://modelcontextprotocol.io/docs/extensions/apps)
- **Getting started for AIs**: [skill](https://github.com/modelcontextprotocol/ext-apps/blob/main/plugins/mcp-apps/skills/create-mcp-app/SKILL.md)

## Contributing

PRs welcome! See [Local](#local) above for build instructions.

### Deploy your own instance

#### Vercel

You can deploy your own copy to Vercel in a few clicks:

1. Fork this repo
2. Go to [vercel.com/new](https://vercel.com/new) and import your fork
3. No environment variables needed — just deploy
4. Your server will be at `https://your-project.vercel.app/mcp`

#### Azure Container Apps

Deploy to [Azure Container Apps](https://learn.microsoft.com/azure/container-apps/overview) using the Azure Developer CLI (`azd`). This provisions all required Azure resources and deploys the MCP server in a single command.

**Prerequisites:**

- An [Azure subscription](https://azure.microsoft.com/free/)
- [Azure Developer CLI (`azd`)](https://learn.microsoft.com/azure/developer/azure-developer-cli/install-azd) installed
- [Docker](https://docs.docker.com/get-docker/) installed and running (used to build the container image)

**Step 1 — Clone and navigate to the repo:**

```bash
git clone https://github.com/uvirk/excalidraw-mcp.git
cd excalidraw-mcp
```

**Step 2 — Authenticate with Azure:**

```bash
azd auth login
```

**Step 3 — Deploy everything:**

```bash
azd up
```

You will be prompted for:
- **Environment name** — a label for this deployment (e.g. `excalidraw-prod`)
- **Azure location** — the region to deploy to (e.g. `eastus2`, `westus3`)

`azd up` will automatically:
1. Create a resource group (`rg-<environment-name>`)
2. Provision an Azure Container Registry, Log Analytics workspace, and Container Apps environment
3. Build the Docker image and push it to the registry
4. Deploy the container to Azure Container Apps with external ingress

When complete, the output will display your endpoint:

```
SERVICE_APP_URI = https://<your-app>.<region>.azurecontainerapps.io
```

**Step 4 — Use the MCP endpoint:**

Your MCP server URL is:

```
https://<your-app>.<region>.azurecontainerapps.io/mcp
```

Add this URL as a remote MCP server in any MCP-compatible client (Claude, ChatGPT, VS Code, etc.).

**Updating the deployment:**

After making code changes, redeploy with:

```bash
azd deploy
```

This rebuilds the container and updates the app without reprovisioning infrastructure.

**Cleaning up resources:**

To remove all provisioned Azure resources and avoid ongoing charges:

```bash
azd down
```

<details>
<summary>Using with Azure AI Foundry</summary>

To use the deployed MCP server as a tool in [Azure AI Foundry](https://learn.microsoft.com/azure/ai-services/agents/):

1. Open your project in [Azure AI Foundry](https://ai.azure.com)
2. Navigate to your agent configuration
3. Add a new MCP tool and paste your endpoint URL: `https://<your-app>.<region>.azurecontainerapps.io/mcp`
4. The `read_me` and `create_view` tools will be available to the agent

</details>

<details>
<summary>Manual Docker deployment (without azd)</summary>

If you prefer to manage infrastructure yourself, you can build and push the container image manually:

```bash
# Build the container image
docker build -t excalidraw-mcp .

# Test locally
docker run -p 8080:8080 excalidraw-mcp
# Server available at http://localhost:8080/mcp

# Push to an existing Azure Container Registry
az acr login --name <your-registry>
docker tag excalidraw-mcp <your-registry>.azurecr.io/excalidraw-mcp:latest
docker push <your-registry>.azurecr.io/excalidraw-mcp:latest
```

Then create a Container App in the Azure Portal or via `az containerapp create` pointing to your image.

</details>

### Release checklist

<details>
<summary>For maintainers</summary>

```bash
# 1. Bump version in manifest.json and package.json
# 2. Build and pack
npm run build && mcpb pack .

# 3. Create GitHub release
gh release create v0.3.0 excalidraw-mcp-app.mcpb --title "v0.3.0" --notes "What changed"

# 4. Deploy to Vercel
vercel --prod
```

</details>

## Credits

Built with [Excalidraw](https://github.com/excalidraw/excalidraw) — a virtual whiteboard for sketching hand-drawn like diagrams.

## License

MIT
