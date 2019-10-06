function generateCerts() {
    which cryptogen
    if [ "$?" -ne 0 ]; then
        echo "cryptogen tool not found. exiting"
        exit 1
    fi
    echo
    echo "##########################################################"
    echo "##### Generate certificates using cryptogen tool #########"
    echo "##########################################################"

    if [ -d "crypto-config" ]; then
        rm -Rf crypto-config
    fi
    set -x
    cryptogen generate --config=$WORKDIR/crypto-config.yaml
    res=$?
    set +x
    if [ $res -ne 0 ]; then
        echo "Failed to generate certificates..."
        exit 1
    fi
    echo
}

function generateChannelArtifacts() {
    which configtxgen
    if [ "$?" -ne 0 ]; then
        echo "configtxgen tool not found. exiting"
        exit 1
    fi

    echo "##########################################################"
    echo "#########  Generating Orderer Genesis block ##############"
    echo "##########################################################"
    # Note: For some unknown reason (at least for now) the block file can't be
    # named orderer.genesis.block or the orderer will fail to launch!
    echo "CONSENSUS_TYPE="$CONSENSUS_TYPE
    set -x

    configtxgen -configPath $WORKDIR -profile OneOrgOrdererGenesis -channelID byfn-sys-channel -outputBlock $WORKDIR/channel-artifacts/genesis.block
    # configtxgen -profile OneOrgOrdererGenesis -outputBlock ./channel-artifacts/genesis.block

    # if [ "$CONSENSUS_TYPE" == "solo" ]; then
    #     configtxgen -profile TwoOrgsOrdererGenesis -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block
    # elif [ "$CONSENSUS_TYPE" == "kafka" ]; then
    #     configtxgen -profile SampleDevModeKafka -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block
    # elif [ "$CONSENSUS_TYPE" == "etcdraft" ]; then
    #     configtxgen -profile SampleMultiNodeEtcdRaft -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block
    # else
    #     set +x
    #     echo "unrecognized CONSESUS_TYPE='$CONSENSUS_TYPE'. exiting"
    #     exit 1
    # fi

    res=$?
    set +x
    if [ $res -ne 0 ]; then
        echo "Failed to generate orderer genesis block..."
        exit 1
    fi
    echo
    echo "#################################################################"
    echo "### Generating channel configuration transaction 'channel.tx' ###"
    echo "#################################################################"
    set -x
    # configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME

    configtxgen -configPath $WORKDIR -profile OneOrgChannel -outputCreateChannelTx $WORKDIR/channel-artifacts/channel.tx -channelID $CHANNEL_NAME
    res=$?
    set +x
    if [ $res -ne 0 ]; then
        echo "Failed to generate channel configuration transaction..."
        exit 1
    fi

    echo
    echo "#################################################################"
    echo "#######    Generating anchor peer update for Org1MSP   ##########"
    echo "#################################################################"
    set -x
    configtxgen -configPath $WORKDIR -profile OneOrgChannel -outputAnchorPeersUpdate $WORKDIR/channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
    res=$?
    set +x
    if [ $res -ne 0 ]; then
        echo "Failed to generate anchor peer update for Org1MSP..."
        exit 1
    fi
    echo
}

if [ ! -f "$WORKDIR/lock/certs.lock" ]; then
    export CHANNEL_NAME=userschannel

    echo "WORKDIR=$WORKDIR"
    echo "CHANNEL_NAME=$CHANNEL_NAME"

    generateCerts
    generateChannelArtifacts

    touch $WORKDIR/lock/certs.lock
fi
