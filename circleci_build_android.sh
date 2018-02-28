# for centos 6,7

cat /etc/redhat-release
#    yum install -y -q gcc gcc-c++
#    yum install -y -q epel-release
#    yum install -y -q libtool

yum install -y -q make
yum install -y -q file
yum install -y -q wget
yum install -y -q zip

# aws config
yum install -y -q git
git submodule update --init build_tools
bash -e -x build_tools/setup_awscli_linux.sh centos7

# set up artifacts dir
BASENAME=libuv_android_${CIRCLE_SHA1}
mkdir /artifacts
mkdir /artifacts/${BASENAME}
cp -r include /artifacts/${BASENAME}/


function setup_build_ndk() {
    NDKVER=$1
    NDKBIN=${NDKVER}-linux-x86_64.bin
    wget --quiet http://dl.google.com/android/ndk/${NDKBIN}
    file ${NDKBIN}
    chmod a+x ${NDKBIN}
    ./${NDKBIN} > /dev/null
    ls

    NDK_ROOT=`pwd`/${NDKVER}
    NDK_BUILD=${NDK_ROOT}/ndk-build
    ${NDK_BUILD} NDK_APPLICATION_MK=./jni/Application.mk NDK_PROJECT_PATH=. NDK_OUT=. APP_BUILD_SCRIPT=./jni/Android.mk

    # output is in "local" dir
    OUTDIR=/artifacts/${BASENAME}/${NDKVER}
    mkdir ${OUTDIR}
    mkdir ${OUTDIR}/mips    
    mkdir ${OUTDIR}/armeabi-v7a
    mkdir ${OUTDIR}/x86
    mkdir ${OUTDIR}/armeabi

    cp local/mips/libuv.a ${OUTDIR}/mips/
    cp local/armeabi-v7a/libuv.a ${OUTDIR}/armeabi-v7a/
    cp local/x86/libuv.a ${OUTDIR}/x86/
    cp local/armeabi/libuv.a ${OUTDIR}/armeabi/
    
}


# build
NDK10VER=android-ndk-r10e
NDK12VER=android-ndk-r12b

setup_build_ndk ${NDK10VER}
setup_build_ndk ${NDK12VER}



cd /artifacts
zip -r ${BASENAME}.zip ${BASENAME}

aws s3 cp ${BASENAME}.zip s3://appveyor-tmp/libuv_bin/${BASENAME}.zip --acl public-read


