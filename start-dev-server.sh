cd ./hyperledger-fabric/dev-server

export FABRIC_VERSION=hlfv11
bash startFabric.sh

FILE=DevServer_connection.json
if [ -f "$FILE" ]; then
    echo "$FILE already exists!"
else
    bash createPeerAdminCard.sh
fi

nohup composer-playground > /dev/null 2>&1 & echo $! > run.pid

cd ../../