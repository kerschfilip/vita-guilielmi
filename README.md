# Vita Guilielmi – Digital Comparative Edition

A digital synoptic and comparative edition of the **_Vita et obitu sancti Guilielmi_**, comparing a 13th-century Beneventan manuscript preserved at the Abbey of Montevergine with the 1581 printed _editio princeps_ by Felice Renda.

Built with **TEI Publisher** running in **Docker**, generated and managed by **Jinks**, and synced in real time between local files and the database via the **existdb-vscode** extension. This repository contains all source files (TEI XML, ODD schemas, HTML templates, CSS, XQuery modules) that power the edition.

---
## Getting Started

> **Note:** This README is written for **collaborators joining an existing project**. It walks you through setting up your local environment so you can start working on the edition right away.
> 
> If you're starting a new TEI Publisher project from scratch (generating the app via Jinks, exporting the initial state, creating the repository), see the project setup notes on the [Wiki](https://github.com/kerschfilip/vita-guilielmi/wiki/TEI-Publisher-Collaborative-Workflow-Guide).

The workflow runs TEI Publisher locally in Docker, syncs files between your local Git folder and the database in real time, and uses GitHub for collaboration.

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [VS Code](https://code.visualstudio.com/) with the **existdb-vscode** extension installed
- Git
- A GitHub account with access to this repository

### One-time Setup

#### 1. Install Docker Desktop and start TEI Publisher

**On macOS / Linux:**

```bash
docker pull existdb/teipublisher:latest
docker run -d \
  -p 8088:8080 \
  --name teipublisher \
  existdb/teipublisher:latest
```

**On Windows (PowerShell):**

```powershell
docker pull existdb/teipublisher:latest
docker run -d `
  -p 8088:8080 `
  --name teipublisher `
  existdb/teipublisher:latest
```

> Note: PowerShell uses backtick (`` ` ``) for line continuation, not backslash. You can also write the command on a single line if preferred.

