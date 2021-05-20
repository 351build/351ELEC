# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="parallel-n64"
PKG_VERSION="0a67445ce63513584d92e5c57ea87efe0da9b3bd"
PKG_SHA256="141205571de2a5c0646ee4d33d32e71d86c8f4a75e43aba73c103c62cc15affd"
PKG_REV="2"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/parallel-n64"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain $OPENGLES"
PKG_SECTION="libretro"
PKG_SHORTDESC="Optimized/rewritten Nintendo 64 emulator made specifically for Libretro. Originally based on Mupen64 Plus."
PKG_LONGDESC="Optimized/rewritten Nintendo 64 emulator made specifically for Libretro. Originally based on Mupen64 Plus."
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="-lto"

if [[ "$ARCH" == "arm" ]]; then
	PKG_MAKE_OPTS_TARGET=" platform=${PROJECT}"
	
	if [[ "${DEVICE}" =~ RG351 ]]; then
		PKG_MAKE_OPTS_TARGET=" platform=Odroidgoa"
	fi
else
	PKG_MAKE_OPTS_TARGET=" platform=emuelec64-armv8"
	
fi

pre_configure_target() {
  sed -i 's/"GFX Plugin; auto|glide64|gln64|rice/"GFX Plugin; gln64|auto|glide64|rice/g' $PKG_BUILD/libretro/libretro.c
  sed -i 's/"Resolution (restart); 320x240|640x480|960x720/"Resolution (restart); 640x480|320x240|960x720/g' $PKG_BUILD/libretro/libretro.c
  sed -i 's/"Framerate (restart); original|fullspeed"/"Framerate (restart); fullspeed|original"/g' $PKG_BUILD/libretro/libretro.c
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  if [[ "$DEVICE" =~ RG351 ]] && [[ "$ARCH" == "aarch64" ]]
  then
    cp -vP $PKG_BUILD/../../build.${DISTRO}-${DEVICE}.arm-${LIBREELEC_VERSION}/parallel-n64-*/.install_pkg/usr/lib/libretro/parallel_n64_libretro.so ${INSTALL}/usr/lib/libretro/
  else
    cp parallel_n64_libretro.so $INSTALL/usr/lib/libretro/
  fi
}
