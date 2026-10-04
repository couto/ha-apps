# ha-apps

Home Assistant apps (add-ons) for the home that runs the
[ha-config](../ha-config) repository.

| App | What it does |
|---|---|
| [Docs](docs/) | Shows the family docs (`docs/` in the HA `/config` folder) as a website in the HA sidebar, behind the HA login. Hugo with the Lotus Docs theme. Work in progress: the HA "Docs" dashboard is still the one in use. |

## Install

Settings > Apps > App store > ⋮ > Repositories, add this repository's
URL, then install the app. For a quick test without pushing, copy an app
folder to `/addons/<app>` on the host and use "Check for updates".

## Local preview of the Docs site

```sh
mise trust
mise run docs:serve        # http://localhost:1313/docs/
```

It reads the Markdown from `../ha-config/docs`. Set `DOCS_DIR` to use
another folder. Hugo comes from `mise.toml`; the theme and its Hugo
modules are fetched from `docs/site/modules.lock` (no Go, no npm).
