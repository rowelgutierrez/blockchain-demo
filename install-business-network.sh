cd hyperledger/user-management

composer archive create -t dir -n .

composer network install --card PeerAdmin@hlfv1 --archiveFile user-management@0.0.1.bna
composer network start --networkName user-management --networkVersion 0.0.1 --networkAdmin admin --networkAdminEnrollSecret adminpw --card PeerAdmin@hlfv1 --file networkadmin.card
composer card import --file networkadmin.card

# Test business network
composer network ping --card admin@user-management

cd ../../