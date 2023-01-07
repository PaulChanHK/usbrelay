#!/bin/bash -xe

# Usage:
# VER=1.1 ./create_whl.sh
# ./create_whl.sh clean

cd usbrelay_py

version="${VER:-1.0}"

sed -ri \
 -e "s/(version =).*,/\1 '$version',/" \
  setup.py

make $@

if [[ ! "$@" =~ clean ]]; then
    mv dist/usbrelay_py*.whl ../ 2>/dev/null || true
fi
