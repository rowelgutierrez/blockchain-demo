MSG=$(peer channel getinfo -c userschannel)

if [[ $string != *"Invalid chain ID, userschannel"* ]]; then
    echo "Creating userschannel..."

    peer channel create -o orderer.imfreemobile.com:7050 -c userschannel -f /var/hyperledger/fabric/peer/channel-artifacts/channel.tx
    peer channel join -b userschannel.block

    # Update peer anchor peer for Org1
    peer channel update -o orderer.imfreemobile.com:7050 -c userschannel -f /var/hyperledger/fabric/peer/channel-artifacts/Org1MSPanchors.tx
else
    echo "Channel userschannel already exists!"
fi