ARG BASE_IMAGE=nvidia/cuda:11.1-cudnn8-devel-ubuntu18.04
FROM $BASE_IMAGE
LABEL maintainer="Marko Pecić <marko.pecic@smart-sense.hr>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
      && apt-get install --no-install-recommends --no-install-suggests -y gnupg2 ca-certificates \
            git build-essential libopencv-dev \
      && rm -rf /var/lib/apt/lists/*

COPY configure.sh /tmp/

ARG SOURCE_BRANCH=unspecified
ENV SOURCE_BRANCH $SOURCE_BRANCH

ARG SOURCE_COMMIT=unspecified
ENV SOURCE_COMMIT $SOURCE_COMMIT

RUN git clone https://github.com/AlexeyAB/darknet.git && cd darknet \
      && git checkout $SOURCE_BRANCH \
      && git reset --hard $SOURCE_COMMIT \
      && /tmp/configure.sh gpu-cv-cc86 && make \
      && cp darknet /usr/local/bin \
      && cd .. && rm -rf darknet
