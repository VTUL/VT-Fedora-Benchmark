#!/bin/bash
sudo apt-get update && sudo apt-get install -y git
git clone -b ansible-or2016 https://github.com/VTUL/VT-Fedora-Benchmark.git vt-fedora-benchmark
vt-fedora-benchmark/utils/fedora_setup.sh