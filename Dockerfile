ARG JAVA_VERSION=19
ARG ALPINE_VERSION=3.16
FROM amazoncorretto:$JAVA_VERSION-alpine$ALPINE_VERSION

LABEL maintainer="michael.cramer@ironnetcybersecurity.com"

RUN apk add --no-cache \
    bash \
    git \
    curl \
    sed \
    unzip \
    jq \
    make \
    tree \
    gettext

ARG SBT_VERSION=1.8.0
RUN curl -L https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz | tar xz -C /opt && \
    ln -s /opt/sbt/bin/sbt /usr/local/bin/sbt

RUN mkdir /home/build

WORKDIR /home/build
ENTRYPOINT [ "sbt" ]
