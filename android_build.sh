set -xeu

function build_ndk() {
    NDKVER=$1

    NDK_ROOT=../android-ndk-${NDKVER}
    NDK_BUILD=${NDK_ROOT}/ndk-build
    ${NDK_BUILD} NDK_APPLICATION_MK=./jni/Application.mk NDK_PROJECT_PATH=. NDK_OUT=. APP_BUILD_SCRIPT=./jni/Android.mk

    # output is in "local" dir
    DATESTR=`date "+%Y%m%d%H%M"`
    OUTDIR=libuv-android-${NDKVER}-${DATESTR}
    mkdir ${OUTDIR}
    mkdir ${OUTDIR}/mips    
    mkdir ${OUTDIR}/armeabi-v7a
    mkdir ${OUTDIR}/arm64-v8a    
    mkdir ${OUTDIR}/x86
    mkdir ${OUTDIR}/x86_64
    mkdir ${OUTDIR}/armeabi

    cp local/mips/libuv.a ${OUTDIR}/mips/
    cp local/armeabi-v7a/libuv.a ${OUTDIR}/armeabi-v7a/
    cp local/arm64-v8a/libuv.a ${OUTDIR}/arm64-v8a/    
    cp local/x86/libuv.a ${OUTDIR}/x86/
    cp local/x86_64/libuv.a ${OUTDIR}/x86_64/    
    cp local/armeabi/libuv.a ${OUTDIR}/armeabi/
    cp -r include ${OUTDIR}/
    
    zip -r ${OUTDIR}.zip ${OUTDIR}
    aws s3 cp ${OUTDIR}.zip s3://monobit/libuv/${OUTDIR}.zip
}

build_ndk r14b


