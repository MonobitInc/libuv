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
    yum install -y -q python
    curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
    python get-pip.py
    pip install awscli

    AWSDIR=~/.aws
    mkdir -p 
    
    echo "[default]" > ${AWSDIR}/config
    echo "output = json" >> ${AWSDIR}/config
    echo "region = ap-northeast-1" >> ${AWSDIR}/config

    echo "[default]" > ${AWSDIR}/credentials
    echo "aws_access_key_id=${AWS_ACCESS_KEY_ID}" >> ${AWSDIR}/credentials
    echo "aws_secret_access_key=${AWS_SECRET_ACCESS_KEY}" >> ${AWSDIR}/credentials
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

aws s3 put s3://appveyor-tmp/libuv_bin/${BASENAME}.zip

