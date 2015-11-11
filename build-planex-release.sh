#!/usr/bin/env bash

set -xe

build_release() {
   DIST_NAME=$1
   DIST_VERSION=$2
   RELEASE_TYPE=$3

   sed -e "s/@RELEASE_TYPE@/${RELEASE_TYPE}/g" SPECS/planex-release.spec.in > SPECS/planex-${RELEASE_TYPE}.spec
   sed -e "s/@DIST@/${DIST_NAME}/g" -e "s/@RELEASE_TYPE@/${RELEASE_TYPE}/g" SOURCES/planex.repo.in > SOURCES/planex-${RELEASE_TYPE}.repo
   rpmbuild --define "_topdir ${PWD}" --define "version ${DIST_VERSION}" --define "dist_name ${DIST_NAME}" --bb SPECS/planex-${RELEASE_TYPE}.spec
   mkdir -p ${RELEASE_TYPE}/rpm/${DIST_NAME}/${DIST_VERSION}
   mv RPMS/noarch/planex-${RELEASE_TYPE}-${DIST_VERSION}-1.noarch.rpm ${RELEASE_TYPE}/rpm/${DIST_NAME}
   createrepo ${RELEASE_TYPE}/rpm/$DIST_NAME/${DIST_VERSION}
}

build_release fedora 21 release
build_release fedora 22 release
build_release fedora 23 release

build_release el 6 release
build_release el 7 release

build_release fedora 21 unstable
build_release fedora 22 unstable
build_release fedora 23 unstable

build_release el 6 unstable
build_release el 7 unstable

