#!/bin/bash

curl -s -u $SOLMGTUSR:$SOLMGTPASS -d "<rpc  semp-version=\"soltr/7_1_1\"><show><stats><client></client></stats></show></rpc>" http://$SOLMGT1:80/SEMP | grep "<total-clients>" | grep -Po '<.*?>\K.*?(?=<.*?>)'
