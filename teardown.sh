composer card delete -c admin@user-management
composer card delete -c PeerAdmin@hlfv1

bash stop-dev-server.sh

cd ./hyperledger/fabric

bash teardownFabric.sh

bash teardownAllDocker.sh

rm -f DevServer_connection.json

cd ../../