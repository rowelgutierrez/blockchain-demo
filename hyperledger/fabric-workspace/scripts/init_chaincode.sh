# Chaincode path
# CC_SRC_PATH=/opt/gopath/src/github.com/user-management
WORKDIR=/var/hyperledger/fabric/peer
AUTH_DIR=$WORKDIR/auth

if [ -z "${CC_SRC_PATH}" ]
then
    CC_SRC_PATH=$WORKDIR/chaincode
fi

if [ -z "${CHANNEL_ARTIFACTS_DIR}" ]
then
    CHANNEL_ARTIFACTS_DIR=$WORKDIR/channel-artifacts
fi

echo "Artifacts Directory: $CHANNEL_ARTIFACTS_DIR"

if [ "${DEV_MODE}" == "true" ]
then
    echo "####### DEV MODE"
    ORDERER_ADDRESS="orderer.imfreemobile.com"
else
    echo "####### PROD MODE"
    ORDERER_ADDRESS="orderer-imfreemobile-com"
fi

echo "Orderer Address: $ORDERER_ADDRESS"

SLEEP_TIMER=10

# Users channel name
USERS_CHANNEL=userschannel

MSG=$(peer channel getinfo -c userschannel)

if [[ $string != *"Invalid chain ID, userschannel"* ]]; then
    echo "Creating userschannel..."

    peer channel create -o $ORDERER_ADDRESS:7050 -c "$USERS_CHANNEL" -f $CHANNEL_ARTIFACTS_DIR/channel.tx

    echo "Joining userschannel..."

    peer channel fetch newest -o $ORDERER_ADDRESS:7050 -c "$USERS_CHANNEL"
    peer channel join -b $WORKDIR/$USERS_CHANNEL.block

    # rm -rf $WORKDIR/$USERS_CHANNEL.block

    echo "Updating peer anchor..."

    # Update peer anchor peer for Org1
    peer channel update -o $ORDERER_ADDRESS:7050 -c "$USERS_CHANNEL" -f $CHANNEL_ARTIFACTS_DIR/Org1MSPanchors.tx
else
    echo "Channel userschannel already exists!"
fi

# Install node_modules
echo "Installing auth node libraries..."

cd $AUTH_DIR
npm install

# Register admin user
echo "Registering users..."
node enrollAdmin.js
node registerSampleUser.js

echo "Installing chaincode node libraries..."
cd $CC_SRC_PATH/user-management
npm install

echo "Install chaincode $CC_SRC_PATH/user-management"

peer chaincode install -n userm -v 1.0 -p "$CC_SRC_PATH/user-management" -l node

echo "Instantiate chaincode in channel $USERS_CHANNEL"

peer chaincode instantiate -o "$ORDERER_ADDRESS:7050" -C "$USERS_CHANNEL" -n userm -l node -v 1.0 -c '{"Args":[]}' -P "AND ('Org1MSP.member')"
# peer chaincode instantiate -o orderer.example.com:7050 --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n mycc -l ${LANGUAGE} -v 1.0 -c '{"Args":["init","a","100","b","200"]}' -P "AND ('Org1MSP.peer','Org2MSP.peer')" >&log.txt

echo "Invoke user-management initLedger func"

peer chaincode invoke -o "$ORDERER_ADDRESS:7050" -C "$USERS_CHANNEL" -n userm -c '{"function":"initLedger","Args":[]}'

# Test chaincode