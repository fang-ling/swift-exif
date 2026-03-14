#!/bin/zsh

##
##  update-libexif.zsh
##  swift-exif
##
##  Created by Fang Ling on 2026/3/14.
##
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##
##    http://www.apache.org/licenses/LICENSE-2.0
##
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.
##

# This script creates a copy of libexif that is suitable for building with the
# Swift Package Manager.
#
# Usage:
#   Run this script in the package root. It will place a local copy of the
#   libexif sources in Sources/CEXIF.
#   Any prior contents of Sources/CEXIF will be deleted.
#

set -euo pipefail

CURRENT_WORKING_DIRECTORY=$(pwd)
TEMPORARY_DIRECTORY=$(mktemp -d /tmp/swift-exif-XXXXXX)
SOURCE_DIRECTORY="${TEMPORARY_DIRECTORY}/Sources/libexif"
DESTINATION_DIRECTORY="Sources/CEXIF"
TRASH_DIRECTORY="${TEMPORARY_DIRECTORY}/Trash"
SOURCES=(
  "*.c"
  "*.h"
  "apple/*.c"
  "apple/*.h"
  "canon/*.c"
  "canon/*.h"
  "fuji/*.c"
  "fuji/*.h"
  "olympus/*.c"
  "olympus/*.h"
  "pentax/*.c"
  "pentax/*.h"
)
PUBLIC_HEADERS=(
  "exif-*.h"
)
PRIVATE_HEADERS=(
  "exif-gps-ifd.h"
  "exif-mnote-data-priv.h"
  "exif-system.h"
)

# Libexif revision must be passed as the first argument to this script.
if [ "$#" -gt 0 ]; then
  LIBEXIF_REVISION="$1"
else
  echo "Usage: $0 <libexif-revision>"
  exit 1
fi

echo "==========================================="
echo "TRASHING any previously-copied libexif code"
echo "==========================================="
mkdir -p "${TRASH_DIRECTORY}/CEXIF"
mv "${DESTINATION_DIRECTORY}/"* "${TRASH_DIRECTORY}/CEXIF" || true

echo "================="
echo "PREPARING libexif"
echo "================="
mkdir -p "${SOURCE_DIRECTORY}"
git clone https://github.com/libexif/libexif.git "${SOURCE_DIRECTORY}"
cd "${SOURCE_DIRECTORY}"
git checkout "${LIBEXIF_REVISION}"
cd "${CURRENT_WORKING_DIRECTORY}"

