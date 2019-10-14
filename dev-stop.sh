export BASE_DIR=$(pwd)

if [ "$1" = "reset" ]; then
    echo "Deleting certs and artifacts"

    cd $BASE_DIR/hyperledger/fabric-network

    rm -rf channel-artifacts/channel.tx
    rm -rf channel-artifacts/genesis.block
    rm -rf channel-artifacts/Org1MSPanchors.tx
    rm -rf crypto-config
    rm -rf lock

    cd ../../
fi

cd $BASE_DIR/hyperledger/fabric-network/scripts

docker-compose down -v

cd $BASE_DIR