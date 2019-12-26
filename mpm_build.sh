set -x

UNAME=`uname`

DATESTR=`date "+%Y%m%d%H%M"`


if [ "$UNAME" = "Darwin" ]; then
    echo Darwin detected    
    OSXVER=`sw_vers -productVersion` # ex. 10.15
    BASENAME=libuv-macos${OSXVER}-${DATESTR}
fi

if [[ "${UNAME}" == "Linux" ]]; then
  EL7=`grep -o "release 7" /etc/redhat-release`
  if [[ "${EL7}" == "release 7" ]]; then
    echo "el7 detected"
    BASENAME=libuv-el7-${DATESTR}
  else
    echo "el7 not detected, next, search for ubuntu"    
  fi
  UBU=`lsb_release -i -s`
  if [[ "${UBU}" == "Ubuntu" ]]; then
      UBUVER=`lsb_release -r -s`
      BASENAME=libuv-ubuntu${UBUVER}-${DATESTR}
  else
      echo "ubuntu not detected"
      exit 1
  fi  
  SYMLINKOPT=-L
fi

sh autogen.sh
./configure
make CFLAGS=-fPIC

mkdir /tmp/${BASENAME}

cp -r include /tmp/${BASENAME}/
cp .libs/libuv.a /tmp/${BASENAME}/
git log | head -1 | awk '{print $2}' > /tmp/${BASENAME}/git_revision.txt

cd /tmp
zip -r ${BASENAME}.zip ${BASENAME}

aws s3 cp ${BASENAME}.zip s3://monobit/libuv/${BASENAME}.zip


