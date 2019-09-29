WORKING_DIR=$(pwd)
CRYPTO_CONFIG_DIR="${WORKING_DIR}/hyperledger/fabric-network/crypto-config"

cd $CRYPTO_CONFIG_DIR

ls -l && echo

# kubectl create configmap ca-config --from-file=hyperledger/fabric-network/crypto-config/peerOrganizations/org1.imfreemobile.com/ca/573828539f2bf796f3d7ab0b59deb58a70a5059c61653c071a8817a649c0e021_sk --from-file=hyperledger/fabric-network/crypto-config/peerOrganizations/org1.imfreemobile.com/ca/ca.org1.imfreemobile.com-cert.pem