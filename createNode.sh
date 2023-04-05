#!/bin/sh

# Script to start and set up a Leap node
# Partially see https://developers.eos.io/welcome/latest/tutorials/bios-boot-sequence
# and https://github.com/AntelopeIO/DUNE/blob/fd72ff4f581e48d2793a320d404bbb4a99673bd1/src/dune/dune.py
# Private keys used are "well known" keys. DO NOT USE ANY PUBLIC KEY FOR PRODUCTIVE USE CASES!

# Start node
echo Creating docker container
docker run --rm --detach --publish 6000:8888 --name test_wax_node ghcr.io/wombat-tech/leap:v3.2.3-1

echo Sleeping to wait for availability
sleep 3

# Protocol feature activation
echo Protocol feature activation
curl --noproxy -XPOST localhost:6000/v1/producer/schedule_protocol_feature_activations \
  -H 'Content-Type: application/json' \
  -d '{"protocol_features_to_activate":["0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"]}'

# Create default wallet
echo Creating wallet
docker exec test_wax_node cleos wallet create --to-console

# Import the private key for eosio from the leap Docker image
echo Importing private key
docker exec test_wax_node cleos wallet import --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3

# Create required accounts, all with the same private key
echo Creating accounts
docker exec test_wax_node cleos create account eosio eosio.token EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
docker exec test_wax_node cleos create account eosio eosio.bpay EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
docker exec test_wax_node cleos create account eosio eosio.names EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
docker exec test_wax_node cleos create account eosio eosio.ram EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
docker exec test_wax_node cleos create account eosio eosio.ramfee EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
docker exec test_wax_node cleos create account eosio eosio.saving EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
docker exec test_wax_node cleos create account eosio eosio.stake EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
docker exec test_wax_node cleos create account eosio eosio.vpay EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
docker exec test_wax_node cleos create account eosio eosio.rex EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

# Deploy boot smart contract
docker exec test_wax_node cleos set contract eosio /contracts eosio.boot.wasm eosio.boot.abi

# Activate features
# ACTION_RETURN_VALUE
docker exec test_wax_node cleos push action eosio activate '["c3a6138c5061cf291310887c0b5c71fcaffeab90d5deb50d3b9e687cead45071"]' -p eosio
# GET_CODE_HASH
docker exec test_wax_node cleos push action eosio activate '["bcd2a26394b36614fd4894241d3c451ab0f6fd110958c3423073621a70826e99"]' -p eosio
# GET_BLOCK_NUM
docker exec test_wax_node cleos push action eosio activate '["35c2186cc36f7bb4aeaf4487b36e57039ccf45a9136aa856a5d569ecca55ef2b"]' -p eosio
# CRYPTO_PRIMITIVES
docker exec test_wax_node cleos push action eosio activate '["6bcb40a24e49c26d0a60513b6aeb8551d264e4717f306b81a37a5afb3b47cedc"]' -p eosio
# CONFIGURABLE_WASM_LIMITS2
docker exec test_wax_node cleos push action eosio activate '["d528b9f6e9693f45ed277af93474fd473ce7d831dae2180cca35d907bd10cb40"]' -p eosio
# BLOCKCHAIN_PARAMETERS
docker exec test_wax_node cleos push action eosio activate '["5443fcf88330c586bc0e5f3dee10e7f63c76c00249c87fe4fbf7f38c082006b4"]' -p eosio
# GET_SENDER
docker exec test_wax_node cleos push action eosio activate '["f0af56d2c5a48d60a4a5b5c903edfb7db3a736a94ed589d0b797df33ff9d3e1d"]' -p eosio
# FORWARD_SETCODE
docker exec test_wax_node cleos push action eosio activate '["2652f5f96006294109b3dd0bbde63693f55324af452b799ee137a81a905eed25"]' -p eosio
# ONLY_BILL_FIRST_AUTHORIZER
docker exec test_wax_node cleos push action eosio activate '["8ba52fe7a3956c5cd3a656a3174b931d3bb2abb45578befc59f283ecd816a405"]' -p eosio
# RESTRICT_ACTION_TO_SELF
docker exec test_wax_node cleos push action eosio activate '["ad9e3d8f650687709fd68f4b90b41f7d825a365b02c23a636cef88ac2ac00c43"]' -p eosio
# DISALLOW_EMPTY_PRODUCER_SCHEDULE
docker exec test_wax_node cleos push action eosio activate '["68dcaa34c0517d19666e6b33add67351d8c5f69e999ca1e37931bc410a297428"]' -p eosio
# FIX_LINKAUTH_RESTRICTION
docker exec test_wax_node cleos push action eosio activate '["e0fb64b1085cc5538970158d05a009c24e276fb94e1a0bf6a528b48fbc4ff526"]' -p eosio
# REPLACE_DEFERRED
docker exec test_wax_node cleos push action eosio activate '["ef43112c6543b88db2283a2e077278c315ae2c84719a8b25f25cc88565fbea99"]' -p eosio
# NO_DUPLICATE_DEFERRED_ID
docker exec test_wax_node cleos push action eosio activate '["4a90c00d55454dc5b059055ca213579c6ea856967712a56017487886a4d4cc0f"]' -p eosio
# ONLY_LINK_TO_EXISTING_PERMISSION
docker exec test_wax_node cleos push action eosio activate '["1a99a59d87e06e09ec5b028a9cbb7749b4a5ad8819004365d02dc4379a8b7241"]' -p eosio
# RAM_RESTRICTIONS
docker exec test_wax_node cleos push action eosio activate '["4e7bf348da00a945489b2a681749eb56f5de00b900014e137ddae39f48f69d67"]' -p eosio
# WEBAUTHN_KEY
docker exec test_wax_node cleos push action eosio activate '["4fca8bd82bbd181e714e283f83e1b45d95ca5af40fb89ad3977b653c448f78c2"]' -p eosio
# WTMSIG_BLOCK_SIGNATURES
docker exec test_wax_node cleos push action eosio activate '["299dcb6af692324b899b39f16d5a530a33062804e41f09dc97e9f156b4476707"]' -p eosio

# Deploy token smart contract
docker exec test_wax_node cleos set contract eosio.token /contracts eosio.token.wasm eosio.token.abi
# Deploy system smart contract
# TODO This fails sometimes :(
docker exec test_wax_node cleos set contract eosio /contracts eosio.system.wasm eosio.system.abi

# Set up token
docker exec test_wax_node cleos push action eosio.token create '[ "eosio", "10000000000.00000000 WAX" ]' -p eosio.token@active
docker exec test_wax_node cleos push action eosio.token issue '[ "eosio", "10000000000.00000000 WAX", "initial" ]' -p eosio@active
# TODO This fails if eosio.system was not deployed correctly
docker exec test_wax_node cleos push action eosio init '["0", "8,WAX"]' -p eosio

# Node should be ready to use!
