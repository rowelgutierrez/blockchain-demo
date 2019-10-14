#!/bin/bash
#
# Exit on first error, print all commands.
set -ev

export BASE_DIR=$(pwd)

export WORKDIR=$BASE_DIR/hyperledger/fabric-network

# Generate certs and artifacts
cd $BASE_DIR/hyperledger/fabric-workspace/scripts

bash generate_certs.sh

# Rename CA secret key
export CA_CERTS_DIR=$BASE_DIR/hyperledger/fabric-network/crypto-config/peerOrganizations/org1.imfreemobile.com/ca/
cd $CA_CERTS_DIR
export CA1_PRIVATE_KEY=$(ls *_sk)
mv $CA_CERTS_DIR/$CA1_PRIVATE_KEY $CA_CERTS_DIR/cert_sk

# *******************************************
# ************** Start network **************
# *******************************************
cd $BASE_DIR/hyperledger/fabric-network

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

docker exec cli bash /var/hyperledger/fabric/peer/scripts/init_chaincode.sh

cd ../../