cd ./hyperledger-fabric/dev-server

kill -9 $(cat run.pid)
rm -f run.pid

bash stopFabric.sh

cd ../../