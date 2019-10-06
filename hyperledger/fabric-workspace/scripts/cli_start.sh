#!/bin/bash

bash $WORKDIR/scripts/generate_certs.sh

chmod a+rx $WORKDIR/channel-artifacts/* $WORKDIR/crypto-config/* -R

/bin/bash