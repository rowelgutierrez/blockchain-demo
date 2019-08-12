cd ./hyperledger-fabric/dev-server

#### version 1.4
# curl -sSL http://bit.ly/2ysbOFE | bash -s -- 1.4.1 1.2.1 0.4.15
################

#### version 1.2 & below
curl -O https://raw.githubusercontent.com/hyperledger/composer-tools/master/packages/fabric-dev-servers/fabric-dev-servers.tar.gz
tar -xvf fabric-dev-servers.tar.gz

rm -f fabric-dev-servers.tar.gz
export FABRIC_VERSION=hlfv12

chmod +x *.sh
bash downloadFabric.sh
########################

cd ../../