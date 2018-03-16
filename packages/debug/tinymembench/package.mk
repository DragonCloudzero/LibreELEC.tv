################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2017-present Team LibreELEC
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="tinymembench"
PKG_VERSION="a2cf6d7"
PKG_SHA256="e9553d6e273c24ff62d9a63f06c4d68ad697f22e35d25102c3740f96e1d25d32"
PKG_ARCH="any"
PKG_LICENSE="free"
PKG_SITE="https://github.com/ssvb/tinymembench"
PKG_URL="https://github.com/ssvb/tinymembench/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="tinymembench-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="debug"

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
    cp -v tinymembench $INSTALL/usr/bin
}
