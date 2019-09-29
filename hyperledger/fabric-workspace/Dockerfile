FROM hyperledger/fabric-tools:1.4.1

WORKDIR /var/hyperledger/fabric/peer

ENV JSON_CONNECTION_DIR /var/hyperledger/fabric/peer/config

COPY ./ ./

RUN chmod +x scripts/*.sh

CMD ["/bin/bash"]