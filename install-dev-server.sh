cd ./hyperledger-fabric/dev-server
curl -O https://raw.githubusercontent.com/hyperledger/composer-tools/master/packages/fabric-dev-servers/fabric-dev-servers.tar.gz
tar -xvf fabric-dev-servers.tar.gz

rm -f fabric-dev-servers.tar.gz
export FABRIC_VERSION=hlfv12

chmod +x *.sh
bash downloadFabric.sh

cd ../../