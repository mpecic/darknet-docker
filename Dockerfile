ARG BASE_IMAGE=nvidia/cuda:11.1-cudnn8-devel-ubuntu18.04
FROM $BASE_IMAGE
LABEL maintainer="Marko Pecic <marko.pecic@smart-sense.hr>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
      && apt-get install --no-install-recommends --no-install-suggests -y gnupg2 ca-certificates \
            git build-essential libopencv-dev \
      && rm -rf /var/lib/apt/lists/*

COPY configure.sh /tmp/

RUN git clone https://github.com/AlexeyAB/darknet.git && cd darknet \
      && /tmp/configure.sh gpu-cv-cc86 && make \
      && cp darknet /usr/local/bin \
      && cd .. && rm -rf darknet
