DOMAIN=imfreemobile.com
ORG1_DOMAIN="org1.${DOMAIN}"
ORDERER_DOMAIN="orderer.${DOMAIN}"
ADMIN_DOMAIN="Admin@${DOMAIN}"
ADMIN_ORG1_DOMAIN="Admin@${ORG1_DOMAIN}"
USER1_ORG1_DOMAIN="User1@${ORG1_DOMAIN}"
PEER_DOMAIN="peer0.$ORG1_DOMAIN"

WORKING_DIR=$(pwd)
# CRYPTO_CONFIG_DIR="${WORKING_DIR}/hyperledger/fabric-network/crypto-config"
CRYPTO_CONFIG_DIR="${WORKING_DIR}/crypto-config"

ORDERER_CONFIG_DIR="${CRYPTO_CONFIG_DIR}/ordererOrganizations/${DOMAIN}"
PEER_CONFIG_DIR="${CRYPTO_CONFIG_DIR}/peerOrganizations/${ORG1_DOMAIN}"

function createSecret() {
    SECRET_NAME=$1
    CURRENT_DIR=$2

    kubectl create secret generic $SECRET_NAME --from-file=$CURRENT_DIR
}

function createSecrets() {
    KEY=$1
    COMPONENT=$2
    CONFIG_DIR=$3
    CURR_DOMAIN=$4
    CURR_ADMIN_DOMAIN=$5

    createSecret "$KEY-ca" "$CONFIG_DIR/ca"

    createSecret "$KEY-msp-admincerts" "$CONFIG_DIR/msp/admincerts"
    createSecret "$KEY-msp-cacerts" "$CONFIG_DIR/msp/admincerts"
    createSecret "$KEY-msp-tlscacerts" "$CONFIG_DIR/msp/admincerts"

    createSecret "$KEY-$COMPONENT-msp-admincerts" "$CONFIG_DIR/${COMPONENT}s/$CURR_DOMAIN/msp/admincerts"
    createSecret "$KEY-$COMPONENT-msp-cacerts" "$CONFIG_DIR/${COMPONENT}s/$CURR_DOMAIN/msp/cacerts"
    createSecret "$KEY-$COMPONENT-msp-keystore" "$CONFIG_DIR/${COMPONENT}s/$CURR_DOMAIN/msp/keystore"
    createSecret "$KEY-$COMPONENT-msp-signcerts" "$CONFIG_DIR/${COMPONENT}s/$CURR_DOMAIN/msp/signcerts"
    createSecret "$KEY-$COMPONENT-msp-tlscacerts" "$CONFIG_DIR/${COMPONENT}s/$CURR_DOMAIN/msp/tlscacerts"
    createSecret "$KEY-$COMPONENT-tls" "$CONFIG_DIR/${COMPONENT}s/$CURR_DOMAIN/tls"

    createSecret "$KEY-tlsca" "$CONFIG_DIR/tlsca"

    createSecret "$KEY-admin-msp-admincerts" "$CONFIG_DIR/users/$CURR_ADMIN_DOMAIN/msp/admincerts"
    createSecret "$KEY-admin-msp-cacerts" "$CONFIG_DIR/users/$CURR_ADMIN_DOMAIN/msp/cacerts"
    createSecret "$KEY-admin-msp-keystore" "$CONFIG_DIR/users/$CURR_ADMIN_DOMAIN/msp/keystore"
    createSecret "$KEY-admin-msp-signcerts" "$CONFIG_DIR/users/$CURR_ADMIN_DOMAIN/msp/signcerts"
    createSecret "$KEY-admin-msp-tlscacerts" "$CONFIG_DIR/users/$CURR_ADMIN_DOMAIN/msp/tlscacerts"
    createSecret "$KEY-admin-tls" "$CONFIG_DIR/users/$CURR_ADMIN_DOMAIN/tls"
}

# DELETE EXISTING
# kubectl delete secrets $(kubectl get secret -o=jsonpath='{.items[?(@.type=="Opaque")].metadata.name}')

#*******************************************************
#******************* ORDERER SECRETS *******************
#*******************************************************
KEY="o-cert"
COMPONENT="orderer"
CONFIG_DIR=$ORDERER_CONFIG_DIR
CURR_DOMAIN=$ORDERER_DOMAIN
CURR_ADMIN_DOMAIN=$ADMIN_DOMAIN

createSecrets $KEY $COMPONENT $CONFIG_DIR $CURR_DOMAIN $CURR_ADMIN_DOMAIN

#*******************************************************
#********************* PEER SECRETS ********************
#*******************************************************
KEY="p-cert"
COMPONENT="peer"
CONFIG_DIR=$PEER_CONFIG_DIR
CURR_DOMAIN=$PEER_DOMAIN
CURR_ADMIN_DOMAIN=$ADMIN_ORG1_DOMAIN

createSecrets $KEY $COMPONENT $CONFIG_DIR $CURR_DOMAIN $CURR_ADMIN_DOMAIN

createSecret "$KEY-user1-msp-admincerts" "$CONFIG_DIR/users/$USER1_ORG1_DOMAIN/msp/admincerts"
createSecret "$KEY-user1-msp-cacerts" "$CONFIG_DIR/users/$USER1_ORG1_DOMAIN/msp/cacerts"
createSecret "$KEY-user1-msp-keystore" "$CONFIG_DIR/users/$USER1_ORG1_DOMAIN/msp/keystore"
createSecret "$KEY-user1-msp-signcerts" "$CONFIG_DIR/users/$USER1_ORG1_DOMAIN/msp/signcerts"
createSecret "$KEY-user1-msp-tlscacerts" "$CONFIG_DIR/users/$USER1_ORG1_DOMAIN/msp/tlscacerts"
createSecret "$KEY-user1-tls" "$CONFIG_DIR/users/$USER1_ORG1_DOMAIN/tls"

# SAVE SECRETS
SAVE_SECRETS_DIR="$WORKING_DIR/k8s/secrets"
for SECRET in $(kubectl get secret -o=jsonpath='{.items[?(@.type=="Opaque")].metadata.name}')
do
    kubectl get secrets $SECRET -o yaml > "$SAVE_SECRETS_DIR/$SECRET.yaml"
done

# CONFIGMAP ->>> EDIT DIRECTORY REFERENCES
SAVE_CONFIGMAP_DIR="$WORKING_DIR/k8s/configmap"
kubectl create configmap channel-artifacts --from-file=hyperledger/fabric-network/crypto-config/peerOrganizations/org1.imfreemobile.com/peers/peer0.org1.imfreemobile.com/msp/config.yaml --from-file=hyperledger/fabric-network/channel-artifacts -o yaml > "$SAVE_CONFIGMAP_DIR/channel-artifacts.yaml"