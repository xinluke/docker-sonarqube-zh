FROM openjdk:11-jre-slim

ENV SONAR_VERSION=7.8 \
    SONARQUBE_HOME=/opt/sonarqube 

# Http port
EXPOSE 9000
RUN apt-get update \
    && apt-get install -y curl unzip \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -r sonarqube && useradd -r -g sonarqube sonarqube \
    && set -x \
    && cd /opt \
    && curl -o sonarqube.zip -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && unzip -q sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && chown -R sonarqube:sonarqube sonarqube \
    && rm sonarqube.zip* \
    && curl -o sonar-l10n-zh-plugin-1.28.jar -fSL https://github.com/SonarQubeCommunity/sonar-l10n-zh/releases/download/sonar-l10n-zh-plugin-1.28/sonar-l10n-zh-plugin-1.28.jar \
    && mv sonar-l10n-zh-plugin-1.28.jar /opt/sonarqube/extensions/plugins/

VOLUME "$SONARQUBE_HOME/data"

WORKDIR $SONARQUBE_HOME

USER sonarqube

ENTRYPOINT ["/opt/sonarqube/bin/linux-x86-64/sonar.sh","console"]
