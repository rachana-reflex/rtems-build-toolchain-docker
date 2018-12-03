#!/bin/bash

# Copyright 2018 luzidchris, CTrocks All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# ====================================
# Dockerfile for RTEMS toolchain build
# ====================================
#
# It's not required to use Travis CI for the build. Just use docker
# or execute provided script 'build_run.sh' directly (in this case
# ensure that GCC is available.
#

# environment shall be Ubuntu 18.04 LTS
# as it already provides GCC7 which is
# required for RTEMS build (RSB master
# is configured to use this version
# for the cross-compiler)
FROM ubuntu:bionic

# the target architecture is passed to docker
# as a build argument (docker command line call)
ARG TARGET_ARCH
ENV TARGET_ARCH=$TARGET_ARCH

# set path for the build tools, e.g. scripts;
# default value can be changed with --build-arg
ARG BUILD_TOOLS_PATH="/opt/build-tools"

# set path of installation directory;
# default value can be changed with --build-arg
ARG INSTALL_DIR="/opt/rtems"

# we require the install path in the build 
# scripts later, so export the var to the
# environment
ENV INSTALL_DIR=$INSTALL_DIR

# prepare the paths and ensure that write
# access is granted to the user
RUN mkdir -p $BUILD_TOOLS_PATH
RUN chmod a+rw $BUILD_TOOLS_PATH

# do the same for the installation directory
RUN mkdir -p $INSTALL_DIR
RUN chmod a+rw $INSTALL_DIR

# obtain tools required for this Dockerfile,
# other dependencies will be installed later
# by the build scripts in case anything else
# is required
RUN apt-get -qq update && apt-get -qq -y install git

# fetch build scripts
RUN git clone https://github.com/CTrocks/rtems-build-scripts $BUILD_TOOLS_PATH

# ensure scripts are executable
RUN chmod +x $BUILD_TOOLS_PATH/run.sh
RUN chmod +x $BUILD_TOOLS_PATH/scripts/*.sh

# workaround to use var-controlled path
# to call the ENTRYPOINT: generate script
# now to call it later without variable
# path in ENTRYPOINT
RUN echo "#!/bin/bash" > ./run_build.sh
RUN echo "cd $BUILD_TOOLS_PATH" >> ./run_build.sh
RUN echo "bash run.sh" >> ./run_build.sh
RUN chmod +x ./run_build.sh
RUN echo "run script: "$(cat ./run_build.sh)

# run main build script automatically
ENTRYPOINT ["./run_build.sh"]
