FROM ubuntu:18.04

ARG BAZELISK_VER=1.3.0
ARG BAZEL_VER=2.0.0

RUN \
    apt-get update && \
    apt-get -y install \
        curl \
        gnupg2 \
        software-properties-common && \
    \
    # Git
    add-apt-repository ppa:git-core/ppa && \
    apt-get -y update && \
    apt-get -y install git && \
    \
    # Bazel (https://docs.bazel.build/versions/master/install-ubuntu.html)
    apt-get -y install openjdk-8-jdk && \
    echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | \
			tee /etc/apt/sources.list.d/bazel.list && \
    curl https://bazel.build/bazel-release.pub.gpg | apt-key add - && \
    apt-get update && \
    apt-get -y install bazel=${BAZEL_VER} && \
    \
    # Bazelisk
    cd /tmp && \
    git clone -b v${BAZELISK_VER} --depth 1 https://github.com/bazelbuild/bazelisk.git && \
    cd bazelisk && \
    bazel build --stamp --workspace_status_command=`pwd`/stamp.sh --platforms=@io_bazel_rules_go//go/toolchain:linux_amd64 //:bazelisk && \
    cp bazel-bin/linux_amd64_pure_stripped/bazelisk /usr/bin && \
    rm -rf /tmp/bazelisk && \
    \
    # Cleanup
    rm -rf ~/.cache/* && \
    apt-get clean

ENTRYPOINT []
