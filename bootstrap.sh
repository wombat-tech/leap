#!/bin/sh

# This script bootstraps nodeos with the system smart contracts and also deploys some smart
# contracts we often need

set -e

# Run nodeos in background
# The abi-serializer time and max-transaction time are set because there's kind of often errors
# with the setup script and "deadline exceeded" in some transactions. Not sure which one is the
# really needed one, but it doesn't hurt too much
/usr/bin/nodeos --plugin eosio::producer_api_plugin \
    --plugin eosio::chain_api_plugin \
    --abi-serializer-max-time-ms 10000 \
    --max-transaction-time 10000 \
    --enable-stale-production --producer-name eosio --plugin eosio::http_plugin \
    --http-server-address 0.0.0.0:8888 --http-validate-host false --http-max-response-time-ms -1 &

# Wait a bit for stability
sleep 3

# Protocol feature activation
curl --noproxy -XPOST localhost:8888/v1/producer/schedule_protocol_feature_activations \
      -H 'Content-Type: application/json' \
      -d '{"protocol_features_to_activate":["0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"]}'

# Wait a bit so the feature activation is really there
sleep 2

# Create default wallet
cleos wallet create --to-console

# Import the private key for eosio from the leap Docker image
cleos wallet import --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3

# Create required accounts, all with the same private key
cleos create account eosio eosio.token EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio eosio.bpay EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio eosio.names EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio eosio.ram EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio eosio.ramfee EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio eosio.stake EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio eosio.vpay EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio eosio.rex EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

# Deploy boot smart contract
cleos set contract eosio /contracts eosio.boot.wasm eosio.boot.abi

# Wait a bit so accounts are really created and contract deployed
sleep 2

# Activate features
# ACTION_RETURN_VALUE
cleos push action eosio activate '["c3a6138c5061cf291310887c0b5c71fcaffeab90d5deb50d3b9e687cead45071"]' -p eosio
# GET_CODE_HASH
cleos push action eosio activate '["bcd2a26394b36614fd4894241d3c451ab0f6fd110958c3423073621a70826e99"]' -p eosio
# GET_BLOCK_NUM
cleos push action eosio activate '["35c2186cc36f7bb4aeaf4487b36e57039ccf45a9136aa856a5d569ecca55ef2b"]' -p eosio
# CRYPTO_PRIMITIVES
cleos push action eosio activate '["6bcb40a24e49c26d0a60513b6aeb8551d264e4717f306b81a37a5afb3b47cedc"]' -p eosio
# CONFIGURABLE_WASM_LIMITS2
cleos push action eosio activate '["d528b9f6e9693f45ed277af93474fd473ce7d831dae2180cca35d907bd10cb40"]' -p eosio
# BLOCKCHAIN_PARAMETERS
cleos push action eosio activate '["5443fcf88330c586bc0e5f3dee10e7f63c76c00249c87fe4fbf7f38c082006b4"]' -p eosio
# GET_SENDER
cleos push action eosio activate '["f0af56d2c5a48d60a4a5b5c903edfb7db3a736a94ed589d0b797df33ff9d3e1d"]' -p eosio
# FORWARD_SETCODE
cleos push action eosio activate '["2652f5f96006294109b3dd0bbde63693f55324af452b799ee137a81a905eed25"]' -p eosio
# ONLY_BILL_FIRST_AUTHORIZER
cleos push action eosio activate '["8ba52fe7a3956c5cd3a656a3174b931d3bb2abb45578befc59f283ecd816a405"]' -p eosio
# RESTRICT_ACTION_TO_SELF
cleos push action eosio activate '["ad9e3d8f650687709fd68f4b90b41f7d825a365b02c23a636cef88ac2ac00c43"]' -p eosio
# DISALLOW_EMPTY_PRODUCER_SCHEDULE
cleos push action eosio activate '["68dcaa34c0517d19666e6b33add67351d8c5f69e999ca1e37931bc410a297428"]' -p eosio
# FIX_LINKAUTH_RESTRICTION
cleos push action eosio activate '["e0fb64b1085cc5538970158d05a009c24e276fb94e1a0bf6a528b48fbc4ff526"]' -p eosio
# REPLACE_DEFERRED
cleos push action eosio activate '["ef43112c6543b88db2283a2e077278c315ae2c84719a8b25f25cc88565fbea99"]' -p eosio
# NO_DUPLICATE_DEFERRED_ID
cleos push action eosio activate '["4a90c00d55454dc5b059055ca213579c6ea856967712a56017487886a4d4cc0f"]' -p eosio
# ONLY_LINK_TO_EXISTING_PERMISSION
cleos push action eosio activate '["1a99a59d87e06e09ec5b028a9cbb7749b4a5ad8819004365d02dc4379a8b7241"]' -p eosio
# RAM_RESTRICTIONS
cleos push action eosio activate '["4e7bf348da00a945489b2a681749eb56f5de00b900014e137ddae39f48f69d67"]' -p eosio
# WEBAUTHN_KEY
cleos push action eosio activate '["4fca8bd82bbd181e714e283f83e1b45d95ca5af40fb89ad3977b653c448f78c2"]' -p eosio
# WTMSIG_BLOCK_SIGNATURES
cleos push action eosio activate '["299dcb6af692324b899b39f16d5a530a33062804e41f09dc97e9f156b4476707"]' -p eosio

# Wait a bit so features are really activated
sleep 2

# Deploy token smart contract
cleos set contract eosio.token /contracts eosio.token.wasm eosio.token.abi
# Deploy system smart contract
cleos set contract eosio /contracts eosio.system.wasm eosio.system.abi

# Wait a bit so contracts are really deployed
sleep 2

# Set up token
cleos push action eosio.token create '[ "eosio", "10000000000.00000000 WAX" ]' -p eosio.token@active
cleos push action eosio.token issue '[ "eosio", "10000000000.00000000 WAX", "initial" ]' -p eosio@active
cleos push action eosio init '["0", "8,WAX"]' -p eosio

# Create additional accounts
# atomicassets Ensure that the active permission is usable by the smart contract as well
cleos system newaccount --buy-ram-kbytes 10240 --stake-net "1.00000000 WAX" --stake-cpu "10.00000000 WAX" \
  eosio atomicassets EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV '{"keys":[{"key": "EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV","weight": 1}], "accounts": [{"permission": {"actor":"atomicassets", "permission":"eosio.code"}, "weight": 1}], "waits": [], "threshold": 1}'
cleos set contract atomicassets /contracts atomicassets.wasm atomicassets.abi
# Wait a bit for the contract to be really deployed
sleep 2
cleos push action atomicassets init '{}' -p atomicassets
cleos push action atomicassets admincoledit '{"collection_format_extension":[{"name":"name","type":"string"},{"name":"img","type":"ipfs"},{"name":"description","type":"string"},{"name":"url","type":"string"},{"name":"images","type":"string"},{"name":"socials","type":"string"},{"name":"creator_info","type":"string"}]}' -p atomicassets

# genialwombat
cleos system newaccount  --buy-ram-kbytes 1024 --stake-net "1.00000000 WAX" --stake-cpu "10.00000000 WAX" \
  eosio genialwombat EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

cleos transfer eosio genialwombat "1000.00000000 WAX"

# Wait a bit so last transactions are really seen by chain
sleep 2

# Cleanly shutdown nodeos
pkill nodeos
