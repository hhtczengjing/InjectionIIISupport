#!/usr/bin/env bash
set -e

ROOT=$(git rev-parse --show-toplevel)
BASE_DIR=$(dirname "$0")

if [ -f $ROOT/.clang-format ];then
    echo "File .clang-format already exists! Will not attempt to overwrite."
else
    cp $BASE_DIR/style.clang-format $ROOT/.clang-format
fi
