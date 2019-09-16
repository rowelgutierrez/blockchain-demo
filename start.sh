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
docker-compose -f docker-compose.yml up -d ca.imfreemobile.com orderer.imfreemobile.com peer0.org1.imfreemobile.com couchdb cli
docker ps -a

# wait for Hyperledger Fabric to start
# incase of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
export FABRIC_START_TIMEOUT=10
#echo ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT}

docker exec cli bash /var/hyperledger/scripts/cli_start.sh

cd ../../