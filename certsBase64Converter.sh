# CA CERTS
cat hyperledger/fabric-network/crypto-config/peerOrganizations/org1.imfreemobile.com/ca/573828539f2bf796f3d7ab0b59deb58a70a5059c61653c071a8817a649c0e021_sk | base64 > k8s/certs-base64/ca_key
cat hyperledger/fabric-network/crypto-config/peerOrganizations/org1.imfreemobile.com/ca/ca.org1.imfreemobile.com-cert.pem | base64 > k8s/certs-base64/ca.pem

# ORDERER CERTS