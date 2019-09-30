FROM hyperledger/fabric-tools:1.4.1

WORKDIR /var/hyperledger/fabric/peer

ENV JSON_CONNECTION_DIR /var/hyperledger/fabric/peer/config

COPY ./ ./

RUN (cd ./chaincode/user-management; npm install)

RUN chmod +x scripts/*.sh

CMD ["/bin/bash"]