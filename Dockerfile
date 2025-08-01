# Copied from QEMU to statisfy FWAs requirement that the Dockerfile has to be named "Dockerfile"
#
# See: [qemu]/tests/docker/dockerfiles/debian.docker

FROM docker.io/library/debian:12-slim

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y eatmydata && \
    eatmydata apt-get dist-upgrade -y && \
    eatmydata apt-get install --no-install-recommends -y \
                      bash \
                      bc \
                      bindgen \
                      bison \
                      bsdextrautils \
                      bzip2 \
                      ca-certificates \
                      ccache \
                      clang \
                      dbus \
                      debianutils \
                      diffutils \
                      exuberant-ctags \
                      findutils \
                      flex \
                      gcc \
                      gcovr \
                      gettext \
                      git \
                      hostname \
                      libaio-dev \
                      libasan6 \
                      libasound2-dev \
                      libattr1-dev \
                      libbpf-dev \
                      libbrlapi-dev \
                      libbz2-dev \
                      libc6-dev \
                      libcacard-dev \
                      libcap-ng-dev \
                      libcapstone-dev \
                      libcbor-dev \
                      libcmocka-dev \
                      libcurl4-gnutls-dev \
                      libdaxctl-dev \
                      libdrm-dev \
                      libepoxy-dev \
                      libfdt-dev \
                      libffi-dev \
                      libfuse3-dev \
                      libgbm-dev \
                      libgcrypt20-dev \
                      libglib2.0-dev \
                      libglusterfs-dev \
                      libgnutls28-dev \
                      libgtk-3-dev \
                      libgtk-vnc-2.0-dev \
                      libibverbs-dev \
                      libiscsi-dev \
                      libjemalloc-dev \
                      libjpeg62-turbo-dev \
                      libjson-c-dev \
                      liblttng-ust-dev \
                      liblzo2-dev \
                      libncursesw5-dev \
                      libnfs-dev \
                      libnuma-dev \
                      libpam0g-dev \
                      libpcre2-dev \
                      libpipewire-0.3-dev \
                      libpixman-1-dev \
                      libpmem-dev \
                      libpng-dev \
                      libpulse-dev \
                      librbd-dev \
                      librdmacm-dev \
                      libsasl2-dev \
                      libsdl2-dev \
                      libsdl2-image-dev \
                      libseccomp-dev \
                      libselinux1-dev \
                      libslirp-dev \
                      libsnappy-dev \
                      libsndio-dev \
                      libspice-protocol-dev \
                      libspice-server-dev \
                      libssh-dev \
                      libsystemd-dev \
                      libtasn1-6-dev \
                      libubsan1 \
                      libudev-dev \
                      liburing-dev \
                      libusb-1.0-0-dev \
                      libusbredirhost-dev \
                      libvdeplug-dev \
                      libvirglrenderer-dev \
                      libvte-2.91-dev \
                      libxdp-dev \
                      libxen-dev \
                      libzstd-dev \
                      llvm \
                      locales \
                      make \
                      meson \
                      mtools \
                      multipath-tools \
                      ncat \
                      nettle-dev \
                      ninja-build \
                      openssh-client \
                      pkgconf \
                      python3 \
                      python3-numpy \
                      python3-opencv \
                      python3-pillow \
                      python3-pip \
                      python3-sphinx \
                      python3-sphinx-rtd-theme \
                      python3-venv \
                      python3-yaml \
                      rpm2cpio \
                      rustc-web \
                      sed \
                      socat \
                      sparse \
                      swtpm \
                      systemtap-sdt-dev \
                      tar \
                      tesseract-ocr \
                      tesseract-ocr-eng \
                      vulkan-tools \
                      xorriso \
                      zlib1g-dev \
                      zstd && \
    eatmydata apt-get autoremove -y && \
    eatmydata apt-get autoclean -y && \
    sed -Ei 's,^# (en_US\.UTF-8 .*)$,\1,' /etc/locale.gen && \
    dpkg-reconfigure locales && \
    rm -f /usr/lib*/python3*/EXTERNALLY-MANAGED && \
    dpkg-query --showformat '${Package}_${Version}_${Architecture}\n' --show > /packages.txt && \
    mkdir -p /usr/libexec/ccache-wrappers && \
    ln -s /usr/bin/ccache /usr/libexec/ccache-wrappers/cc && \
    ln -s /usr/bin/ccache /usr/libexec/ccache-wrappers/clang && \
    ln -s /usr/bin/ccache /usr/libexec/ccache-wrappers/gcc

ENV CCACHE_WRAPPERSDIR "/usr/libexec/ccache-wrappers"
ENV LANG "en_US.UTF-8"
ENV MAKE "/usr/bin/make"
ENV NINJA "/usr/bin/ninja"
ENV PYTHON "/usr/bin/python3"
# netmap/cscope/global
RUN DEBIAN_FRONTEND=noninteractive eatmydata \
  apt install -y --no-install-recommends \
  cscope\
  global\
  linux-headers-generic
RUN git clone https://github.com/luigirizzo/netmap.git /usr/src/netmap
RUN cd /usr/src/netmap && git checkout v11.3
RUN cd /usr/src/netmap/LINUX && \
  ./configure --no-drivers --no-apps \
  --kernel-dir=$(ls -d /usr/src/linux-headers-*-$(dpkg --print-architecture)) \
  && make install
ENV QEMU_CONFIGURE_OPTS --enable-netmap
# As a final step configure the user (if env is defined)
ARG USER
ARG UID
RUN if [ "${USER}" ]; then \
  id ${USER} 2>/dev/null || useradd -u ${UID} -U ${USER}; fi
