FROM ghcr.io/wombat-tech/antelope.cdt:v3.1.0 as contractBuilder

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

# Built smart contracts are now in folder contracts/eosio.bios|boot|msig|system|token|wrap

# Move all of the contract files to a single location to easily copy them over
RUN mkdir /contracts
RUN mv contracts/eosio.bios/eosio.bios.abi contracts/eosio.bios/eosio.bios.wasm \
    contracts/eosio.boot/eosio.boot.abi contracts/eosio.boot/eosio.boot.wasm \
    contracts/eosio.msig/eosio.msig.abi contracts/eosio.msig/eosio.msig.wasm \
    contracts/eosio.system/eosio.system.abi contracts/eosio.system/eosio.system.wasm \
    contracts/eosio.token/eosio.token.abi contracts/eosio.token/eosio.token.wasm \
    contracts/eosio.wrap/eosio.wrap.abi contracts/eosio.wrap/eosio.wrap.wasm \
    /contracts

FROM ubuntu:22.04

# Install wget to download the leab DEB package
RUN apt update
RUN apt --assume-yes install wget

# Download and install leap
RUN wget https://github.com/AntelopeIO/leap/releases/download/v3.2.3/leap_3.2.3-ubuntu22.04_amd64.deb
RUN apt --assume-yes --allow-downgrades install ./leap_3.2.3-ubuntu22.04_amd64.deb

# Expose the port that the RPC will be running on
EXPOSE 8888

# Copy over the built system smart contracts so they can be installed later
COPY --from=contractBuilder /contracts /contracts/

ENTRYPOINT ["/usr/bin/nodeos"]
CMD [ \
  # Enable the HTTP plugin
  "--plugin", "eosio::http_plugin", \
  # Enable the chain API plugin, e.g. /v1/chain/get_info
  "--plugin", "eosio::chain_api_plugin", \
  # Enable the producer API plugin, mostly for protocol feature activation
  "--plugin", "eosio::producer_api_plugin", \
  # Bind to port 8888 for HTTP
  "--http-server-address", "0.0.0.0:8888", \
  # Turn of host header validation since we are not running under a domain
  "--http-validate-host", "false", \
  # Not 100% sure if needed - but also listed in https://developers.eos.io/welcome/latest/tutorials/bios-boot-sequence
  "--enable-stale-production", \
  # Set a producer name. Also not 100% sure if needed, but we want to produce blocks.
  "--producer-name", "eosio" \
]
