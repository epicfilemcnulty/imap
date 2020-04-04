#!/bin/sh

apk add --no-cache alpine-sdk autoconf automake openldap-dev bzip2-dev expat-dev lua-dev heimdal-dev libcap-dev openssl-dev libtool linux-headers postgresql-dev sqlite-dev zlib-dev libsodium-dev

mkdir -p /home/builder 
adduser -D builder abuild
addgroup builder abuild
echo "builder    ALL=(ALL) ALL" >> /etc/sudoers
chown -R builder /home/builder
mkdir -p /var/cache/distfiles
chmod a+w /var/cache/distfiles
 
cat <<EOF > /etc/abuild.conf
CHOST=x86_64-alpine-linux-musl
export CFLAGS="-Os -fomit-frame-pointer"
export CXXFLAGS="\$CFLAGS"
export CPPFLAGS="\$CFLAGS"
export LDFLAGS="-Wl,--as-needed"
export JOBS=2
export MAKEFLAGS=-j\$JOBS

USE_COLORS=1
SRCDEST=/var/cache/distfiles

REPODEST=/home/builder/built
PACKAGER="Vladimir Zorin <vladimir@deviant.guru>"

CLEANUP="srcdir pkgdir deps"
ERROR_CLEANUP="deps"
EOF

