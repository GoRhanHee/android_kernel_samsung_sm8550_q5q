#!/bin/bash

./build_kernel.sh || exit 1
./build_module.sh || exit 1