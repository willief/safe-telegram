#! /bin/bash

# runs initial safe commands to start a clean network 
# create a DBC from which the faucet is topped up 

SAFE_ROOT=$HOME/.safe
SAFE_BIN=$SAFE_ROOT/cli
SAFE_NODE_BIN=$SAFE_ROOT/node

#clean up from any previous run
$SAFE_BIN/safe node killall
cd $SAFE_NODE_BIN
rm -vrf baby* local*
cd
$SAFE_BIN/safe config clear

#create DBC
mkdir -p $SAFE_ROOT/dbc_data
cp ~/josh.dbc $SAFE_ROOT/dbc_data/


#$SAFE_BIN/safe node install
$SAFE_BIN/safe node run-baby-fleming 
$SAFE_BIN/safe keys create --for-cli --json
FAUCET_WALLET_URL=$($SAFE_BIN/safe wallet create |echo $(grep -oP '(?<=Wallet created at:).*')) #--json) 
 
echo $FAUCET_WALLET_URL

$SAFE_BIN/safe wallet deposit --dbc $SAFE_ROOT/dbc_data/josh.dbc $FAUCET_WALLET_URL
$SAFE_BIN/safe wallet balance $FAUCET_WALLET_URL