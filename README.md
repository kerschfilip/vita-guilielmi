# Vita Guilielmi – Digital Comparative Edition

A digital synoptic and comparative edition of the **_Vita et obitu sancti Guilielmi_**, comparing a 13th-century Beneventan manuscript preserved at the Abbey of Montevergine with the 1581 printed *editio princeps* by Felice Renda.

Built with **TEI Publisher** running in **Docker**, generated and managed by **Jinks**, and synced in real time between local files and the database via the **existdb-vscode** extension. This repository contains all source files (TEI XML, ODD schemas, HTML templates, CSS, XQuery modules) that power the edition.

---

## Getting Started

This setup assumes you're working on **macOS**. The workflow runs TEI Publisher locally in Docker, syncs files between your local Git folder and the database in real time, and uses GitHub for collaboration.

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [VS Code](https://code.visualstudio.com/) with the **existdb-vscode** extension installed
- Git
- A GitHub account with access to this repository

### One-time Setup

#### 1. Install Docker Desktop and start TEI Publisher

```bash
docker pull existdb/teipublisher:latest
docker run -d \
  -p 8088:8080 \
  --name teipublisher \
  existdb/teipublisher:latest
```

TEI Publisher is now at: [http://localhost:8088/exist/apps/tei-publisher/](http://localhost:8088/exist/apps/tei-publisher/)

#### 2. Generate the matching app with Jinks

Both collaborators must generate an app with the **same Abbreviation** so the database paths align.

1. Open the eXist-DB Dashboard: [http://localhost:8088/exist/apps/dashboard/](http://localhost:8088/exist/apps/dashboard/) (login: `admin`, empty password)
2. Open **Jinks** (login: `tei` / `simple`)
3. In **Application Configuration**, set:
   - **Abbreviation:** `vita-guilielmi`
   - **Label:** *Vita Guilielmi – Digital Comparative Edition*
   - **Unique identifier:** `https://e-editiones.org/apps/vita-guilielmi`
4. Click **Apply** and wait for the app to be created.

#### 3. Clone this repository

```bash
mkdir -p ~/docker
cd ~/docker
git clone https://github.com/your-username/vita-guilielmi.git
cd vita-guilielmi
```

#### 4. Create your local `.existdb.json`

Create a file `.existdb.json` in the repo root with this content:

```json
{
    "servers": {
        "localhost": {
            "server": "http://localhost:8088/exist",
            "user": "admin",
            "password": "",
            "root": "/apps/vita-guilielmi"
        }
    },
    "sync": {
        "server": "localhost",
        "polling": false,
        "interval": 500,
        "ignore": [
            ".existdb.json",
            ".devcontainer/**",
            ".vscode/**",
            "build.sh",
            ".env",
            ".git/**",
            "components/**",
            "node_modules/**",
            "bower_components/**",
            "build/**",
            "webtest/**"
        ]
    }
}
```

> This file is intentionally **not committed to Git** (each machine needs its own).

#### 5. Open in VS Code and start syncing

In VS Code:

1. Open Command Palette (`Cmd+Shift+P`) → **eXist-db: Control folder synchronization to database**
2. When prompted to install the helper package (banner at the top), click **Install**
3. The terminal should show `Watching /Users/.../vita-guilielmi` – the plugin now uploads any saved file into the database

#### 6. Verify it works

Open [http://localhost:8088/exist/apps/vita-guilielmi/](http://localhost:8088/exist/apps/vita-guilielmi/) – you should see the edition. Try editing a CSS file in `resources/css/` and saving (`Cmd+S`). Refresh the browser to see the change.

---

## Daily Workflow

### Start of session

```bash
docker start teipublisher                    # if container isn't running
cd ~/docker/vita-guilielmi
git pull                                     # get collaborator's changes
```

In VS Code: `Cmd+Shift+P` → **eXist-db: Control folder synchronization to database** to start sync.

### While working

Edit files in VS Code. Every save is automatically pushed to the database. Refresh [http://localhost:8088/exist/apps/vita-guilielmi/](http://localhost:8088/exist/apps/vita-guilielmi/) to see your changes.

You'll typically be editing:

- TEI XML documents in `data/`
- ODD schema in `resources/odd/`
- CSS theme in `resources/css/`
- HTML templates in `templates/pages/`
- XQuery modules in `modules/`

### End of session

```bash
git add .
git commit -m "describe what you changed"
git push
```

Or use VS Code's Source Control panel (`Cmd+Shift+G`) → write a commit message → **Commit & Push**.

---

## Important Rules

- **Always add TEI XML documents through the local `data/` folder in VS Code**, not via TEI Publisher's web upload interface. Files uploaded via the web UI live only in the database and won't be tracked by Git.
- **Communicate with your collaborator** before working on the same file simultaneously to avoid Git conflicts.
- **App Abbreviation must match** (`vita-guilielmi`) across all machines, otherwise the database paths won't align.
- **Commit regularly.** If your Docker container is deleted, the database goes with it – Git is your real backup.

---

## Updating from Upstream (TEI Publisher / Jinks updates)

When TEI Publisher or its profiles get a new version:

1. Open Jinks → select the app → click **Apply**.
2. Review the **Command Output** dialog. Files marked with a brown **conflict** label have local changes Jinks won't overwrite – you decide whether to keep yours or accept the upstream version.
3. After Jinks finishes, your existdb-vscode plugin detects the changes – pull them into your VS Code folder by running sync.
4. Review the diff in Git, commit, push.

See the [Jinks documentation](https://e-editiones.org/) for details on conflict handling and the `skip` config option.

---

## Troubleshooting

### "Communication with the server failed" / 404

- The helper package isn't installed. Trigger the banner by opening a file in VS Code and starting sync; click **Install**.
- Check `.existdb.json` uses port `8088`, not `8080`.

### Files don't appear after sync

- Check the VS Code sync terminal shows `Watching /Users/.../vita-guilielmi`.
- Hard refresh the browser (`Cmd+Shift+R`).
- Force a reindex via [eXide](http://localhost:8088/exist/apps/eXide/):
  ```xquery
  xquery version "3.1";
  xmldb:reindex("/db/apps/vita-guilielmi")
  ```

### Sync stopped working

- The sync terminal may have closed. Run **eXist-db: Control folder synchronization to database** again.
- Check Docker is running: `docker ps` should list `teipublisher`.

---

## Quick Reference

| Task | How |
|---|---|
| Start Docker container | `docker start teipublisher` |
| Stop container | `docker stop teipublisher` |
| Start sync | Command Palette → **eXist-db: Control folder synchronization to database** |
| Open the edition | [http://localhost:8088/exist/apps/vita-guilielmi/](http://localhost:8088/exist/apps/vita-guilielmi/) |
| Open TEI Publisher | [http://localhost:8088/exist/apps/tei-publisher/](http://localhost:8088/exist/apps/tei-publisher/) |
| Open Jinks | [http://localhost:8088/exist/apps/jinks/](http://localhost:8088/exist/apps/jinks/) |
| Open eXide editor | [http://localhost:8088/exist/apps/eXide/](http://localhost:8088/exist/apps/eXide/) |
| Open Dashboard | [http://localhost:8088/exist/apps/dashboard/](http://localhost:8088/exist/apps/dashboard/) |

### Default Credentials

- **eXist-DB / Dashboard / eXide:** `admin` / *(empty password)*
- **TEI Publisher / Jinks:** `tei` / `simple`

--- 

## License

To be added. The edition aims to be an open and sustainable resource in accordance with FAIR principles.