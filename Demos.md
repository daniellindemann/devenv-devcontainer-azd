# Demos

## Vor Demo

> Diese Konfiguration machen, bevor es in die Demo geht. Sonst dauert es zu lange.

Öffne Dev Container `C# (.NET) with azd` und starte die Bereitstellung in Azure, da es bis zu 15min dauern kann, bis alle Ressourcen in Azure bereitgestellt sind

```bash
# login
azd auth login
# create resources
azd up
```

## App Demo erklären

- Beer Voting App
- Frontend und Backend
- Frontend mir Razor
- Backend als WebAPI mit Controller
- Datenbank wählbar
    - In-Memory Datenbank
    - MS SQL

## Erstellen eines Dev Containers

- VS Code Command Palette öffnen
- Wähle `Dev Containers: Add Dev Container Configuration Files...`
- *Durchgehen und besprechen welche Vorlagen es gibt*
- Wähle `C# (.NET)`
- *Durchgehen und besprechen welche Distributionen es gibt*
- Wähle `8.0-jammy` für *Ubuntu 22.04 (Jammy Jellyfish)* 
- *Durchgehenen Features (Apps)*
- Keine Apps auswählen
- `devcontainer.json` öffnen und *durchgehen was darin steht*
- Command Palette öffnen und `Dev Containers: Reopen in container`
- *Zeigen was passiert*
    - Image wird erstellt, mit allen Features inkludiert
    - Container auf Basis des Images wird erstellt
- Applikation ausführen
    - Launch `Full app`
    - Durchklicken
- Benutzerspezifische Settings
    - Siehe `settings.json` (Command Palette `Preferences: Open user settings (JSON)`)
    Beispiele für Settings:

        ```json
        {
            // default extensions for dev containers
            "dev.containers.defaultExtensions": [
                // themes
                "robbowen.synthwave-vscode",
                // extensions
                "mhutchie.git-graph",
                "eamodio.gitlens",
                "vivaxy.vscode-conventional-commits",
                "github.copilot-chat",
                "ms-vsliveshare.vsliveshare"
            ],
            // default features for dev containers
            "dev.containers.defaultFeatures": {
                "ghcr.io/devcontainers/features/azure-cli:1": {
                    "installBicep": true,
                    "version": "latest"
                },
                "ghcr.io/stuartleeks/dev-container-features/azure-cli-persistence:0": {},
                "ghcr.io/stuartleeks/dev-container-features/shell-history:0": {}
            },
            // dotfiles
            // "dotfiles.installCommand": "install.sh",
            // "dotfiles.repository": "https://github.com/daniellindemann/dotfiles",
            // "dotfiles.targetPath": "~/dotfiles",
            // "dev.containers.copyGitConfig": false,
        }
        ```

## Dev Container mit SQL Server

- VS Code Command Palette öffnen
- Command Palette öffnen und `Dev Containers: Reopen in container`
- Wähle `C# (.NET) and MS SQL`
- `.devcontainer/02-sql/devcontainer.json` öffnen und *durchgehen was darin steht*
- `.devcontainer/02-sql/Dockerfile` öffnen und *durchgehen was darin steht*
- `.devcontainer/02-sql/docker-compose.yml` öffnen und *durchgehen was darin steht*
- `.devcontainer/02-sql/postCreateCommand.sh` öffnen und *durchgehen was darin steht*
- App benutzt Datenbank mit Storage in `.devcontainer-files`
    - Wird als Volume eingebunden
    - `devcontainer-files` sind nicht Teil des Repos
- Datenbank öffnen mit SQL Extension in VS Code
    - Connect to DB
        - Host: `localhost`
        - User: `sa`
        - Password: `P@ssw0rd`
    - Query:

        ```sql
        SELECT * FROM Beers
        ```

## GitHub Codespaces

- Gehe zu Projekt-Repo: <https://github.com/daniellindemann/devenv-devcontainer-azd>
- Click `Code`-Button
- *Codespaces*-Tab auswählen
- Öffne `...`-Menu
- Wähle `New with options...`
- Config:
    - Branch: `main`
    - Dev container configuration: `C# (.NET)`
    - Region: `West Europe`
    - Machine type: `2-core`
- Extension `C# DevKit` installieren, da nicht automatisch installiert
- Applikation ausführen

## Azure Developer CLI

- In Repo `without-azd-config` wechseln
- `azd init` ausführen und durchgehen
- *Erklären was passiert*
    - Nimmt Azure Container Apps
    - Geht auch App Services und AKS
- *Neue Dateien erklären*
    - `azure.yaml`
    - `.azure` Dir
    - `infra` Dir und `main.parameters.json`
- Anpassen der Config, da sie nicht direkt geht
    - In `.azure/environment/env.json` die . aus Projektname entfernen
    - In `main.bicep` die Resourcenamen für Apps ändern, da sie gleich heißen
        - Modul *demoBeerVotingBackend*
        - Modul *demoBeerVotingFrontend*
- Run `azd up`
    - Abbrechen, da zu lange dauert
- Wechsel in `main` branch
- Run `azd up`, da schon [vorbereitet](#vor-demo)
    - Mit SQL Server erweitert in Bicep
- *Erklären was passiert*
- App öffnen
- Neues Environment mit `azd env new <my-new-env-name>`
    - `azd up -e <my-new-env-name>`
- Löschen mit `azd down`
