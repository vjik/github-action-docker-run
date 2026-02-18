# `docker-run` GitHub Action

Run a command in a new Docker container.

## General usage

### Basic

```yaml
- uses: vjik/github-action-docker-run@v1
  with:
    image: ubuntu:24.04
    command: echo "Hello from container"
```

### Volume mounts and environment variables

```yaml
- uses: vjik/github-action-docker-run@v1
  with:
    image: python:3.12
    volumes: |
      ${{ github.workspace }}:/work
      /tmp/cache:/cache
    env: |
      CI=true
      GREETING=Hello World
    command: |
      cd /work
      pip install -r requirements.txt
      python -m pytest tests/
```

### Private registry

```yaml
- uses: vjik/github-action-docker-run@v1
  with:
    image: ghcr.io/my-org/my-image:latest
    registry: ghcr.io
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}
    command: echo "Authenticated"
```

Without `registry`, authentication defaults to Docker Hub:

```yaml
- uses: vjik/github-action-docker-run@v1
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

The `vjik/github-action-docker-run` is free software. It is released under the terms of the BSD License.
Please see [`LICENSE`](./LICENSE) for more information.

## Credits

The package is inspired by [addnab/docker-run-action](https://github.com/addnab/docker-run-action) package.
