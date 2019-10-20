export BASE_DIR=$(pwd)

shopt -s extglob

if [ "$1" = "reset" ]; then
    echo "Deleting certs and artifacts"

    cd $BASE_DIR/hyperledger/fabric-network

    rm -rf channel-artifacts/channel.tx
    rm -rf channel-artifacts/genesis.block
    rm -rf channel-artifacts/Org1MSPanchors.tx
    rm -rf crypto-config
    rm -rf lock
    rm -rf wallet/!(.gitkeep)

    cd $BASE_DIR/hyperledger/fabric-workspace
    rm *.block
fi

cd $BASE_DIR/hyperledger/fabric-network

docker-compose down -v
docker container rm $(docker ps -aq)
docker rmi fabric-network_api-server

cd $BASE_DIR