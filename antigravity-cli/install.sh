#!/bin/bash

set -o errexit
set -o nounset

readonly SELF_DIR=$(cd $(dirname $0) && pwd)

cp $SELF_DIR/settings.json ~/.gemini/antigravity-cli/
