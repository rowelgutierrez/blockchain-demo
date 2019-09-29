# *********************#
# *******CA CERTS******#
# *********************#
cat hyperledger/fabric-network/crypto-config/peerOrganizations/org1.imfreemobile.com/ca/573828539f2bf796f3d7ab0b59deb58a70a5059c61653c071a8817a649c0e021_sk | base64 > k8s/certs-base64/ca_key
cat hyperledger/fabric-network/crypto-config/peerOrganizations/org1.imfreemobile.com/ca/ca.org1.imfreemobile.com-cert.pem | base64 > k8s/certs-base64/ca.pem

# *********************#
# ****ORDERER CERTS****#
# *********************#
# msp/admincerts
cat hyperledger/fabric-network/crypto-config/ordererOrganizations/imfreemobile.com/orderers/orderer.imfreemobile.com/msp/admincerts/Admin@imfreemobile.com-cert.pem | base64 > k8s/certs-base64/orderer_msp_admincerts.pem

# msp/cacerts
cat hyperledger/fabric-network/crypto-config/ordererOrganizations/imfreemobile.com/orderers/orderer.imfreemobile.com/msp/cacerts/ca.imfreemobile.com-cert.pem | base64 > k8s/certs-base64/orderer_msp_cacerts.pem

# msp/keystore
cat hyperledger/fabric-network/crypto-config/ordererOrganizations/imfreemobile.com/orderers/orderer.imfreemobile.com/msp/keystore/74e288fc83f0f1ca919607b4a70223a8f6ae344be01631d4dfed47281cccc395_sk | base64 > k8s/certs-base64/orderer_msp_keystore

# msp/signcerts
cat hyperledger/fabric-network/crypto-config/ordererOrganizations/imfreemobile.com/orderers/orderer.imfreemobile.com/msp/signcerts/orderer.imfreemobile.com-cert.pem | base64 > k8s/certs-base64/orderer_msp_signcerts.pem

# msp/tlscacerts
cat hyperledger/fabric-network/crypto-config/ordererOrganizations/imfreemobile.com/orderers/orderer.imfreemobile.com/msp/tlscacerts/tlsca.imfreemobile.com-cert.pem | base64 > k8s/certs-base64/orderer_msp_tlscacerts.pem

# tls/ca.crt
cat hyperledger/fabric-network/crypto-config/ordererOrganizations/imfreemobile.com/orderers/orderer.imfreemobile.com/tls/ca.crt | base64 > k8s/certs-base64/orderer_tls_ca.crt

# tls/server.crt
cat hyperledger/fabric-network/crypto-config/ordererOrganizations/imfreemobile.com/orderers/orderer.imfreemobile.com/tls/server.crt | base64 > k8s/certs-base64/orderer_tls_server.crt

# tls/server.key
cat hyperledger/fabric-network/crypto-config/ordererOrganizations/imfreemobile.com/orderers/orderer.imfreemobile.com/tls/server.key | base64 > k8s/certs-base64/orderer_tls_server.key
