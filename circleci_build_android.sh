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

NDKVER=android-ndk-r10e
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

BASENAME=libuv_android_${CIRCLE_SHA1}

mkdir /artifacts
mkdir /artifacts/${BASENAME}


cp -r include /artifacts/${BASENAME}/
mkdir /artifacts/${BASENAME}/mips
cp local/mips/libuv.a /artifacts/${BASENAME}/mips/
mkdir /artifacts/${BASENAME}/armeabi-v7a
cp local/armeabi-v7a/libuv.a /artifacts/${BASENAME}/armeabi-v7a/
mkdir /artifacts/${BASENAME}/x86
cp local/x86/libuv.a /artifacts/${BASENAME}/x86/
mkdir /artifacts/${BASENAME}/armeabi
cp local/armeabi/libuv.a /artifacts/${BASENAME}/armeabi/

cd /artifacts
zip -r ${BASENAME}.zip ${BASENAME}

aws s3 cp ${BASENAME}.zip s3://appveyor-tmp/libuv_bin/${BASENAME}.zip --acl public-read


