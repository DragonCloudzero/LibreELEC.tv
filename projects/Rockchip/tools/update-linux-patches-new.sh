#!/bin/sh

SCRIPTPATH=$(dirname $0)
PKG_NAME=linux
eval $(grep "^  rockchip-4.4)" $SCRIPTPATH/../../../packages/$PKG_NAME/package.mk -A2 | grep PKG_VERSION)
PKG_BASE=$PKG_VERSION
PKG_BASE="release-4.4"

if [ ! -d .git ]; then
  echo "ERROR: current path is not a git repository"
  exit 1
fi

git format-patch $PKG_BASE..rockchip-4.4 --no-signature --no-numbered --stdout > $SCRIPTPATH/../patches/$PKG_NAME/rockchip-4.4/${PKG_NAME}-0001-rockchip.patch
git format-patch $PKG_BASE..rockchip-4.4-ir --no-signature --no-numbered --stdout > $SCRIPTPATH/../patches/$PKG_NAME/rockchip-4.4/${PKG_NAME}-0002-ir.patch
git format-patch $PKG_BASE..rockchip-4.4-cec --no-signature --no-numbered --stdout > $SCRIPTPATH/../patches/$PKG_NAME/rockchip-4.4/${PKG_NAME}-0003-cec.patch
git format-patch $PKG_BASE..rockchip-4.4-audio --no-signature --no-numbered --stdout > $SCRIPTPATH/../patches/$PKG_NAME/rockchip-4.4/${PKG_NAME}-0004-audio.patch
git format-patch $PKG_BASE..rockchip-4.4-dts --no-signature --no-numbered --stdout > $SCRIPTPATH/../patches/$PKG_NAME/rockchip-4.4/${PKG_NAME}-0005-dts.patch
git format-patch $PKG_BASE..rockchip-4.4-rtl8211f --no-signature --no-numbered --stdout > $SCRIPTPATH/../patches/$PKG_NAME/rockchip-4.4/${PKG_NAME}-0006-rtl8211f.patch
git format-patch $PKG_BASE..rockchip-4.4-dtoverlay-configfs --no-signature --no-numbered --stdout > $SCRIPTPATH/../patches/$PKG_NAME/rockchip-4.4/${PKG_NAME}-0007-dtoverlay-configfs.patch
git format-patch $PKG_BASE..rockchip-4.4-mmc-pwrseq --no-signature --no-numbered --stdout > $SCRIPTPATH/../patches/$PKG_NAME/rockchip-4.4/${PKG_NAME}-0008-mmc-pwrseq.patch
git format-patch $PKG_BASE..rockchip-4.4-tinker --no-signature --no-numbered --stdout > $SCRIPTPATH/../devices/TinkerBoard/patches/$PKG_NAME/rockchip-4.4/${PKG_NAME}-0001-miniarm.patch
git format-patch $PKG_BASE..rockchip-4.4-legacy --no-signature --no-numbered --stdout > $SCRIPTPATH/../patches/$PKG_NAME/rockchip-4.4/${PKG_NAME}-1000-legacy.patch
git format-patch $PKG_BASE..rockchip-4.4-pl330 --no-signature --no-numbered --stdout > $SCRIPTPATH/../patches/$PKG_NAME/rockchip-4.4/${PKG_NAME}-1000-pl330.patch
