#!/bin/bash

curl -s -u $SOLMGTUSR:$SOLMGTPASS -d "<rpc  semp-version=\"soltr/7_1_1\"><show><message-spool><detail></detail></message-spool></show></rpc>" http://$SOLMGT1:80/SEMP | grep "<ingress-flow-count>" | grep -Po '<.*?>\K.*?(?=<.*?>)'
