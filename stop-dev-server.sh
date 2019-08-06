cd ./hyperledger-fabric/dev-server

if [ ! -f run.pid ]; then
    echo "Server is already stopped!"
else
    kill -9 $(cat run.pid)
    rm -f run.pid

    bash stopFabric.sh
fi

cd ../../