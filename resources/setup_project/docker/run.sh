#!/bin/bash
IMG_NAME="setup_project_tuto"

docker build -t $IMG_NAME $(dirname $0)

docker run -v $(git rev-parse --show-toplevel):/tuto -it $IMG_NAME bash