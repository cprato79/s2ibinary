# Build s2i binary image

The purpose of this repository is to make it possible to run s2i inside a container.

References:

 * [s2i project](https://github.com/openshift/source-to-image)

 * [kaniko](https://github.com/GoogleContainerTools/kaniko)

## Getting Started

1. build the image:

    ```bash
    docker build . -t cprato79/s2ibinary:latest
    ```

2. push the image on to AWS ECR repository

    ```bash
    docker push cprato79/s2ibinary:latest
    ```

## Docker Repository

https://hub.docker.com/r/cprato79/s2ibinary
