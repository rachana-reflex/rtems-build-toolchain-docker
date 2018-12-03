
# RTEMS toolchain build with Docker

This repo contains a Dockerfile which can be used to build RTEMS toolchain with Docker. The Dockerfile will fetch [RTEMS build scripts](https://github.com/CTrocks/rtems-build-scripts) from github for the build. For further info on the build process itself, see project [RTEMS build scripts](https://github.com/CTrocks/rtems-build-scripts).

In case you want to build RTEMS toolchain without Docker, just use the scripts located at [RTEMS build scripts](https://github.com/CTrocks/rtems-build-scripts) and follow the instructions found in project's README.md.

## How to use

To make use of Dockerfile, docker.io must be installed on the system, e.g. for Debian-based distributions, this can be done by
```code sh
sudo apt-get install docker.io
```

Next, the image has to be built (enter directory where Dockerfile located first). The following command shows how to run the RTEMS toolchain build for target `x86_64`. Change `TARGET_ARCH` to the appriate target symbol as documented at [RTEMS target architectures](https://docs.rtems.org/branches/master/user/hardware/architectures.html).

```code sh
docker build --build-arg TARGET_ARCH=x86_64 -t rtemsbuild .
```
Once done, the actual build can be started with:
```code sh
docker run -t rtemsbuild
```
Please note that identifier `rtemsbuild` is just an example and feel free to change it.

## Clean up docker/existing images

To get rid of unused images, use
```code sh
docker system prune
```
To remove the existing build image, use
```
docker rmi rtemsbuild
```

Info: You might want to add the current user to group `docker` to avoid use of `sudo`.
