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

PKG_NAME="arm-trusted-firmware"
PKG_VERSION="ac4626d"
PKG_SHA256=""
PKG_ARCH="arm aarch64"
PKG_LICENSE="BSD"
PKG_SITE="https://github.com/ARM-software/arm-trusted-firmware"
PKG_URL="https://github.com/ARM-software/arm-trusted-firmware/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="arm-trusted-firmware-$PKG_VERSION*"
PKG_SECTION="firmware"
PKG_SHORTDESC="arm-trusted-firmware: ARM Trusted Firmware provides a reference implementation of secure world software for ARMv8-A."
PKG_LONGDESC="ARM Trusted Firmware provides a reference implementation of secure world software for ARMv8-A, including a [Secure Monitor] TEE-SMC executing at Exception Level 3 (EL3)."
PKG_IS_KERNEL_PKG="yes"
PKG_TOOLCHAIN="manual"

if [ "$UBOOT_SYSTEM" = "rk3399" ]; then
  PKG_DEPENDS_TARGET="gcc-linaro-arm-eabi:host"
fi

pre_configure_target() {
  if [ -z "$UBOOT_SYSTEM" ]; then
    echo "Please add UBOOT_SYSTEM to your project or device options file, aborting."
    exit 1
  fi
}

make_target() {
  if [ "$UBOOT_SYSTEM" = "rk3399" ]; then
    export PATH=$TOOLCHAIN/lib/gcc-linaro-arm-eabi/bin:$PATH
    export M0_CROSS_COMPILE="arm-eabi-"
  fi

  CROSS_COMPILE="$TARGET_PREFIX" CFLAGS="" LDFLAGS="" make realclean
  CROSS_COMPILE="$TARGET_PREFIX" CFLAGS="" LDFLAGS="" make HOSTCC="$HOST_CC" BUILD_STRING="$PKG_VERSION" DEBUG=1 ERRATA_A53_835769=1 ERRATA_A53_843419=0 ERRATA_A53_855873=1 PLAT=$UBOOT_SYSTEM bl31

  cp -av build/$UBOOT_SYSTEM/debug/bl31/bl31.elf bl31.elf
}
