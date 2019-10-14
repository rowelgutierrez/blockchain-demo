export BASE_DIR=$(pwd)

export WORKDIR=$BASE_DIR/hyperledger/fabric-network

cd $BASE_DIR/hyperledger/fabric-workspace/scripts

bash generate_certs.sh

cd $BASE_DIR