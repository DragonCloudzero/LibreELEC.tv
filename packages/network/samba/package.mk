################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="samba"
PKG_VERSION="4.8.2"
PKG_SHA256="62e552296d49e6ab44bb87d120a288813fa52e42435d53a1f71b77596512bf22"
PKG_ARCH="any"
PKG_LICENSE="GPLv3+"
PKG_SITE="https://www.samba.org"
PKG_URL="https://download.samba.org/pub/samba/stable/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain heimdal:host e2fsprogs Python2 zlib readline popt libaio connman"
PKG_NEED_UNPACK="$(get_pkg_directory heimdal) $(get_pkg_directory e2fsprogs)"
PKG_SECTION="network"
PKG_SHORTDESC="samba: The free SMB / CIFS fileserver and client"
PKG_LONGDESC="Samba is a SMB server that runs on Unix and other operating systems. It allows these operating systems (currently Unix, Netware, OS/2 and AmigaDOS) to act as a file and print server for SMB and CIFS clients. There are many Lan-Manager compatible clients such as LanManager for DOS, Windows for Workgroups, Windows NT, Windows 95, Linux smbfs, OS/2, Pathworks and more."
PKG_BUILD_FLAGS="-gold"

PKG_MAKE_OPTS_TARGET="V=1"

if [ "$AVAHI_DAEMON" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET avahi"
  SMB_AVAHI="--enable-avahi"
else
  SMB_AVAHI="--disable-avahi"
fi

if [ "$TARGET_ARCH" = x86_64 ]; then
  SMB_AESNI="--accel-aes=intelaesni"
else
  SMB_AESNI="--accel-aes=none"
fi

PKG_CONFIGURE_OPTS="--prefix=/usr \
                    --sysconfdir=/etc \
                    --localstatedir=/var \
                    --with-lockdir=/var/lock \
                    --with-logfilebase=/var/log \
                    --with-piddir=/run/samba \
                    --with-privatedir=/run/samba \
                    --with-modulesdir=/usr/lib \
                    --with-privatelibdir=/usr/lib \
                    --with-sockets-dir=/run/samba \
                    --with-configdir=/run/samba \
                    --with-libiconv=$SYSROOT_PREFIX/usr \
                    --cross-compile \
                    --cross-answers=$PKG_BUILD/cache.txt \
                    --hostcc=gcc \
                    --enable-fhs \
                    --without-dmapi \
                    --disable-glusterfs \
                    --disable-rpath \
                    --disable-rpath-install \
                    --disable-rpath-private-install \
                    $SMB_AVAHI \
                    $SMB_AESNI \
                    --disable-cups \
                    --disable-iprint \
                    --disable-gnutls \
                    --with-relro \
                    --with-sendfile-support \
                    --without-acl-support \
                    --without-ads \
                    --without-ad-dc \
                    --without-automount \
                    --without-cluster-support \
                    --without-dnsupdate \
                    --without-fam \
                    --without-gettext \
                    --without-gpgme \
                    --without-iconv \
                    --without-ldap \
                    --without-libarchive \
                    --without-pam \
                    --without-pie \
                    --without-regedit \
                    --without-systemd \
                    --without-utmp \
                    --without-winbind \
                    --enable-auto-reconfigure \
                    --bundled-libraries='ALL,!asn1_compile,!compile_et,!zlib' \
                    --without-quotas \
                    --with-syslog  \
                    --nopyc --nopyo"

PKG_SAMBA_TARGET="smbclient,client/smbclient,smbtree,testparm"

[ "$SAMBA_SERVER" = "yes" ] && PKG_SAMBA_TARGET+=",smbd/smbd,nmbd,smbpasswd"

pre_configure_target() {
# samba uses its own build directory
  cd $PKG_BUILD
    rm -rf .$TARGET_NAME

# work around link issues
  export LDFLAGS="$LDFLAGS -lreadline"

# support 64-bit offsets and seeks on 32-bit platforms
  if [ "$TARGET_ARCH" = "arm" ]; then
    export CFLAGS+=" -D_FILE_OFFSET_BITS=64 -D_OFF_T_DEFINED_ -Doff_t=off64_t -Dlseek=lseek64"
  fi
}

configure_target() {
  cp $PKG_DIR/config/samba4-cache.txt $PKG_BUILD/cache.txt
    echo "Checking uname machine type: \"$TARGET_ARCH\"" >> $PKG_BUILD/cache.txt

  PYTHON_CONFIG="$SYSROOT_PREFIX/usr/bin/python-config" \
  python_LDFLAGS="" python_LIBDIR="" \
  ./configure $PKG_CONFIGURE_OPTS
}

make_target() {
  ./buildtools/bin/waf build --targets=$PKG_SAMBA_TARGET -j$CONCURRENCY_MAKE_LEVEL
}

makeinstall_target() {
  ./buildtools/bin/waf install --destdir=$SYSROOT_PREFIX --targets=smbclient -j$CONCURRENCY_MAKE_LEVEL
  ./buildtools/bin/waf install --destdir=$INSTALL --targets=$PKG_SAMBA_TARGET -j$CONCURRENCY_MAKE_LEVEL
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  rm -rf $INSTALL/usr/lib/python*
  rm -rf $INSTALL/usr/share/perl*
  rm -rf $INSTALL/usr/lib64

  mkdir -p $INSTALL/usr/lib/samba
    cp $PKG_DIR/scripts/samba-config $INSTALL/usr/lib/samba
    cp $PKG_DIR/scripts/smbd-config $INSTALL/usr/lib/samba
    cp $PKG_DIR/scripts/samba-autoshare $INSTALL/usr/lib/samba

  if find_file_path config/smb.conf; then
    mkdir -p $INSTALL/etc/samba
      cp ${FOUND_PATH} $INSTALL/etc/samba
    mkdir -p $INSTALL/usr/config
      cp $INSTALL/etc/samba/smb.conf $INSTALL/usr/config/samba.conf.sample
  fi

  mkdir -p $INSTALL/usr/bin
    cp -PR bin/default/source3/client/smbclient $INSTALL/usr/bin
    cp -PR bin/default/source3/utils/smbtree $INSTALL/usr/bin
    cp -PR bin/default/source3/utils/testparm $INSTALL/usr/bin

  if [ "$SAMBA_SERVER" = "yes" ]; then
    mkdir -p $INSTALL/usr/bin
      cp -PR bin/default/source3/utils/smbpasswd $INSTALL/usr/bin

    mkdir -p $INSTALL/usr/lib/systemd/system
      cp $PKG_DIR/system.d.opt/* $INSTALL/usr/lib/systemd/system

    mkdir -p $INSTALL/usr/share/services
      cp -P $PKG_DIR/default.d/*.conf $INSTALL/usr/share/services
  fi
}

post_install() {
  enable_service samba-config.service

  if [ "$SAMBA_SERVER" = "yes" ]; then
    enable_service nmbd.service
    enable_service smbd.service
  fi
}
