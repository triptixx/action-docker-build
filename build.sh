#!/bin/sh
set -e

echo "repo $INPUT_REPO"
echo "path $INPUT_PATH"
echo "dockerfile $INPUT_DOCKERFILE"
echo "use_cache $INPUT_USE_CACHE"
echo "no_labels $INPUT_NO_LABELS"
echo "build_args $INPUT_BUILD_ARGS"
echo "arguments $INPUT_ARGUMENTS"
echo "make $INPUT_MAKE"
echo "rm $INPUT_RM"
echo "squash $INPUT_SQUASH"
echo "Test $TEST"
