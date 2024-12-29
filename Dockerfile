FROM ubuntu:24.04

#Git
RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/* && \
    git config --global user.name "EunhaKyeong" && \
    git config --global user.email "kyeongeh424@gmail.com"

#JDK: zulu 17 Latest
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
ARG ZULU_REPO_VER=1.0.0-3
ARG ZULU_REPO_SHA256=d08d9610c093b0954c6b278ecc628736e303634331641142fa5096396201f49c

RUN apt-get -qq update && \
    apt-get -qq -y --no-install-recommends install gnupg software-properties-common locales curl tzdata && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9 && \
    curl -sLO https://cdn.azul.com/zulu/bin/zulu-repo_${ZULU_REPO_VER}_all.deb && \
    echo "${ZULU_REPO_SHA256} zulu-repo_${ZULU_REPO_VER}_all.deb" | sha256sum --strict --check - && \
    dpkg -i zulu-repo_${ZULU_REPO_VER}_all.deb && \
    apt-get -qq update && \
    echo "Package: zulu17-*\nPin: version 17.0.13-*\nPin-Priority: 1001" > /etc/apt/preferences && \
    apt-get -qq -y --no-install-recommends install zulu17-jdk=17.0.13-* && \
    apt-get -qq -y purge --auto-remove gnupg software-properties-common curl && \
    rm -rf /var/lib/apt/lists/* zulu-repo_${ZULU_REPO_VER}_all.deb

ENV JAVA_HOME=/usr/lib/jvm/zulu17

#Gradle: 8.12
RUN apt-get update && apt-get install -y \
    unzip \
    wget && \
    rm -rf /var/lib/apt/lists/*

ENV GRADLE_HOME=/opt/gradle
ENV GRADLE_VERSION=8.12
ARG GRADLE_DOWNLOAD_SHA256=7a00d51fb93147819aab76024feece20b6b84e420694101f276be952e08bef03
RUN wget --no-verbose --output-document=gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" && \
    echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum --check - && \
    unzip gradle.zip && rm gradle.zip && \
    mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" && \
    ln --symbolic "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle

RUN gradle --version

#Android SDK: commandlinetools-linux-11076708_latest
#Build platform: 34, 35
#Build tool: 34.0.0, 35.0.0
RUN cd ~ \
    && mkdir /opt/android_sdk \
    && cd /opt/android_sdk \
    && wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip \
    && unzip commandlinetools-linux-11076708_latest.zip \
    && cd cmdline-tools \
    && mkdir latest \
    && mv bin/ lib/ NOTICE.txt source.properties latest/. \
    && cd ~ \
    && yes | /opt/android_sdk/cmdline-tools/latest/bin/sdkmanager --licenses \
    && y | /opt/android_sdk/cmdline-tools/latest/bin/sdkmanager --install "cmdline-tools;9.0" \
    && /opt/android_sdk/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-34" \
    && /opt/android_sdk/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-35" \
    && /opt/android_sdk/cmdline-tools/latest/bin/sdkmanager "platform-tools" "build-tools;34.0.0" \
    && /opt/android_sdk/cmdline-tools/latest/bin/sdkmanager "platform-tools" "build-tools;35.0.0" \
    && rm -r /opt/android_sdk/commandlinetools-linux-11076708_latest.zip
