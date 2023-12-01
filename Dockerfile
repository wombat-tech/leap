FROM ubuntu:22.04 as nodebuilder

# Install wget to download the leap DEB package
RUN apt update
RUN apt --assume-yes install curl

# Download and install leap. --location to follow redirect
RUN curl -o leap.deb --location \
    https://github.com/AntelopeIO/leap/releases/download/v4.0.4/leap_4.0.4-ubuntu22.04_amd64.deb
RUN apt --assume-yes --allow-downgrades install ./leap.deb

# Expose the port that the RPC will be running on
EXPOSE 8888

# Copy over the built system smart contracts so they can be installed later
ADD /contracts /contracts/

# Copy over the script to bootstrap the node
ADD bootstrap.sh /

# Run the script to bootstrap the node
RUN sh /bootstrap.sh

FROM nodebuilder

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
  # Maximum time for processing a request, -1 for unlimited (eosio::http_plugin)
  # Using unlimited here to avoid timeout_exception `deadline ${d} exceeded by ${t}us`
  "--http-max-response-time-ms", "-1", \
  # Not 100% sure if needed - but also listed in https://developers.eos.io/welcome/latest/tutorials/bios-boot-sequence
  "--enable-stale-production", \
  # Set a producer name. Also not 100% sure if needed, but we want to produce blocks.
  "--producer-name", "eosio", \
  # The build process sadly seems to leave the node in a bad state. This makes the node usable.
  # It's of course theoretically slow, but since we only have like 7 blocks after the build...
  # --hard-replay does for some reason not work on macOS, but --replay-blockchain does and works
  # just as fine
  "--replay-blockchain" \
]
