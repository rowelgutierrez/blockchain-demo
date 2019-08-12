cd hyperledger-fabric/tutorial-network

export FABRIC_VERSION=hlfv12

composer archive create -t dir -n .

composer network install --card PeerAdmin@hlfv1 --archiveFile tutorial-network@0.0.1.bna
composer network start --networkName tutorial-network --networkVersion 0.0.1 --networkAdmin admin --networkAdminEnrollSecret adminpw --card PeerAdmin@hlfv1 --file networkadmin.card
composer card import --file networkadmin.card

# Test business network
composer network ping --card admin@tutorial-network

cd ../../