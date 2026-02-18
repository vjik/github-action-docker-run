#!/usr/bin/env sh
set -eu

username=${INPUT_USERNAME}
password=${INPUT_PASSWORD}
registry=${INPUT_REGISTRY}
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

inputOptions="--rm --entrypoint=sh ${INPUT_OPTIONS}"

IFS_SAVE="$IFS"
IFS='
'
for volume in ${INPUT_VOLUMES}; do
  [ -n "$volume" ] && inputOptions="$inputOptions -v \"$volume\""
done
for env_var in ${INPUT_ENV}; do
  [ -n "$env_var" ] && inputOptions="$inputOptions -e \"$env_var\""
done
IFS="$IFS_SAVE"

workdir=${INPUT_WORKDIR}
if [ -n "$workdir" ]; then
  inputOptions="$inputOptions -w \"$workdir\""
fi

# shellcheck disable=SC2086
eval exec docker run \
    ${inputOptions} \
    '"$INPUT_IMAGE"' \
    -c '"$INPUT_COMMAND"'
