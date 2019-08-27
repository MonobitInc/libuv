LOCAL_PATH := $(call my-dir)/..

include $(CLEAR_VARS)
LOCAL_MODULE := libuv
SRCS := $(LOCAL_PATH)/src/fs-poll.c
SRCS += $(LOCAL_PATH)/src/inet.c
SRCS += $(LOCAL_PATH)/src/threadpool.c
SRCS += $(LOCAL_PATH)/src/uv-common.c
SRCS += $(LOCAL_PATH)/src/version.c
SRCS += $(LOCAL_PATH)/src/unix/async.c
SRCS += $(LOCAL_PATH)/src/unix/core.c
SRCS += $(LOCAL_PATH)/src/unix/dl.c
SRCS += $(LOCAL_PATH)/src/unix/fs.c
SRCS += $(LOCAL_PATH)/src/unix/getaddrinfo.c
SRCS += $(LOCAL_PATH)/src/unix/getnameinfo.c
SRCS += $(LOCAL_PATH)/src/unix/loop.c
SRCS += $(LOCAL_PATH)/src/unix/loop-watcher.c
SRCS += $(LOCAL_PATH)/src/unix/pipe.c
SRCS += $(LOCAL_PATH)/src/unix/poll.c
SRCS += $(LOCAL_PATH)/src/unix/process.c
SRCS += $(LOCAL_PATH)/src/unix/signal.c
SRCS += $(LOCAL_PATH)/src/unix/stream.c
SRCS += $(LOCAL_PATH)/src/unix/tcp.c
SRCS += $(LOCAL_PATH)/src/unix/thread.c
SRCS += $(LOCAL_PATH)/src/timer.c
SRCS += $(LOCAL_PATH)/src/unix/tty.c
SRCS += $(LOCAL_PATH)/src/unix/udp.c
SRCS += $(LOCAL_PATH)/src/unix/proctitle.c
SRCS += $(LOCAL_PATH)/src/unix/linux-core.c
SRCS += $(LOCAL_PATH)/src/unix/linux-inotify.c
SRCS += $(LOCAL_PATH)/src/unix/linux-syscalls.c
SRCS += $(LOCAL_PATH)/src/unix/pthread-fixes.c
SRCS += $(LOCAL_PATH)/src/unix/android-ifaddrs.c
SRCS += $(LOCAL_PATH)/src/strscpy.c
LOCAL_SRC_FILES := $(SRCS)

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include
LOCAL_C_INCLUDES += $(LOCAL_PATH)/src

LOCAL_CFLAGS := 

include $(BUILD_STATIC_LIBRARY)
$(info [$(TARGET_ARCH_ABI)] $(LOCAL_SRC_FILES))
