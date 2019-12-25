set -x

UNAME=`uname -sm | sed -e s,x86_64,i386,`
echo $UNAME
DATE=`date "+%Y%m%d%H%M"`


if [ "$UNAME" = "Darwin i386" ]; then
    OSXVER=`sw_vers -productVersion`
    PKGDIR="libuv-macos$OSXVER-$DATE"
else
    PKGDIR="libuv-el7-$DATE"
fi

sh autogen.sh
./configure
make CFLAGS=-fPIC

mkdir /tmp/${PKGDIR}

cp -r include /tmp/${PKGDIR}/
cp .libs/libuv.a /tmp/${PKGDIR}/
git log | head -1 | awk '{print $2}' > /tmp/${PKGDIR}/git_revision.txt

cd /tmp
zip -r ${PKGDIR}.zip ${PKGDIR}

aws s3 cp ${PKGDIR}.zip s3://monobit/libuv/${PKGDIR}.zip


