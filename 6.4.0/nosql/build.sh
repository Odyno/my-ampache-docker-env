#!/usr/bin/env bash

# This script is used to build an Ampache Docker image with customizable version, variant, and platforms.

set -eo pipefail

# Default values
default_version=$(basename "$(dirname "$(dirname "$(realpath "$0")")")")
default_variant=$(basename "$(dirname "$(realpath "$0")")")
default_platform="linux/amd64"

# Parameters
version=${1:-$default_version}  # The version of Ampache to build. If not provided, the default version will be used.
variant=${2:-$default_variant}  # The variant of Ampache to build. If not provided, the default variant will be used.
platforms=${3:-$default_platform}  # The platforms to build the image for. If not provided, the default platform will be used.

# Build
echo Build ampache:${version}-${variant}  platform $platforms
docker buildx build --platform $platforms -t odyno/ampache:${version}-${variant} .
