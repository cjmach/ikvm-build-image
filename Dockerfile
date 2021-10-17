FROM mcr.microsoft.com/dotnet/sdk:3.1-bullseye

LABEL org.label-schema.build-date="${BUILD_DATE}" \
      org.label-schema.description="Docker image preconfigured to build IKVM for .NET Core." \
      org.label-schema.docker.cmd="docker run -it --rm cjmach/ikvm-build" \
      org.label-schema.name="cjmach/ikvm-build" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.url="https://github.com/cjmach/ikvm-build-image" \
      org.label-schema.vcs-ref="${SOURCE_COMMIT}" \
      org.label-schema.vcs-url="https://github.com/cjmach/ikvm-build-image" \
      org.label-schema.vendor="cjmach" \
      org.label-schema.version="${SOURCE_BRANCH}"

ARG JDK_SRC_URL="http://www.frijters.net/openjdk-8u45-b14-stripped.zip"

RUN DEBIAN_FRONTEND=noninteractive && \
    apt -y update && \
    apt -y install gnupg mono-devel wget unzip && \
    wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - && \
    echo "deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ bullseye main" >> /etc/apt/sources.list && \
    apt -y update && \
    apt -y install adoptopenjdk-8-hotspot && \
    apt -y --autoremove purge gnupg && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir ikvm-core && \
    cd ikvm-core && \
    wget -q -O openjdk-src.zip ${JDK_SRC_URL} && \
    unzip openjdk-src.zip && \
    rm -f openjdk-src.zip
    
WORKDIR ikvm-core
