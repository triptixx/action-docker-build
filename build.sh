#!/bin/sh
set -eo pipefail

echo "$test"

# ANSI colour escape sequences
RED='\033[0;31m'
RESET='\033[0m'
error() { >&2 echo -e "${RED}Error: $@${RESET}"; exit 1; }

# $INPUT_REPO          tag to this repo/repo to push to
# $INPUT_PATH          override working directory
# $INPUT_DOCKERFILE    override Dockerfile location
# $INPUT_BUILD_ARGS    comma/space separated build arguments
# $INPUT_USE_CACHE     override to disable --no-cache
# $INPUT_NO_LABELS     disable automatic image labelling
# $INPUT_ARGUMENTS     optional extra arguments to pass to `docker build`
# $INPUT_RM            a flag to immediately `docker rm` the built image
# $INPUT_SQUASH        builds with --squash
# $INPUT_MAKE          provides makeflags concurrent of nproc

if [ -z "$INPUT_REPO" ]; then
  if [ -n "$INPUT_RM" ]; then
    INPUT_REPO="$GITHUB_REPOSITORY"
  else
    error "Missing 'repo' argument required for building"
  fi
fi

# Always specify pull so images are pulled, and intermediate containers removed
ARGS="--pull\0--force-rm"

# Override Dockerfile if specified
[ -n "$INPUT_DOCKERFILE" ] && ARGS="$ARGS\0--file=$INPUT_DOCKERFILE"

# Squash image if requested
[ -n "$INPUT_SQUASH" ] && ARGS="$ARGS\0--squash"

# Specify MAKEFLAGS job concurrency flag
[ -n "$INPUT_MAKE" ] && ARGS="$ARGS\0--build-arg\0MAKEFLAGS=-j$(nproc)"

# Specify --no-cache unless caching is requested
[ -z "$INPUT_USE_CACHE" ] && ARGS="$ARGS\0--no-cache"

while read -r arg; do
  # If arg is '%file: <filename>' then .parse and read file
  if echo "$arg" | grep -q "%file\\s*:\\s*"; then
    arg="${arg%%=*}=$(cat "$(echo ${arg#*:} | xargs)")"
  fi
  if [ -n "${arg// }" ]; then
    # Only add arguments if they're not empty
    # this prevents the '"docker build" requires exactly 1 argument.' error
    ARGS="$ARGS\0--build-arg\0${arg}"
  fi
done << EOA
$(echo "$INPUT_BUILD_ARGS" | tr ',' '\n')
EOA

export BUILD_DATE="$(date -d "$(jq --raw-output .head_commit.timestamp "$GITHUB_EVENT_PATH")" +"%Y-%m-%dT%H:%M:%SZ")"
export VCS_REF="$GITHUB_SHA"
export VCS_URL="$(jq --raw-output .repository.url "$GITHUB_EVENT_PATH")"
export VENDOR="$GITHUB_ACTOR"

ARGS="$ARGS\0--build-arg\0BUILD_DATE=$BUILD_DATE"
ARGS="$ARGS\0--build-arg\0VCS_REF=$VCS_REF"
ARGS="$ARGS\0--build-arg\0VCS_URL=$VCS_URL"
ARGS="$ARGS\0--build-arg\0VENDOR=$VENDOR"

if [ -z "$INPUT_NO_LABELS" ]; then
  ARGS="$ARGS\0--label\0org.label-schema.build-date=$BUILD_DATE"
  ARGS="$ARGS\0--label\0org.label-schema.vcs-ref=${VCS_REF:0:7}"
  ARGS="$ARGS\0--label\0org.label-schema.vcs-url=$VCS_URL"
  ARGS="$ARGS\0--label\0org.label-schema.vendor=$VENDOR"
  ARGS="$ARGS\0--label\0org.label-schema.schema-version=1.0"
fi

>&2 echo "+ docker build ${ARGS//\\0/ } $INPUT_ARGUMENTS --tag=$INPUT_REPO ${INPUT_PATH:-.}"

# Un-escape the NULL characters to fix arguments with spaces in
printf "$ARGS${INPUT_ARGUMENTS//,/\0}\0--tag=${INPUT_REPO}\0${INPUT_PATH:-.}" | xargs -0 docker build

if [ -n "$INPUT_RM" ]; then
  docker image rm "$INPUT_REPO"
fi