echo "==============="
echo "COPYING libexif"
echo "==============="
mkdir -p "${DESTINATION_DIRECTORY}/libexif"
for SOURCE in "${SOURCES[@]}"
do
  for FILE in "${SOURCE_DIRECTORY}/libexif/"${~SOURCE}
  do
    FILE_PATH=${FILE#"$SOURCE_DIRECTORY"}
    DESTINATION="${DESTINATION_DIRECTORY}/libexif${FILE_PATH}"
    mkdir -p $(dirname "${DESTINATION}")

    cp "${FILE}" "${DESTINATION}"
  done
done
mkdir -p "${DESTINATION_DIRECTORY}/include/libexif"
for PUBLIC_HEADER in "${PUBLIC_HEADERS[@]}"
do
  mv \
    "${DESTINATION_DIRECTORY}/libexif/libexif/"${~PUBLIC_HEADER} \
    "${DESTINATION_DIRECTORY}/include/libexif"
done
for PRIVATE_HEADER in "${PRIVATE_HEADERS[@]}"
do
  mv \
    "${DESTINATION_DIRECTORY}/include/libexif/${~PRIVATE_HEADER}" \
    "${DESTINATION_DIRECTORY}/libexif/libexif"

done
cp "${SOURCE_DIRECTORY}/COPYING" "${DESTINATION_DIRECTORY}/LICENSE.txt"

echo "======================="
echo "WRITING generated files"
echo "======================="
cat << EOF > "${DESTINATION_DIRECTORY}/libexif/config.h"
/* config.h.  Generated from config.h.in by configure.  */
/* config.h.in.  Generated from configure.ac by autoheader.  */

/* Define to 1 if translation of program messages to the user's native
   language is requested. */
/* #undef ENABLE_NLS */

/* Define to 1 if you have the Mac OS X function CFLocaleCopyCurrent in the
   CoreFoundation framework. */
#define HAVE_CFLOCALECOPYCURRENT 1

/* Define to 1 if you have the Mac OS X function CFPreferencesCopyAppValue in
   the CoreFoundation framework. */
#define HAVE_CFPREFERENCESCOPYAPPVALUE 1

/* Define if the GNU dcgettext() function is already present or preinstalled.
   */
/* #undef HAVE_DCGETTEXT */

/* Define to 1 if you have the <dlfcn.h> header file. */
#define HAVE_DLFCN_H 1

/* Define if the GNU gettext() function is already present or preinstalled. */
/* #undef HAVE_GETTEXT */

/* Define if you have the iconv() function and it works. */
#define HAVE_ICONV 1

/* Define to 1 if you have the <inttypes.h> header file. */
#define HAVE_INTTYPES_H 1

/* Define to 1 if you have the 'localtime_r' function. */
#define HAVE_LOCALTIME_R 1

/* Define to 1 if you have localtime_s() */
/* #undef HAVE_LOCALTIME_S */

/* Define to 1 if you have the <stdint.h> header file. */
#define HAVE_STDINT_H 1

/* Define to 1 if you have the <stdio.h> header file. */
#define HAVE_STDIO_H 1

/* Define to 1 if you have the <stdlib.h> header file. */
#define HAVE_STDLIB_H 1

/* Define to 1 if you have the <strings.h> header file. */
#define HAVE_STRINGS_H 1

/* Define to 1 if you have the <string.h> header file. */
#define HAVE_STRING_H 1

/* Define to 1 if you have the <sys/stat.h> header file. */
#define HAVE_SYS_STAT_H 1

/* Define to 1 if you have the <sys/types.h> header file. */
#define HAVE_SYS_TYPES_H 1

/* Define to 1 if you have the <unistd.h> header file. */
#define HAVE_UNISTD_H 1

/* Define as const if the declaration of iconv() needs const. */
#define ICONV_CONST

/* Define to the sub-directory where libtool stores uninstalled libraries. */
#define LT_OBJDIR ".libs/"

/* Name of package */
#define PACKAGE "libexif"

/* Define to the address where bug reports for this package should be sent. */
#define PACKAGE_BUGREPORT "libexif-devel@lists.sourceforge.net"

/* Define to the full name of this package. */
#define PACKAGE_NAME "EXIF library"

/* Define to the full name and version of this package. */
#define PACKAGE_STRING "EXIF library 0.6.25"

/* Define to the one symbol short name of this package. */
#define PACKAGE_TARNAME "libexif"

/* Define to the home page for this package. */
#define PACKAGE_URL "https://libexif.github.io/"

/* Define to the version of this package. */
#define PACKAGE_VERSION "0.6.25"

/* Define to 1 if all of the C89 standard headers exist (not just the ones
   required in a freestanding environment). This macro is provided for
   backward compatibility; new code need not use it. */
#define STDC_HEADERS 1

/* Version number of package */
#define VERSION "0.6.25"

/* Number of bits in a file offset, on hosts where this is settable. */
/* #undef _FILE_OFFSET_BITS */

/* Define to 1 on platforms where this makes off_t a 64-bit type. */
/* #undef _LARGE_FILES */

/* Number of bits in time_t, on hosts where this is settable. */
/* #undef _TIME_BITS */

/* Define to 1 on platforms where this makes time_t a 64-bit type. */
/* #undef __MINGW_USE_VC2005_COMPAT */

/* Define to '__inline__' or '__inline' if that's what the C compiler
   calls it, or to nothing if 'inline' is not supported under any name.  */
#ifndef __cplusplus
/* #undef inline */
#endif
EOF
cat << EOF > "${DESTINATION_DIRECTORY}/include/libexif/_stdint.h"
/* This file is generated automatically by configure */
#include <stdint.h>
EOF

echo "=========================="
echo "RECORDING libexif revision"
echo "=========================="
cat << EOF > "${DESTINATION_DIRECTORY}/revision.txt"
This directory is derived from libexif
  cloned from https://github.com/libexif/libexif.git
EOF
echo \
  "at revision ${LIBEXIF_REVISION}" >> "${DESTINATION_DIRECTORY}/revision.txt"

echo "============================"
echo "CLEANING temporary directory"
echo "============================"
rm -rf "${TEMPORARY_DIRECTORY}"
