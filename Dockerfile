LABEL maintainer="michael.cramer@ironnetcybersecurity.com"

ARG JAVA_VERSION
FROM amazoncorretto:$JAVA_VERSION

RUN apt-get update && apt-get -y install \
    gnupg2 \
    git \
    curl \
    sed \
    unzip \
    jq \
    make \
    tree \
    gettext \
    && rm -rf /var/lib/apt/lists/*

ARG SBT_VERSION
RUN curl -L https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz | tar xz -C /opt && \
    ln -s /opt/sbt/bin/sbt /usr/local/bin/sbt

RUN mkdir /home/build

WORKDIR /home/build
ENTRYPOINT [ "sbt" ]
