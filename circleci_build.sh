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
    yum install -y -q libtool
    yum install -y -q make
    yum install -y -q zip

    # aws config
    yum install -y -q git
    git submodule update --init build_tools
    bash -e build_tools/setup_awscli_linux.sh ${ARCH}
fi    


sh autogen.sh
./configure
make CFLAGS=-fPIC

BASENAME=libuv_${ARCH}_${CIRCLE_SHA1}

mkdir /artifacts
mkdir /artifacts/${BASENAME}

cp -r include /artifacts/${BASENAME}/
cp .libs/libuv.a /artifacts/${BASENAME}/

cd /artifacts
zip -r ${BASENAME}.zip ${BASENAME}

aws s3 cp ${BASENAME}.zip s3://monobit-engine-public/libuv_bin/${BASENAME}.zip --acl public-read


