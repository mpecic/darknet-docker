ARG BASE_IMAGE=nvidia/cuda:11.1-devel-ubuntu18.04
FROM $BASE_IMAGE

ENV CUDNN_VERSION=8.0.5.39

LABEL com.nvidia.cudnn.version=8.0.5.39

LABEL maintainer="Marko Pecić <marko.pecic@smart-sense.hr>"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
      && apt-get install --no-install-recommends -y libcudnn8=$CUDNN_VERSION-1+cuda11.1 libcudnn8-dev=$CUDNN_VERSION-1+cuda11.1 \
      && apt-mark hold libcudnn8 \
      && apt-get install --no-install-recommends --no-install-suggests -y gnupg2 ca-certificates git build-essential libopencv-dev \
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
