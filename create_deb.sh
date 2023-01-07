#!/bin/bash -xe

# Usage:
# VER=1.1 ./create_deb.sh
# ./create_deb.sh clean

setup_py=usbrelay_py/setup.py

version="${VER:-1.0}"
author=$(cat $setup_py | sed -rn 's/.*author = "(.*?)".*/\1/p')
description=$(cat $setup_py | sed -rn "s/.*description = '(.*?)'.*/\1/p" | sed 's/ from Python//')

sed -ri "s/(USBLIBVER =).*/\1 $version/" LIBVER.in

if [[ ! "$@" =~ clean ]]; then

  mkdir -p deb/usr/{bin,lib} deb/DEBIAN deb/lib/udev/rules.d

  cat >deb/DEBIAN/control<<EOM
Package: usbrelay
Version: $version
Section: custom
Priority: optional
Architecture: all
Essential: no
Installed-Size: $(du -s deb/usr/ | awk '{print $1}')
Maintainer: $author
Description: $description
EOM

  make $@

  cp usbrelay deb/usr/bin/
  cp libusbrelay.so* deb/usr/lib/
  cp 50-usbrelay.rules deb/lib/udev/rules.d/92-usbrelay.rules

  dpkg-deb --build deb
  dpkg-name -o deb.deb

else

  make $@
  rm -fr deb

fi

