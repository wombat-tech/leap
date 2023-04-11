Smart contracts
===============

The smart contracts in this folder are included in the leap image.

## System smart contracts

The system smart contracts were build with the following Dockerfile:


```dockerfile
FROM ghcr.io/wombat-tech/antelope.cdt:v3.1.0

# Build the leap system smart contracts so we can deploy them to the chain

# Install unzip, required for the downloaded smart contract code
RUN apt update
RUN apt --assume-yes install unzip

# Download smart contracts at a specific commit
RUN wget https://github.com/AntelopeIO/reference-contracts/archive/efff1254806aa2df68d06f5d5e4b5c122297a857.zip
RUN unzip efff1254806aa2df68d06f5d5e4b5c122297a857.zip
# Create cmake build folder. The top level folder is created by GitHub in the archive file
RUN mkdir /reference-contracts-efff1254806aa2df68d06f5d5e4b5c122297a857/build
# Switch to that folder from here on
WORKDIR /reference-contracts-efff1254806aa2df68d06f5d5e4b5c122297a857/build
# Configure cmake, link to the toolchain file for the cross compilation
RUN cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=/usr/opt/cdt/3.1.0/lib/cmake/cdt/CDTWasmToolchain.cmake ..
RUN make
```

They then are available in the `build` directory.

## AtomicAssets

The atomic assets smart contract was downloaded from here:

https://github.com/pinknetworkx/atomicassets-contract-tests/tree/e6570847442c107819ce5bb9b4ca68c8d92807ee/contract_source