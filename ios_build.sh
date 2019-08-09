# build libuv for ios 12.4


IOSVER=12.4

SDKOPT="-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS${IOSVER}.sdk -arch arm64 -miphoneos-version-min=12.0"

SRCS="src/fs-poll.c src/inet.c src/threadpool.c src/uv-common.c src/version.c src/unix/async.c src/unix/core.c src/unix/dl.c src/unix/fs.c src/unix/getaddrinfo.c src/unix/getnameinfo.c src/unix/loop.c src/unix/loop-watcher.c src/unix/pipe.c src/unix/poll.c src/unix/process.c src/unix/signal.c src/unix/stream.c src/unix/tcp.c src/unix/thread.c src/timer.c src/unix/tty.c src/unix/udp.c src/unix/proctitle.c src/unix/pthread-fixes.c"

OBJS="fs-poll.o inet.o threadpool.o uv-common.o version.o async.o core.o dl.o fs.o getaddrinfo.o getnameinfo.o loop.o loop-watcher.o pipe.o poll.o process.o signal.o stream.o tcp.o thread.o timer.o tty.o udp.o proctitle.o pthread-fixes.o"

clang ${SDKOPT} -c -I./include -I./src ${SRCS}


ar cr libuv.a ${OBJS}
ranlib libuv.a

# upload
DATESTR=`date "+%Y%m%d%H%M"`
OUTDIR=libuv-ios-${IOSVER}-${DATESTR}
rm -rf ${OUTDIR}
mkdir ${OUTDIR}
cp -r include ${OUTDIR}/
cp libuv.a ${OUTDIR}/
zip -r ${OUTDIR}.zip ${OUTDIR}
aws s3 cp ${OUTDIR}.zip s3://monobit/libuv/${OUTDIR}.zip
aws s3 ls s3://monobit/libuv/
