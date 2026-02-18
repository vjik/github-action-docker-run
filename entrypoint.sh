#!/usr/bin/env sh
set -eu

username=${INPUT_USERNAME-}
password=${INPUT_PASSWORD-}
registry=${INPUT_REGISTRY-}
if [ -n "$username" ] || [ -n "$password" ]; then
  if [ -z "$username" ] || [ -z "$password" ]; then
    echo "Error: username and password must be both set or both unset." >&2
    exit 1
  fi
  if [ -n "$registry" ]; then
    printf '%s' "$password" | docker login "$registry" -u "$username" --password-stdin
  else
    printf '%s' "$password" | docker login -u "$username" --password-stdin
  fi
fi

inputOptions="--rm ${INPUT_OPTIONS-}"

# shellcheck disable=SC2086
exec docker run --rm \
    ${inputOptions} \
    "$INPUT_IMAGE" \
    sh -c "$INPUT_COMMAND"
