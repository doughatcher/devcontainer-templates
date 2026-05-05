# Devcontainer Templates

A collection of [Dev Container Templates](https://containers.dev/implementors/templates/) for Magento and adjacent projects.

## Available templates

| ID | Name | Description |
|----|------|-------------|
| [`magento`](./src/magento/) | Magento Open Source | Magento 2 (Community Edition) with PHP-FPM, MariaDB, Redis, RabbitMQ, OpenSearch, MailHog, optional Nginx sidecar. Auto-installs on first start. |

## Usage

Apply a template into a new project directory:

```bash
devcontainer templates apply \
  --template-id ghcr.io/doughatcher/devcontainer-templates/magento \
  --workspace-folder ./my-magento-project
```

Or use the VS Code command palette: **Dev Containers: Add Dev Container Configuration Files…** → **From a predefined Dev Container Template…** and pick the template from the registry.

## Local development

```bash
make help            # list targets
make build           # build the magento template via `devcontainer up`
make publish         # publish to GHCR (requires GITHUB_TOKEN with write:packages)
```

The default GHCR namespace is `doughatcher/devcontainer-templates`. Override with `make publish NAMESPACE=youruser/yourrepo`.

## Maintaining template parity with the Magento working repo

The `magento` template is sourced from [`doughatcher/magento`](https://github.com/doughatcher/magento)'s `.devcontainer/` directory, which is a live, exercised Magento installation. When making changes:

1. Prototype in `doughatcher/magento` — that's where the devcontainer is run continuously and bugs surface fast.
2. Once stable, sync the changed files into `src/magento/.devcontainer/` here.
3. For any file that contains version strings (`Dockerfile-magento`, `.env`, `commerce.sh`), preserve the `${templateOption:phpVersion}` / `${templateOption:composerVersion}` / `${templateOption:commerceEdition}` substitutions.
4. Run `make build` to smoke-test, then bump `version` in `src/magento/devcontainer-template.json` before pushing to main.

## References

- [Dev Container spec — Templates](https://containers.dev/implementors/templates/)
- [`devcontainers/templates`](https://github.com/devcontainers/templates) — the official template index
- [Submittal PR (legacy)](https://github.com/devcontainers/devcontainers.github.io/pull/500)
