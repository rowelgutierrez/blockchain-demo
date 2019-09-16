# Chaincode path
CC_SRC_PATH=/opt/gopath/src/github.com/user-management

# Users channel name
USERS_CHANNEL=userschannel

MSG=$(peer channel getinfo -c userschannel)

if [[ $string != *"Invalid chain ID, userschannel"* ]]; then
    echo "Creating userschannel..."

    peer channel create -o orderer.imfreemobile.com:7050 -c "$USERS_CHANNEL" -f /var/hyperledger/fabric/peer/channel-artifacts/channel.tx
    peer channel join -b userschannel.block

    # Update peer anchor peer for Org1
    peer channel update -o orderer.imfreemobile.com:7050 -c "$USERS_CHANNEL" -f /var/hyperledger/fabric/peer/channel-artifacts/Org1MSPanchors.tx
else
    echo "Channel userschannel already exists!"
fi

# Install node_modules
cd /opt/gopath/src/github.com/user-management
npm install

# Register admin user
node enrollAdmin.js
node registerSampleUser.js

echo "Install chaincode $CC_SRC_PATH"
peer chaincode install -n userm -v 1.0 -p "$CC_SRC_PATH" -l node

echo "Instantiate chaincode in channel $USERS_CHANNEL"
peer chaincode instantiate -o orderer.imfreemobile.com:7050 -C "$USERS_CHANNEL" -n userm -l node -v 1.0 -c '{"Args":[]}' -P "AND ('Org1MSP.member')"
# peer chaincode instantiate -o orderer.example.com:7050 --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n mycc -l ${LANGUAGE} -v 1.0 -c '{"Args":["init","a","100","b","200"]}' -P "AND ('Org1MSP.peer','Org2MSP.peer')" >&log.txt
sleep 10

echo "Invoke user-management initLedger func"
peer chaincode invoke -o orderer.imfreemobile.com:7050 -C "$USERS_CHANNEL" -n userm -c '{"function":"initLedger","Args":[]}'

# Test chaincode