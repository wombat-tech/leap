Spielworks Leap Docker
======================

:warning: This repository contains private and public keys. The keys are well known and ok to
publish. *DO NOT USE THEM FOR PRODUCTIVE PURPOSES*

The Docker image and script in this repository are meant to run a local/testing Leap (eosio) node.
The image contains the `nodeos` binary, `cleos` from [leap](https://github.com/AntelopeIO/leap) and
compiled [reference smart contracts](https://github.com/AntelopeIO/reference-contracts).

The Docker image is available at

```
ghcr.io/wombat-tech/leap:v$LEAP_VERSION-$BUILD
e.g.
ghcr.io/wombat-tech/leap:v3.2.3-1
```

# Usage

Once a node is started, the RPC is available at `http://localhost:6000`. `cleos` is available via
`docker exec`:

```shell
docker exec test_wax_node cleos get info
```

## Ready node

In order to get a fully functional node running, just execute `./createNode.sh`.

## Base node

This is for advanced usecases. The node will not be ready for a lot of things.

Just start the docker image on its own:

```shell
docker run --name node ghcr.io/wombat-tech/leap:v3.2.3-1
```

## Build docker image

If you need to build the docker image, simply run

```shell
docker build . --tag ghcr.io/wombat-tech/leap:localbuild
```
