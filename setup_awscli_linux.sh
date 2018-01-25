if [[ $ARCH = *"centos7"* ]]; then
    echo setup python for centos7        
    yum install -y -q https://centos7.iuscommunity.org/ius-release.rpm
    yum install -y -q python34
    python3.4 --version
    python --version
    curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
    python get-pip.py
fi

if [[ $ARCH = *"centos6"* ]]; then
    echo setup python for centos6
    yum install -y -q python
    yum install -y -q python-pip
    #        yum install -y python-setuptools
    
    easy_install pip
fi
    
# centos6/7共通
pip install awscli

AWSDIR=~/.aws
mkdir -p ${AWSDIR}

echo "[default]" > ${AWSDIR}/config
echo "output = json" >> ${AWSDIR}/config
echo "region = ap-northeast-1" >> ${AWSDIR}/config

echo "[default]" > ${AWSDIR}/credentials
echo "aws_access_key_id=${AWS_ACCESS_KEY_ID}" >> ${AWSDIR}/credentials
echo "aws_secret_access_key=${AWS_SECRET_ACCESS_KEY}" >> ${AWSDIR}/credentials
