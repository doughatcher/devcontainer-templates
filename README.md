# Doug Hatcher's Dev Container Templates

Landing page for the [Dev Container Templates](https://containers.dev/implementors/templates/) collection at `ghcr.io/doughatcher/devcontainer-templates`. Each template lives in its own working repository where it's actively used, and publishes itself to this shared OCI namespace on tagged releases.

## Available templates

| Template | Working Repo | OCI Reference | Status |
|----------|--------------|---------------|--------|
| **`magento`** — Magento Open Source 2.x | [doughatcher/magento](https://github.com/doughatcher/magento) | `ghcr.io/doughatcher/devcontainer-templates/magento` | ✅ Published |
| **`aem-app-builder`** — Adobe AEM with App Builder | _planned_ | _tbd_ | 🔜 Planned |
| **`aem-eds`** — Adobe AEM Edge Delivery Services | _planned_ | _tbd_ | 🔜 Planned |

## Using a template

```bash
devcontainer templates apply \
  --template-id ghcr.io/doughatcher/devcontainer-templates/magento \
  --workspace-folder ./my-project
```

Or in VS Code: **Dev Containers: Add Dev Container Configuration Files…** → **From a predefined Dev Container Template…** and pick from the registry.

## Architecture: working repos own their templates

Each template is published from its own working repository — the same repo where the dev container is exercised continuously. There's no separate "template source" tree to keep in sync. The publishing flow:

1. The working repo (e.g., `doughatcher/magento`) keeps its `.devcontainer/` runnable with hardcoded values (`php8.3`, etc.).
2. A `.template/build.sh` script in that repo copies the live tree into a scratch dir and lifts hardcoded values into `${templateOption:*}` markers.
3. A `.github/workflows/publish-template.yml` workflow, triggered on `template-v*` tags, runs the build script and publishes via `devcontainer templates publish` to `ghcr.io/doughatcher/devcontainer-templates/<id>`.

What each working repo's `.template/` directory contains:

```
.template/
├── devcontainer-template.json   # template manifest (id, version, options)
├── NOTES.md                     # extended docs (rendered into README at build time)
└── build.sh                     # working-tree → publishable artifact
```

This repository (`doughatcher/devcontainer-templates`) is just a landing page. It owns the OCI namespace's collection metadata and lists the available templates. It does not contain template source.

## Contributing a new template

Have a project that should be a template here? Open an issue. The pattern is:

1. Your working repo gets a `.template/` directory + a `publish-template.yml` workflow.
2. Workflow publishes to `ghcr.io/doughatcher/devcontainer-templates/<your-id>`.
3. Add a row to the table above so `devcontainer templates apply` users can find it.

## References

- [Dev Container spec — Templates](https://containers.dev/implementors/templates/)
- [`devcontainers/templates`](https://github.com/devcontainers/templates) — the official template index
- This collection's [official-index registration PR](https://github.com/devcontainers/devcontainers.github.io/pull/696)
