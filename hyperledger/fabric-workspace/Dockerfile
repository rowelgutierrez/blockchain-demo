FROM hyperledger/fabric-tools:1.4.1

WORKDIR /var/hyperledger/fabric/peer

COPY ./ ./

ENV JSON_CONNECTION_DIR /var/hyperledger/fabric/peer/config
ENV WORKDIR /var/hyperledger/fabric/peer

RUN chmod +x scripts/*.sh

# RUN mkdir channel-artifacts crypto-config lock

CMD ["/bin/bash", "scripts/cli_start.sh"]