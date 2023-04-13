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
ghcr.io/wombat-tech/leap:v3.2.3-4
```

# Start node

Simply run

```shell
docker run -p 8085:8888 ghcr.io/wombat-tech/leap:v3.2.3-4
```

The node RPC is then available under `localhost:8085`.

# Node state

The node has all the standard accounts - `eosio`, `eosio.token` etc. The system currency is `WAX`
with 8 decimals.

Additionally, the `atomicassets` contract is already deployed and initialized, and the account
`genialwombat` exists with some WAX.

All accounts have the public key `EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV` with the
private key `5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3`. This is a well known key and ok
to share.

# Run cleos commands

Once a node is started, the RPC is available at `http://localhost:6000`. `cleos` is available via
`docker exec`:

```shell
docker exec test_wax_node cleos get info
```

## Build docker image

If you need to build the docker image, simply run

```shell
docker build . --tag ghcr.io/wombat-tech/leap:localbuild
```

In rare cases the build might fail, especially in `bootstrap.sh` steps that deploy smart contracts,
e.g. with the error "deadline exceeded". Usually running the build command again until it works
helps.