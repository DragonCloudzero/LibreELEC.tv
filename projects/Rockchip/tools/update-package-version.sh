#!/bin/bash

SCRIPTPATH=$(dirname $0)

function update_pkg_version {
  PKG_NAME=$1
  PKG_REPO=$2
  PKG_BRANCH=$3

  PKG_PATH=$(find $SCRIPTPATH/../packages/ -name $PKG_NAME -type d -print)/package.mk
  if [ ! -f $PKG_PATH ]; then
    PKG_PATH=$(find $SCRIPTPATH/../../../packages/ -name $PKG_NAME -type d -print)/package.mk
  fi

  if [ ! -f $PKG_PATH ]; then
    echo "ERROR: PKG_PATH does not exists"
    exit 1
  fi

  echo "$PKG_NAME ($PKG_BRANCH @ $PKG_REPO)"

  if [ "$PKG_NAME" = "linux" ]; then
    eval $(grep "^  rockchip-4.4)" $PKG_PATH -A1 | grep PKG_VERSION)
    eval $(grep "^  rockchip-4.4)" $PKG_PATH -A2 | grep PKG_SHA256)
  else
    eval $(grep "^PKG_VERSION" $PKG_PATH)
    eval $(grep "^PKG_SHA256" $PKG_PATH)
  fi

  if [ -z "$PKG_VERSION" ]; then
    echo "ERROR: PKG_VERSION is empty"
    exit 1
  fi

  echo " PKG_VERSION=$PKG_VERSION"
  echo " PKG_SHA256=$PKG_SHA256"

  if [ "$PKG_NAME" = "linux" ]; then
    GIT_REV=$(git ls-remote --heads $PKG_REPO $PKG_BRANCH | cut -c1-40)
  else
    GIT_REV=$(git ls-remote --heads $PKG_REPO $PKG_BRANCH | cut -c1-7)
  fi

  if [ -z "$GIT_REV" ]; then
    echo "ERROR: GIT_REV is empty"
    exit 1
  fi

  echo " GIT_REV=$GIT_REV"

  if [ "$PKG_VERSION" != "$GIT_REV" ]; then
    echo "Updating package.mk"
    sed -i "s/PKG_VERSION=\"$PKG_VERSION\"/PKG_VERSION=\"$GIT_REV\"/" $PKG_PATH
    sed -i "s/PKG_SHA256=\"$PKG_SHA256\"/PKG_SHA256=\"\"/" $PKG_PATH
  fi

  echo
}

update_pkg_version linux https://github.com/rockchip-linux/kernel.git release-4.4
update_pkg_version rkbin https://github.com/rockchip-linux/rkbin.git master
update_pkg_version rkmpp https://github.com/rockchip-linux/mpp.git release
update_pkg_version mali-rockchip https://github.com/rockchip-linux/libmali.git rockchip
update_pkg_version kodi https://github.com/xbmc/xbmc.git master
