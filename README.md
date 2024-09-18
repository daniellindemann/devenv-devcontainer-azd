# devenv-devcontainer-azd

Code of my talk "Zeitfresser gebändigt: Optimierung von Entwicklungsumgebungen"

## Prerequisites

- [VS Code](https://code.visualstudio.com/) with [Dev Container Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) installed
- [Docker](https://www.docker.com/products/docker-desktop/) or other compatible container runtime like [Rancher](https://rancherdesktop.io/) or [OrbStack](https://orbstack.dev/)

## Run the application

- Open in container and run debug

## Dev container configurations

| Environment name | Configuration |
| ---------------- | ------------- |
| *"C# (.NET)* | Ubuntu 22.04 (Jammy Jellyfish), In-memory database |
| *C# (.NET) and MS SQL* | Ubuntu 22.04 (Jammy Jellyfish), Dedicated SQL server as container on Docker Compose stack  |
| *C# (.NET) with azd* | Ubuntu 22.04 (Jammy Jellyfish), In-memory database, Docker-in-Docker, Azure Developer CLI (azd) and other features |

## Demos

See [Demos](Demos.md)