TEI Publisher is now at: [http://localhost:8088/exist/apps/tei-publisher/](http://localhost:8088/exist/apps/tei-publisher/)

#### 2. Generate the matching app with Jinks

Both collaborators must generate an app with the **same Abbreviation** so the database paths align.

1. Open the eXist-DB Dashboard: [http://localhost:8088/exist/apps/dashboard/](http://localhost:8088/exist/apps/dashboard/) (login: `admin`, empty password)
2. Open **Jinks** (login: `tei` / `simple`)
3. In **Application Configuration**, set:
    - **Abbreviation:** `vita-guilielmi`
    - **Label:** _Vita Guilielmi – Digital Comparative Edition_
    - **Unique identifier:** `https://e-editiones.org/apps/vita-guilielmi`
4. Click **Apply** and wait for the app to be created.

#### 3. Clone this repository

```bash
mkdir -p ~/docker
cd ~/docker
git clone https://github.com/kerschfilip/vita-guilielmi.git
cd vita-guilielmi
```

> On Windows, replace `~/docker` with a path like `C:\Users\yourname\Documents\docker`.

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

The **order of operations matters** – existdb-vscode only syncs files that change _while it is running_. If you `git pull` before starting the sync, the plugin won't see those changes and won't push them to the database.

**Correct order:**

1. **Start Docker container** if not running:
    
    ```bash
    docker start teipublisher
    ```
    
2. **Open VS Code** in the project folder.
3. **Start sync first:** Command Palette (`Cmd+Shift+P` on Mac / `Ctrl+Shift+P` on Windows) → **eXist-db: Control folder synchronization to database**. Wait until the terminal shows `Watching /path/to/vita-guilielmi`.
4. **Then pull from GitHub:**
    - VS Code Source Control → Sync Changes (arrow icon)
    - Or Terminal: `cd ~/docker/vita-guilielmi && git pull`
5. The plugin now picks up each pulled file change and uploads it to the database.
6. Open your app: [http://localhost:8088/exist/apps/vita-guilielmi/](http://localhost:8088/exist/apps/vita-guilielmi/)

> If you accidentally pulled before starting sync, you can re-trigger the upload by touching the files (e.g., open and re-save them in VS Code), or restart the sync.

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

----

## Where to Make Changes – Three Scenarios

There are three places you can change your application: VS Code, Jinks, or the TEI Publisher GUI. Each requires a different sync approach.

### Scenario 1: Editing in VS Code (recommended for daily work)

This is the easiest case. You edit files in `~/docker/vita-guilielmi/` on your machine, the existdb-vscode plugin pushes every save to the database automatically, and you commit through Git as usual.

Use VS Code for: TEI XML documents, ODD files (text editing), CSS, HTML templates, XQuery modules.

### Scenario 2: Changes through Jinks (Apply, theme, config, profiles)

Jinks writes its output directly into the database, so the existdb-vscode plugin won't see those changes. After every **Apply** in Jinks (or any change to the app's theme, features, or configuration), you need to pull the changes back to your local folder:

1. In Jinks, click **Sync** in the bottom toolbar.
2. Enter the path: `/exist/sync/vita-guilielmi` and click **Run**.
3. In Terminal:

bash

```bash
   docker cp teipublisher:/exist/sync/vita-guilielmi/. ~/docker/vita-guilielmi/
```

(On Windows, adjust the destination path, e.g., `C:\Users\yourname\Documents\docker\vita-guilielmi\`.) 

4. Open VS Code's Source Control panel, review the changes, commit, and push.

### Scenario 3: Editing the ODD through the GUI editor in TEI Publisher

The visual ODD editor in TEI Publisher also writes changes directly to the database. The procedure is the same as Scenario 2 (Jinks Sync + `docker cp`).

> **Rule of thumb:** After any work done in the TEI Publisher or Jinks web interface, always do **Jinks Sync + `docker cp`** before committing, so Git accurately reflects the current state.

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

### "Connecting to server failed" / 400

- This usually means the server is reachable but the helper package didn't install correctly, or the URL context is wrong.
- Try changing the server URL in `.existdb.json` from `http://localhost:8088/exist` to `http://localhost:8088` (without `/exist`) and restart sync.
- If installation failed because of a `503` error from `exist-db.org/exist/apps/public-repo`, the upstream package repository was temporarily down. Wait a few minutes and try again.
- If the public-repo is unreachable, you can install the helper XAR manually:
    1. Download it from [https://github.com/wolfgangmm/existdb-langserver/tree/master/resources](https://github.com/wolfgangmm/existdb-langserver/tree/master/resources)
    2. Open the eXist-DB Dashboard → Package Manager → click the upload icon → select the `.xar` file
    3. Restart sync in VS Code

### Pulled changes don't show up in the app

- Check the order: `docker start` → start sync in VS Code → **then** `git pull`. If the plugin wasn't running during the pull, files won't auto-sync.
- Quick fix: open one of the pulled files in VS Code and re-save it (`Cmd+S` / `Ctrl+S`) – this triggers an upload.

### Git conflict

Use VS Code's built-in merge editor to resolve, then commit and push.

---

## Quick Reference

|Task|How|
|---|---|
|Start Docker container|`docker start teipublisher`|
|Stop container|`docker stop teipublisher`|
|Start sync|Command Palette → **eXist-db: Control folder synchronization to database**|
|Open the edition|[http://localhost:8088/exist/apps/vita-guilielmi/](http://localhost:8088/exist/apps/vita-guilielmi/)|
|Open TEI Publisher|[http://localhost:8088/exist/apps/tei-publisher/](http://localhost:8088/exist/apps/tei-publisher/)|
|Open Jinks|[http://localhost:8088/exist/apps/jinks/](http://localhost:8088/exist/apps/jinks/)|
|Open eXide editor|[http://localhost:8088/exist/apps/eXide/](http://localhost:8088/exist/apps/eXide/)|
|Open Dashboard|[http://localhost:8088/exist/apps/dashboard/](http://localhost:8088/exist/apps/dashboard/)|
|Create Collection in eXide|`xmldb:create-collection("/db/apps/vita-guilielmi/data", "vita-guilielmi")`|
|Reindex Collection in eXide|`xmldb:reindex("/db/apps/vita-guilielmi/data/vita-guilielmi")`|

### Default Credentials

- **eXist-DB / Dashboard / eXide:** `admin` / _(empty password)_
- **TEI Publisher / Jinks:** `tei` / `simple`

---
## License

To be added. The edition aims to be an open and sustainable resource in accordance with FAIR principles.