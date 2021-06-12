FROM ghcr.io/linuxserver/baseimage-alpine:3.13

LABEL \
  maintainer="TKVictor-Hang@outlook.fr"

### Set default Timezone, overwrite default MangaTagger settings for the container ###
ENV \
  TZ="Europe/Paris" \
  MANGA_TAGGER_DEBUG_MODE=false \
  MANGA_TAGGER_DATA_DIR="/config/data" \
  MANGA_TAGGER_IMAGE_COVER=true \
  MANGA_TAGGER_IMAGE_DIR="/config/cover" \
  MANGA_TAGGER_ADULT_RESULT=false \
  MANGA_TAGGER_DOWNLOAD_DIR="/downloads" \
  MANGA_TAGGER_LIBRARY_DIR="/manga" \
  MANGA_TAGGER_LOGGING_DIR="/config/logs" \
  MANGA_TAGGER_DRY_RUN=false \
  MANGA_TAGGER_DB_INSERT=false \
  MANGA_TAGGER_RENAME_FILE=false \
  MANGA_TAGGER_WRITE_COMICINFO=false \
  MANGA_TAGGER_THREADS=8 \
  MANGA_TAGGER_MAX_QUEUE_SIZE=0 \
  MANGA_TAGGER_DB_NAME=manga_tagger \
  MANGA_TAGGER_DB_HOST_ADDRESS=mangatagger-db \
  MANGA_TAGGER_DB_PORT=27017 \
  MANGA_TAGGER_DB_USERNAME=manga_tagger \
  MANGA_TAGGER_DB_PASSWORD=Manga4LYFE \
  MANGA_TAGGER_DB_AUTH_SOURCE=admin \
  MANGA_TAGGER_DB_SELECTION_TIMEOUT=10000 \
  MANGA_TAGGER_LOGGING_LEVEL=info \
  MANGA_TAGGER_LOGGING_CONSOLE=true \
  MANGA_TAGGER_LOGGING_FILE=true \
  MANGA_TAGGER_LOGGING_JSON=false \
  MANGA_TAGGER_LOGGING_TCP=false \
  MANGA_TAGGER_LOGGING_JSONTCP=false

### Upgrade ###
RUN \
  apk update

### Manga Tagger ###
COPY . /app/Manga-Tagger

RUN \
  echo "Installing Manga-Tagger"

COPY root/ /

### Dependencies ###
# Some pip modules aren't working with our alpine base image so we install their apk package version instead.
RUN \
  echo "Install dependencies" && \
  echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
  apk add --no-cache --update \
    python3=3.8.10 py3-pip=20.3.4 py3-numpy=1.20.3-r0 py3-multidict=5.1.0-r1 py3-yarl=1.6.3-r1 \
    py3-psutil=5.8.0-r1 py3-watchdog=2.1.2-r0 py3-requests=2.25.1-r4 py3-tz=2021.1-r1 \
    build-base=0.4-r1 jpeg-dev=8-r6 zlib-dev=1.2.11-r3 python3-dev=3.5.1-r0 && \

  pip3 install --no-cache-dir -r requirements.txt && \
  mkdir /manga && \
  mkdir /downloads

VOLUME /config
