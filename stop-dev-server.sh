cd ./hyperledger-fabric/dev-server

if [ -f run.pid ]; then
    kill -9 $(cat run.pid)
    rm -f run.pid
fi

export FABRIC_VERSION=hlfv12
bash stopFabric.sh

cd ../../