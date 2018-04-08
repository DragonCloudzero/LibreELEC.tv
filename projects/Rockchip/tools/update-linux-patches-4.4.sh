#!/bin/sh

SCRIPTPATH=$(dirname $0)
PKG_NAME=linux
eval $(grep "^  rockchip-4.4)" $SCRIPTPATH/../../../packages/$PKG_NAME/package.mk -A2 | grep PKG_VERSION)
PKG_BASE=$PKG_VERSION
PKG_BASE=28018092

if [ ! -d .git ]; then
  echo "ERROR: current path is not a git repository"
  exit 1
fi

git format-patch $PKG_BASE..rockchip-4.4-backup --no-signature --no-numbered --stdout > $SCRIPTPATH/../patches/$PKG_NAME/rockchip-4.4/${PKG_NAME}-0001-rockchip.patch
git format-patch rockchip-4.4-backup..rockchip-4.4-ir-backup --no-signature --no-numbered --stdout > $SCRIPTPATH/../patches/$PKG_NAME/rockchip-4.4/${PKG_NAME}-0002-ir.patch
git format-patch rockchip-4.4-backup..rockchip-4.4-cec-backup --no-signature --no-numbered --stdout > $SCRIPTPATH/../patches/$PKG_NAME/rockchip-4.4/${PKG_NAME}-0003-cec.patch
git format-patch rockchip-4.4-backup..rockchip-4.4-audio-backup --no-signature --no-numbered --stdout > $SCRIPTPATH/../patches/$PKG_NAME/rockchip-4.4/${PKG_NAME}-0004-audio.patch
git format-patch rockchip-4.4-backup..rockchip-4.4-legacy-backup --no-signature --no-numbered --stdout > $SCRIPTPATH/../patches/$PKG_NAME/rockchip-4.4/${PKG_NAME}-0005-legacy.patch
git format-patch rockchip-4.4-backup..rockchip-4.4-tinker-backup --no-signature --no-numbered --stdout > $SCRIPTPATH/../devices/TinkerBoard/patches/$PKG_NAME/rockchip-4.4/${PKG_NAME}-0001-miniarm.patch
#git format-patch rockchip-4.4-backup..rockchip-4.4-rock64-backup --no-signature --no-numbered --stdout > $SCRIPTPATH/../devices/ROCK64/patches/$PKG_NAME/rockchip-4.4/${PKG_NAME}-0001-rock64.patch

git format-patch $PKG_BASE..rockchip-4.4-pl330-backup --no-signature --no-numbered --stdout > $SCRIPTPATH/../patches/$PKG_NAME/rockchip-4.4/${PKG_NAME}-1000-pl330.patch
#git diff rockchip-4.4..rockchip-4.4-lsk > $SCRIPTPATH/../patches/$PKG_NAME/rockchip-4.4/${PKG_NAME}-1000-lsk.patch
