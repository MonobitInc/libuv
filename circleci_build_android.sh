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

ls -la





