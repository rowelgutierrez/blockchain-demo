cd ./hyperledger/fabric

if [ -f run.pid ]; then
    kill -9 $(cat run.pid)
    rm -f run.pid
fi

bash stopFabric.sh

cd ../../