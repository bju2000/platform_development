#!/bin/bash

# Copyright (C) 2021 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if [ -z ${ANDROID_BUILD_TOP} ]; then
    WD=$(pwd)
else
    WD=$ANDROID_BUILD_TOP
fi
echo "use build top: $WD"

function linkto()
{
    local src=$1
    local dst=$2
    rm -f $dst
    echo \
    ln -s $src $dst
    ln -s $src $dst
}

function setup_dir()
{
    linkto $WD/prebuilts                    $WD/kernel/prebuilts-master
    linkto $WD/prebuilts/gas                $WD/kernel/prebuilts/gas
    linkto $WD/prebuilts/clang              $WD/kernel/prebuilts/clang
    linkto $WD/prebuilts/gcc                $WD/kernel/prebuilts/gcc
    linkto $WD/prebuilts/build-tools        $WD/kernel/prebuilts/build-tools
    linkto $WD/prebuilts/kernel-build-tools $WD/kernel/prebuilts/kernel-build-tools
    linkto $WD/out $WD/kernel/out
    for d in $WD/kernel/common*; do
        echo pushd $d
        pushd $d
        echo \
        find . -name "Android.mk" -exec mv {} {}.back \;
        find . -name "Android.mk" -exec mv {} {}.back \;
        popd
    done
}

function bld_mainline()
{
    local make_opt=$1
    pushd $WD/kernel
    HERMETIC_TOOLCHAIN=0 BUILD_CONFIG=common/build.config.gki.aarch64 build/build.sh ${make_opt}
    popd
}

function bld_k54()
{
    local make_opt=$1
    pushd $WD/kernel
    HERMETIC_TOOLCHAIN=0 BUILD_CONFIG=common-5.4/build.config.gki.aarch64 build/build.sh ${make_opt}
    popd
}

function bld_k510()
{
    local make_opt=$1
    pushd $WD/kernel
    HERMETIC_TOOLCHAIN=0 BUILD_CONFIG=common-5.10/build.config.gki.aarch64 build/build.sh ${make_opt}
    popd
}
