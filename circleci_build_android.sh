# for centos 6,7

cat /etc/redhat-release
#    yum install -y -q gcc gcc-c++
#    yum install -y -q epel-release
#    yum install -y -q libtool

yum install -y -q make
yum install -y -q file
yum install -y -q wget
yum install -y -q zip
yum install -y -q unzip
yum install -y -q which # for android r12b ndk-build internal


# aws config
yum install -y -q git
git submodule update --init build_tools
bash -e -x build_tools/setup_awscli_linux.sh centos7

NDK14VER=r14b
#NDK12VER=r12b
#NDK10VER=r10e

bash -e -x build_tools/setup_ndk.sh ${NDK14VER}
#bash -e -x build_tools/setup_ndk.sh ${NDK12VER}
#bash -e -x build_tools/setup_ndk.sh ${NDK10VER}



# set up artifacts dir
BASENAME=libuv_android_${CIRCLE_SHA1}
mkdir /artifacts
mkdir /artifacts/${BASENAME}
cp -r include /artifacts/${BASENAME}/


function build_ndk() {
    NDKVER=$1

    NDK_ROOT=`pwd`/android-ndk-${NDKVER}
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

    rm -rf local
}

# build

build_ndk ${NDK14VER}
#build_ndk ${NDK12VER}
#build_ndk ${NDK10VER}



cd /artifacts
zip -r ${BASENAME}.zip ${BASENAME}

aws s3 cp ${BASENAME}.zip s3://monobit-engine-public/libuv_bin/${BASENAME}.zip --acl public-read



