#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
# Exit on first error, print all commands.
set -ev

cd ./hyperledger/fabric-network

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1

docker-compose down

# docker-compose up -d
docker-compose -f docker-compose.yml up -d ca.imfreemobile.com orderer.imfreemobile.com peer0.org1.imfreemobile.com couchdb
docker ps -a

# wait for Hyperledger Fabric to start
# incase of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
export FABRIC_START_TIMEOUT=10
#echo ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT}

# Create the channel
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.imfreemobile.com/msp" peer0.org1.imfreemobile.com peer channel create -o orderer.imfreemobile.com:7050 -c userschannel -f /etc/hyperledger/configtx/channel.tx
# Join peer0.org1.imfreemobile.com to the channel.
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.imfreemobile.com/msp" peer0.org1.imfreemobile.com peer channel join -b userschannel.block
# Update peer anchor peers
# docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.imfreemobile.com/msp" peer0.org1.imfreemobile.com peer channel update -o orderer.imfreemobile.com:7050 -c userschannel -f /etc/hyperledger/configtx/Org1MSPanchors.tx

cd ../../