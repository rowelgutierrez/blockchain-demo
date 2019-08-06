cd ./hyperledger-fabric/dev-server

if [ ! -f run.pid ]; then
    export FABRIC_VERSION=hlfv11
    bash startFabric.sh
fi

PEER_CARD=DevServer_connection.json
if [ -f "$PEER_CARD" ]; then
    echo "$PEER_CARD already exists!"
else
    bash createPeerAdminCard.sh
fi

if [ ! -f run.pid ]; then
    nohup composer-playground > /dev/null 2>&1 & echo $! > run.pid
fi

cd ../../