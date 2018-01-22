# for centos 6,7

echo platform name: $1
echo SHA1: ${CIRCLE_SHA1}

ARCH=$1

uname -a

if [[ "$1" == "macos" ]]; then
    MACVER=`sw_vers -productVersion`
    ARCH=${1}_${MACVER}
    echo ${MACVER}   
else

    cat /etc/redhat-release
    yum install -y -q gcc gcc-c++
    yum install -y -q epel-release
    #    yum install -y -q cmake3
    yum install -y -q libtool
    yum install -y -q make
    #    ln -s /usr/bin/cmake3 /usr/bin/cmake
fi    


sh autogen.sh
./configure
make

mkdir /artifacts
cp -r include include_${ARCH}_${CIRCLE_SHA1}
zip -r include_${ARCH}_${CIRCLE_SHA1}.zip include_${ARCH}_${CIRCLE_SHA1}
cp include_${ARCH}_${CIRCLE_SHA1}.zip /artifacts/
cp .libs/libuv.a /artifacts/libuv_${ARCH}_${CIRCLE_SHA1}.a
