FROM ubuntu:22.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    verilator \
    perl \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash sandbox

USER sandbox
WORKDIR /workspace
