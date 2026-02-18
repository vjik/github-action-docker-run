# `vjik/docker-run` GitHub Action

[![GitHub release](https://img.shields.io/github/v/release/vjik/docker-run?style=flat-square)](https://github.com/vjik/docker-run/releases)
[![License](https://img.shields.io/github/license/vjik/docker-run?style=flat-square)](./LICENSE)

GitHub Action that runs a command in a new Docker container with a simple, declarative syntax.

**Features:**

- Run commands in any Docker image directly from your workflow
- Mount volumes and pass environment variables with multi-line input support
- Authenticate with private registries (Docker Hub, GHCR, and others)
- Pass additional `docker run` options for full flexibility

> [!IMPORTANT]
> This project is developed and maintained by [Sergei Predvoditelev](https://github.com/vjik).
> Community support helps keep the project actively developed and well maintained.
> You can support the project using the following services:
>
> - [Boosty](https://boosty.to/vjik)
> - [CloudTips](https://pay.cloudtips.ru/p/192ce69b)
>
> Thank you for your support ❤️

## General usage

### Basic

```yaml
- uses: vjik/docker-run@v1
  with:
    image: ubuntu:24.04
    command: echo "Hello from container"
```

### Volume mounts and environment variables

```yaml
- uses: vjik/docker-run@v1
  with:
    image: python:3.12
    volumes: |
      ${{ github.workspace }}:/work
      /tmp/cache:/cache
    env: |
      CI=true
      GREETING=Hello World
    workdir: /work
    command: |
      pip install -r requirements.txt
      python -m pytest tests/
```

### Using bash

By default, commands run via `sh -c`. To use bash-specific syntax, invoke `bash -c` explicitly:

```yaml
- uses: vjik/docker-run@v1
  with:
    image: bash:5
    volumes: ${{ github.workspace }}:/work
    command: |
      bash -c 'arr=(one two three); echo "${arr[@]}" > /work/result.txt'
```

### Private registry

```yaml
- uses: vjik/docker-run@v1
  with:
    image: ghcr.io/my-org/my-image:latest
    registry: ghcr.io
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}
    command: echo "Authenticated"
```

Without `registry`, authentication defaults to Docker Hub:

```yaml
- uses: vjik/docker-run@v1
  with:
    image: my-org/my-private-image:latest
    username: ${{ secrets.DOCKERHUB_USERNAME }}
    password: ${{ secrets.DOCKERHUB_TOKEN }}
    command: echo "Authenticated to Docker Hub"
```

## Inputs

| Input      | Required  | Description                                                                                |
|------------|-----------|--------------------------------------------------------------------------------------------|
| `image`    | Yes       | Docker image to run (e.g. `ubuntu:24.04`, `python:3.12`)                                   |
| `command`  | Yes       | Shell command to run inside the container                                                  |
| `volumes`  | No        | Volume mounts, one per line (e.g. `/host/path:/container/path`)                            |
| `env`      | No        | Environment variables, one per line (e.g. `MY_VAR=some value`)                             |
| `workdir`  | No        | Working directory inside the container                                                     |
| `options`  | No        | Additional `docker run` options (e.g. `--network host --cpus 2`)                           |
| `registry` | No        | Docker registry URL for authentication (e.g. `ghcr.io`). Defaults to Docker Hub if omitted |
| `username` | No        | Username for Docker registry authentication                                                |
| `password` | No        | Password or token for Docker registry authentication                                       |

## Limitations

- Values with spaces in the `options` input are not supported (e.g. `-e MY_VAR="Hello World"`). Use `volumes` and `env`
  inputs instead, which handle spaces correctly.
- The command is executed via `sh -c`, so bash-specific syntax is not available unless the container image includes bash
  and you invoke it explicitly (e.g. `bash -c "..."`).

## License

The `vjik/docker-run` is free software. It is released under the terms of the BSD License.
Please see [`LICENSE`](./LICENSE) for more information.

## Credits

The package is inspired by [addnab/docker-run-action](https://github.com/addnab/docker-run-action) package.
